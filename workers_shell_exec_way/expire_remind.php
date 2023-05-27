<?php

include 'connection.php';

const BATCH_SIZE = 50;

$con = get_connection();

// По одной записи чтобы избежать лишних блокировок
for ($i = 0; $i < BATCH_SIZE; $i++) {
    if (!notify($con, '1day')) {
        break;
    }
}
for ($i = 0; $i < BATCH_SIZE; $i++) {
    if (!notify($con, '3day')) {
        break;
    }
}

/**
 * @param mysqli $con
 * @param string $expiredPeriod
 *
 * @return bool True если запись была добавлена в mailing_queue. False если записей добавлено не было, т.е. можно прекратить работу.
 */
function notify(mysqli $con, string $expiredPeriod): bool
{
    $notifyField = "expired_notified_$expiredPeriod";
    $seconds     = $expiredPeriod === '3day' ? 3*24*60*60 : 24*60*60;

    if (!mysqli_begin_transaction($con)) {
        // Write logs, send alerts
        exit();
    }

    try {
        // Выбираем по одной записи чтобы минимизировать блокировки.
        // В mysql 8.0 появилась полезная фича SKIP LOCKED. Это позволит параллельно работающим скриптам
        // expire_remind.php также получать записи. Таким образом это решение масштабируемо.
        //
        // Допустим у нас mysql 5.7 или другая БД неподдерживающая SKIP LOCKED. Тогда:
        // - Bводим в таблицу поле in_process. in_progress = 1 значит что запись в обработке и недоступна.
        // - Выбираем из таблицы в транзакции in_progress=0 AND expired_notified_1day=0 ... FOR UPDATE
        // - Cтавим in_progress=1
        // - Закрываем транзакцию.
        // - Записываем письмо в mailing_queue
        // - Ставим in_progress=0 и признак нотификации expired_notified_1day=1
        $userRow = mysqli_fetch_assoc(
            mysqli_execute_query(
                $con,
                "
                    SELECT 
                        id, email, username, valid, valid_ts
                    FROM 
                        users 
                    WHERE 
                        NOT (checked=1 AND valid=0) AND -- игнорируем проверенные и невалидные  
                        $notifyField=0 AND
                        valid_ts < UNIX_TIMESTAMP(NOW()) + $seconds
                        -- Здесь следует не забыть про составные индексы для ускорения выборки
                    ORDER BY valid_ts
                    LIMIT 1  
                    FOR UPDATE SKIP LOCKED
              "
            )
        );

        if (!$userRow) {
            return false;
        }

        [$id, $email, $username, $isValid, $validTs] = array_values($userRow);

        // Если имейл не проверялся на валидность, то ставим в очередь на проверку
        // На следющем запуске, после проверки, этот пользователь обработается и напоминание попадёт в mailing_queue
        // Предварительно проверяем нет ли уже этого имейла в очереди.
        if (!$isValid) {
            if(mysqli_fetch_assoc(
                mysqli_execute_query($con, "SELECT COUNT(*) FROM validation_queue WHERE email=$email")
            )['cnt'] === 0) {
                mysqli_execute_query(
                    $con,
                    sprintf(
                        "INSERT INTO validation_queue (email, created_at) VALUES (%s, %s)",
                        $email,
                        date('Y-m-d H:i:s')
                    )
                );

                mysqli_commit($con);

                return true;
            }
        }

        $text = sprintf("%s, your subscription is expiring soon", $username);
        $hash = md5(sprintf("%s|%s|%s|%s", $id, $email, $validTs, $notifyField)); // Хэш для уникальности письма в mailing_queue

        mysqli_execute_query(
            $con,
            sprintf(
                "INSERT INTO mailing_queue (subject, from_email, to_email, body, hash, created_at) VALUES ('%s','%s', '%s', '%s', '%s', '%s')",
                'Subscription notification reminder',
                'noreply@karma8.io',
                $email,
                $text,
                $hash,
                date('Y-m-d H:i:s')
            )
        );

        mysqli_execute_query(
            $con,
            "UPDATE users SET $notifyField=1 WHERE id=$id"
        );
    } catch (Exception $exception) {
        // Write logs, send alerts
        mysqli_rollback($con);
        exit();
    }

    // Write logs
    mysqli_commit($con);

    return true;
}