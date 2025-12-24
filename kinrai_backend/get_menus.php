<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include "db.php";

$sql = "SELECT 
          id,
          menu_name,
          calories,
          protein,
          fat,
          carbs,
          food_type,
          image_url
        FROM menus";

$result = $conn->query($sql);

$menus = [];

while ($row = $result->fetch_assoc()) {
    $menus[] = $row;
}

echo json_encode([
    "status" => true,
    "data" => $menus
]);

$conn->close();
