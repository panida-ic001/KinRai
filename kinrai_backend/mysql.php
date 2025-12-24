<?php
$host = "localhost";
$user = "root";
$password = "1234";
$dbname = "kinrai";

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode([
        "status" => false,
        "message" => "Database connection failed"
    ]));
}

$conn->set_charset("utf8");
