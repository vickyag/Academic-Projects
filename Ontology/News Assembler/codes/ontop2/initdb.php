<?php
/**
 * Created by PhpStorm.
 * User: amarv
 * Date: 3/5/2018
 * Time: 9:28 PM
 */
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "ontop2db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}