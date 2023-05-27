<?php

/*
 * Воркер который отправляет письма из очереди. Получает на вход offset и limit, блокирует диапазон и отправляет письма.
 * Можно запускать парралельно нескольно экземляров. Использует savepoint для предотвращения отправки дублирующих email.
 */

include '../connection.php';

/**
 * Функция заглушка для отправки имейла.
 * @param array $message
 *
 * @return bool
 */
function send_email(array $message): bool
{
    sleep(10);

    return true;
}

$con = get_connection();

$offset = $argv[1] ?? null;
$limit  = $argv[2] ?? null;

if (!$offset || !$limit) {
    // Write logs, send alerts
    exit();
}

if (!mysqli_begin_transaction($con)) {
    // Write logs, send alerts
    exit();
}

try {
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
                    LIMIT $offset, $limit
                    FOR UPDATE SKIP LOCKED -- Это позволит параллельно работающим скриптам mq_worker.php также получать записи и обрабатывать их.
              "
        ),
        MYSQLI_ASSOC
    );

    foreach ($messages as $message) {
        try {
            /* На какой-то из итераций send_email может отвалиться, тогда нужно закоммитить уже отмеченные is_sent=1 письма. Для этого используем savepoint. */
            mysqli_savepoint($con, 'send_email_savepoint');
            if (send_email($message)) {
                // Write logs
                mysqli_execute_query("UPDATE mailing_queue SET is_sent=1, send_attempts = send_attempts + 1, sent_at=NOW() WHERE id={$message['id']}");
            } else {
                mysqli_execute_query("UPDATE mailing_queue SET send_attempts = send_attempts + 1 WHERE id={$message['id']}");
            }
        } catch (Exception $e) {
            // Write logs, send alerts
            mysqli_rollback($con, 0, 'send_email_savepoint');
        }
        mysqli_release_savepoint($con, 'send_email_savepoint');
    }
} catch (Exception $e) {
    // Write logs, send alerts
    mysqli_rollback($con);
}

mysqli_commit($con);