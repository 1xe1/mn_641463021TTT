<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: *");
include "../conn.php";

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getShops();
        break;
    case 'POST':
        addShop();
        break;
    case 'PUT':
        updateShop();
        break;
    case 'DELETE':
        deleteShop();
        break;
    default:
        http_response_code(405);
        echo json_encode(array('message' => 'Unsupported HTTP method'));
        break;
}

function getShops() {
    global $conn;

    $sql = "SELECT * FROM shops WHERE statusDelete = 0";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $shops = array();
        while ($row = $result->fetch_assoc()) {
            $shops[] = $row;
        }
        echo json_encode($shops);
    } else {
        echo json_encode(array('message' => 'No shops found.'));
    }
}

function addShop() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ShopName'])) {
        $shopName = $data['ShopName'];
        
        $sql = "SELECT MAX(ShopID) AS MAX_ID FROM shops";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $Max_ID = $row['MAX_ID'] + 1;

        $insertSql = "INSERT INTO shops (ShopID,ShopName, statusDelete) VALUES ('$Max_ID','$shopName', 0)";

        if ($conn->query($insertSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Shop added successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error adding shop: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. ShopName is required.'));
    }
}

function updateShop() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ShopID']) && isset($data['ShopName'])) {
        $shopID = $data['ShopID'];
        $shopName = $data['ShopName'];

        $updateSql = "UPDATE shops SET ShopName='$shopName' WHERE ShopID='$shopID'";

        if ($conn->query($updateSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Shop updated successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error updating shop: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. ShopID and ShopName are required.'));
    }
}

function deleteShop() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ShopID'])) {
        $shopID = $data['ShopID'];

        $deleteSql = "UPDATE shops SET statusDelete=1 WHERE ShopID='$shopID'";
        if ($conn->query($deleteSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Shop deleted successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error deleting shop: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. ShopID is required.'));
    }
}
?>
