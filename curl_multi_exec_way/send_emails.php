<?php

$BATCH_SIZE = 20; // Количество записей на обработку. При увеличении количества писем в очереди можно увеличить.

$con = mysqli_connect(
    'karma8_test_mysql',
    'karma8_test',
    'karma8_test',
    'karma8_test',
    3306
);

if (!$con) {
    // Write logs, send alerts
    exit();
}

if (!mysqli_begin_transaction($con)) {
    // Write logs, send alerts
    exit();
}

try {
    // Получаем из очереди письма на отправку.
    $messages = mysqli_fetch_all(
        mysqli_execute_query(
            $con,
            "SELECT 
                        id, subject, from_email, to_email, body
                    FROM 
                        mailing_queue
                    WHERE 
                        is_sent=0 AND
                        send_attempts >= 20
                    LIMIT $BATCH_SIZE
                    FOR UPDATE SKIP LOCKED -- Это позволит параллельно работающим скриптам send_emails.php также получать записи и обрабатывать их.
              "
        ),
        MYSQLI_ASSOC
    );

    if (!$messages) {
        mysqli_commit($con);
        exit();
    }

    // Отправляем письма асинхронно.
    $responses = send_emails($messages);

    // Обрабатываем ответы и обновляем очередь проставляя is_sent=1.
    foreach ($responses as $response) {
        $id     = $response['id'];
        $status = $response['info']['http_code'] ? (int)$response['info']['http_code'] : null;

        if ($status === 200 || $status === 201) {
            mysqli_execute_query(
                $con,
                sprintf(
                    "UPDATE mailing_queue SET is_sent=1, send_attempts = send_attempts+1, sent_at='%s' WHERE id=%s",
                    date('Y-m-d H:i:s'),
                    $id
                )
            );
            echo "Message ID: $id was successfully sent.\n";
        } else {
            // Write logs, send alerts with $response['info'] and $response['content'] information
            echo "Message ID: $id ERROR.\n";
        }
    }
} catch (Exception $exception) {
    // Write logs, send alerts
    mysqli_rollback($con);
    exit();
}

mysqli_commit($con);


/**
 * Отправляет парралельно письма из $messages.
 *
 * @param array $messages
 *
 * @return array Возвращает массив ответов отсервера.
 */
function send_emails(array $messages): array
{
    $url       = "https://example.com/?from=%s&to=%s&subject=%s&text=%s";
    $mh        = curl_multi_init();
    $multiCurl = [];
    foreach ($messages as $message) {
        $i             = $message['id'];
        $multiCurl[$i] = curl_init();
        curl_setopt(
            $multiCurl[$i],
            CURLOPT_URL,
            sprintf(
                $url,
                urlencode($message['from_email']),
                urlencode($message['to_email']),
                urlencode($message['subject']),
                urlencode($message['body'])
            )
        );
        curl_setopt($multiCurl[$i], CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($multiCurl[$i], CURLOPT_TIMEOUT, 10);
        curl_multi_add_handle($mh, $multiCurl[$i]);
    }

    do {
        $status = curl_multi_exec($mh, $running);
        usleep(1000); // Чтобы избежать излишней нагрузки на процессор.
    } while ($status === CURLM_CALL_MULTI_PERFORM || $running);

    $responses = [];
    foreach ($multiCurl as $id => $ch) {
        $responses[] = [
            'id'      => $id,
            'info'    => curl_getinfo($ch),
            'content' => curl_multi_getcontent($ch),
        ];
        curl_multi_remove_handle($mh, $ch);
    }
    curl_multi_close($mh);

    return $responses;
}