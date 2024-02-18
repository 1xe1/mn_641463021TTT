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
        // Retrieve tourist attractions
        getAttractions();
        break;
    case 'POST':
        // Add a new tourist attraction
        addAttraction();
        break;
    case 'PUT':
        // Update an existing tourist attraction
        updateAttraction();
        break;
    case 'DELETE':
        // Delete a tourist attraction
        deleteAttraction();
        break;
    default:
        // Unsupported method
        http_response_code(405); // Method Not Allowed
        echo json_encode(array('message' => 'Unsupported HTTP method'));
        break;
}

function getAttractions() {
    global $conn;

    $sql = "SELECT * FROM touristattractions WHERE statusDelete='0'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $attractions = array();
        while ($row = $result->fetch_assoc()) {
            $attractions[] = $row;
        }
        echo json_encode($attractions);
    } else {
        echo json_encode(array('message' => 'No attractions found.'));
    }
}

function addAttraction() {
    global $conn;

    // Assuming JSON data is sent in the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['AttractionName']) && isset($data['Latitude']) && isset($data['Longitude'])) {
        $attractionName = $data['AttractionName'];
        $latitude = $data['Latitude'];
        $longitude = $data['Longitude'];

        $sql = "SELECT MAX(AttractionID) AS MAX_ID FROM touristattractions";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $Max_ID = $row['MAX_ID'] + 1;

        // Insert the new tourist attraction
        $insertSql = "INSERT INTO touristattractions (AttractionID,AttractionName, Latitude, Longitude) VALUES ('$Max_ID','$attractionName', '$latitude', '$longitude')";

        if ($conn->query($insertSql) === TRUE) {
            // Explicitly set HTTP status code to 200
            http_response_code(200);
            echo json_encode(array('message' => 'Tourist attraction added successfully.'));
        } else {
            // Explicitly set HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error adding tourist attraction: ' . $conn->error));
        }
    } else {
        // Explicitly set HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. AttractionName, Latitude, and Longitude are required.'));
    }
}

function updateAttraction() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['AttractionID']) && isset($data['AttractionName']) && isset($data['Latitude']) && isset($data['Longitude'])) {
        $attractionID = $data['AttractionID'];
        $attractionName = $data['AttractionName'];
        $latitude = $data['Latitude'];
        $longitude = $data['Longitude'];

        // Update the tourist attraction
        $updateSql = "UPDATE touristattractions SET AttractionName='$attractionName', Latitude='$latitude', Longitude='$longitude' WHERE AttractionID='$attractionID'";

        if ($conn->query($updateSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Tourist attraction updated successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error updating tourist attraction: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. AttractionID, AttractionName, Latitude, and Longitude are required.'));
    }
}

function deleteAttraction() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['AttractionID'])) {
        $attractionID = $data['AttractionID'];

        // Deleting the tourist attraction from the database
        $deleteSql = "UPDATE touristattractions SET statusDelete='1' WHERE AttractionID='$attractionID'";
        if ($conn->query($deleteSql) === TRUE) {
            // Setting HTTP status code to 200 for success
            http_response_code(200);
            echo json_encode(array('message' => 'Tourist attraction deleted successfully.'));
        } else {
            // Setting HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error deleting tourist attraction: ' . $conn->error));
        }
    } else {
        // Setting HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. AttractionID is required.'));
    }
}
?>
