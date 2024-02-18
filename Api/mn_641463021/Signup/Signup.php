<?php
header('Access-Control-Allow-Origin: *');
include '../conn.php';

$first_name = isset($_REQUEST['first_name']) ? $_REQUEST['first_name'] : '';
$last_name = isset($_REQUEST['last_name']) ? $_REQUEST['last_name'] : '';
$address = isset($_REQUEST['address']) ? $_REQUEST['address'] : '';
$phone_number = isset($_REQUEST['phone_number']) ? $_REQUEST['phone_number'] : '';
$email = isset($_REQUEST['email']) ? $_REQUEST['email'] : '';
$username = isset($_REQUEST['username']) ? $_REQUEST['username'] : '';
$password = isset($_REQUEST['password']) ? $_REQUEST['password'] : '';
$user_id = isset($_REQUEST['user_id']) ? $_REQUEST['user_id'] : '';
$no = 1;

//=== คำนวณหาเลขที่ ID ล่าสุด ===
$sql = "SELECT MAX(user_id) AS MAX_ID FROM users ";
$objQuery = mysqli_query($conn, $sql) or die(mysqli_error($conn));

while ($row1 = mysqli_fetch_array($objQuery)) {
    if ($row1["MAX_ID"] != "") {
        $no = $row1["MAX_ID"] + 1;
    }
}

$newno = "0000" . (string) $no;
$newno = substr($newno, -5);
$newuserid = $newno;

$sql = "INSERT INTO users(user_id, first_name, last_name, address, phone_number, email, username, password) VALUES ('$newuserid', '$first_name','$last_name','$address', '$phone_number', '$email', '$username',  '$password')";
mysqli_query($conn, $sql);
http_response_code(200);
?>
