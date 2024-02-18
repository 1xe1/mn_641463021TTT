<?php
$conn = mysqli_connect("localhost", "root", "") or die("ไม่สามารถเชื่อมต่อฐานเข้ามูลได้");
mysqli_select_db($conn, "mn_641463021") or die("ไม่พบฐานข้อมูล");
mysqli_query($conn, "SET NAMES UTF8");
?>