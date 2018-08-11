<?php
/**
 * Created by PhpStorm.
 * User: amarv
 * Date: 3/5/2018
 * Time: 6:49 PM
 */

echo '<div id="articlesContainer">';

include ("initdb.php");

$sql = "SELECT id,headline FROM `articles_indianexp`";
$result = $conn->query($sql);

while($row = $result->fetch_assoc()) {
    $headline = $row["headline"];
    $id = $row["id"];
    echo '<div class="card card-1"><a href="secondPg.php?id='. $id .'">'.preg_replace('/[^(:,‘’a-zA-Z-)]/i', " ", $headline).'</a></div><br>';
}

include ("closedb.php");

echo '</div>';