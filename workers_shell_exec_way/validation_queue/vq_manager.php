<?php

/*
 * Менеджер который запускает пачку воркеров чтобы обработать validation_queue.
 */

include '../connection.php';

$WORKER_BATCH_SIZE      = 20;
$MAX_EMAILS_TO_VALIDATE = 100;

$con = get_connection();

$cnt = mysqli_fetch_assoc(
           mysqli_execute_query(
               $con,
               "SELECT COUNT(*) as cnt FROM validation_queue WHERE checked=0"
           )
       )['cnt'];

// Запускаем K воркеров по $WORKER_BATCH_SIZE имейлов на валидацию. Максимум MAX_EMAILS_TO_VALIDATE.
// Например при $WORKER_BATCH_SIZE = 20 и $MAX_EMAILS_TO_VALIDATE = 100 будет запушено 5 воркеров.
for ($i = 0; $i < $MAX_EMAILS_TO_VALIDATE || $i < $cnt; $i += $WORKER_BATCH_SIZE) {
    $offset = $i;
    $limit  = $WORKER_BATCH_SIZE;
    shell_exec("php ./vq_worker.php $offset $limit 2>/dev/null >/dev/null &");
}