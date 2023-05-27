<?php

/*
 * Воркер который валидирует имейлы из очереди. Получает на вход offset и limit, блокирует диапазон и проверяет.
 * Можно запускать парралельно нескольно экземляров. Использует savepoint для предотвращения дублирующих проверок.
 */

include '../connection.php';

/**
 * Функция заглушка для валидации имейла (Худший случай)
 * @param array $message
 *
 * @return bool
 */
function check_email(array $message): bool
{
    sleep(60);

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
    $emails = mysqli_fetch_all(
        mysqli_execute_query(
            $con,
            "SELECT 
                        id, email
                    FROM 
                        validation_queue
                    WHERE 
                        checked=0
                    LIMIT $offset, $limit
                    FOR UPDATE SKIP LOCKED -- Это позволит параллельно работающим скриптам vq_worker.php также получать записи и обрабатывать их.
              "
        ),
        MYSQLI_ASSOC
    );

    foreach ($emails as $email) {
        try {
            /* На какой-то из итераций check_email может отвалиться, тогда нужно закоммитить уже отмеченные checked=1 записи. Для этого используем savepoint. */
            mysqli_savepoint($con, 'validate_email_savepoint');

            $is_valid = check_email($email['email']);
            mysqli_execute_query(
                $con,
                sprintf(
                    "UPDATE validation_queue SET checked=%s, valid=%s, checked_at = NOW() WHERE id=%s",
                    1,
                    $is_valid,
                    $email['id']
                )
            );
            mysqli_execute_query(
                $con,
                sprintf("UPDATE users SET checked=1, valid=%s WHERE email=%s", $is_valid, $email['email'])
            );
        } catch (Exception $e) {
            // Write logs, send alerts
            mysqli_rollback($con, 0, 'validate_email_savepoint');
        }
        mysqli_release_savepoint($con, 'validate_email_savepoint');
    }
} catch (Exception $e) {
    // Write logs, send alerts
    mysqli_rollback($con);
}

mysqli_commit($con);