<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT"); // Include PUT method
header("Access-Control-Allow-Headers: *");
include "../conn.php"; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Return a 200 OK response for the preflight request
    http_response_code(200);
    exit();
}

// Handle different HTTP methods
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Retrieve products
        getProducts();
        break;
    case 'POST':
        // Add a new product
        addProduct();
        break;
    case 'PUT':
        // Update an existing product
        updateProduct();
        break;
    case 'DELETE':
        // Delete a product
        deleteProduct();
        break;
    default:
        // Unsupported method
        http_response_code(405); // Method Not Allowed
        echo json_encode(array('message' => 'Unsupported HTTP method'));
        break;
}

function getProducts() {
    global $conn;

    $sql = "SELECT shops.ShopID,shops.ShopName,`ProductID`,`ProductName`,`Unit`,`Price` FROM products JOIN shops USING(ShopID)";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $products = array();
        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }
        echo json_encode($products);
    } else {
        echo json_encode(array('message' => 'No products found.'));
    }
}

function addProduct() {
    global $conn;

    // Assuming JSON data is sent in the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ShopID']) && isset($data['ProductName']) && isset($data['Unit']) && isset($data['Price'])) {
        $shopID = $data['ShopID'];
        $productName = $data['ProductName'];
        $unit = $data['Unit'];
        $price = $data['Price'];

        // Get the maximum ProductID and increment it by 1
        $sql = "SELECT MAX(ProductID) AS MAX_ID FROM products";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $productID = $row['MAX_ID'] + 1;

        // Insert the new product
        $insertSql = "INSERT INTO products (ShopID, ProductID, ProductName, Unit, Price) VALUES ('$shopID', '$productID', '$productName', '$unit', '$price')";

        if ($conn->query($insertSql) === TRUE) {
            // Explicitly set HTTP status code to 200
            http_response_code(200);
            echo json_encode(array('message' => 'Product added successfully.'));
        } else {
            // Explicitly set HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error adding product: ' . $conn->error));
        }
    } else {
        // Explicitly set HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. ShopID, ProductName, Unit, and Price are required.'));
    }
}
function updateProduct() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ProductID']) && isset($data['ShopID']) && isset($data['ProductName']) && isset($data['Unit']) && isset($data['Price'])) {
        $productID = $data['ProductID'];
        $shopID = $data['ShopID'];
        $productName = $data['ProductName'];
        $unit = $data['Unit'];
        $price = $data['Price'];

        // Update the product
        $updateSql = "UPDATE products SET ShopID='$shopID', ProductName='$productName', Unit='$unit', Price='$price' WHERE ProductID='$productID'";

        if ($conn->query($updateSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Product updated successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error updating product: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. ProductID, ShopID, ProductName, Unit, and Price are required.'));
    }
}

function deleteProduct() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['ProductID'])) {
        $productID = $data['ProductID'];

        // Deleting the product from the database
        $deleteSql = "UPDATE products SET statusDelete='1' WHERE ProductID='$productID'";
        if ($conn->query($deleteSql) === TRUE) {
            // Setting HTTP status code to 200 for success
            http_response_code(200);
            echo json_encode(array('message' => 'Product deleted successfully.'));
        } else {
            // Setting HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error deleting product: ' . $conn->error));
        }
    } else {
        // Setting HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. Product ID is required.'));
    }
}


?>
