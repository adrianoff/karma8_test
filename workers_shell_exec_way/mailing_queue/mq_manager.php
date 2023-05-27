<?php

/*
 * Менеджер который запускает пачку воркеров чтобы обработать mailing_queue.
 */

include '../connection.php';

$WORKER_BATCH_SIZE = 20;
$MAX_MAILS_TO_SEND = 100;

$con = get_connection();

$cnt = mysqli_fetch_assoc(
           mysqli_execute_query(
               $con,
               "SELECT COUNT(*) as cnt FROM mailing_queue WHERE is_sent=0 AND send_attempts >= 20"
           )
       )['cnt'];


// Запускаем K воркеров по $WORKER_BATCH_SIZE имейлов на отправку. Максимум $MAX_MAILS_TO_SEND.
// Например при $WORKER_BATCH_SIZE = 20 и $MAX_MAILS_TO_SEND = 100 будет запушено 5 воркеров.
for ($i = 0; $i < $MAX_MAILS_TO_SEND || $i < $cnt; $i += $WORKER_BATCH_SIZE) {
    $offset = $i;
    $limit  = $WORKER_BATCH_SIZE;
    shell_exec("php ./mq_worker.php $offset $limit 2>/dev/null >/dev/null &");
}