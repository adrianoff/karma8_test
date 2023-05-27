<?php

function get_connection(): mysqli
{
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

    return $con;
}