<?php 

require("vendor/autoload.php");

# Imports the Google Cloud client library
use Google\Cloud\Language\LanguageClient;

# Your Google Cloud Platform project ID
$projectId = 'ontologyassignment2';
# Instantiates a client

#Database 

$servername = "192.168.0.2";
$username = "root";
$password="";
$dbname = "ontop2db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


$sql = "SELECT id,headline,content FROM articles_indianexp ";
$sql2 = "SELECT id,headline,content FROM articles_thehindu ";
$sql11 = "SELECT id,headline,content FROM articles_toi ";
$result = $conn->query($sql);
$result2 = $conn->query($sql2);
$result11 = $conn->query($sql11);

# Update entities in articles_indianexp table
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        #echo "id: " . $row["id"]. " - Headline: " . $row["headline"]. " " . "<br>";
        $headline = $row["headline"];
        $id = $row["id"];
        $content = $row['content'];

        $ent_headline= analyze_entities($headline,$id);
        $ent_content=analyze_entities($content,$id);

        $sql1 = " UPDATE articles_indianexp SET entities_headline='$ent_headline' WHERE id=$id ";
        $sql3 = "UPDATE articles_indianexp SET entities_content='$ent_content' WHERE id=$id";
         
        mysqli_query($conn,$sql1);
        mysqli_query($conn,$sql3);
        
        

        
    }
} 
# Update entities in articles_thehindu table
if($result2->num_rows > 0){
    while($row = $result2->fetch_assoc()){
        $headline1 = $row["headline"];
        $id1 = $row["id"];
        $content1 = $row['content'];

        $ent_headline1= analyze_entities($headline1,$id1);
        $ent_content1=analyze_entities($content1,$id1);

        $sql4 = " UPDATE articles_thehindu SET entities_headline='$ent_headline1' WHERE id=$id1 ";
        $sql5 = "UPDATE articles_thehindu SET entities_content='$ent_content1' WHERE id=$id1";

        mysqli_query($conn,$sql4);
        mysqli_query($conn,$sql5);
        

    }

}
# Update entities in articles_toi table
if($result11->num_rows > 0){
    while($row = $result11->fetch_assoc()){
        $headline2 = $row["headline"];
        $id2 = $row["id"];
        $content2 = $row['content'];

        $ent_headline2= analyze_entities($headline2,$id2);
        $ent_content2=analyze_entities($content2,$id2);

        $sql6 = " UPDATE articles_toi SET entities_headline='$ent_headline2' WHERE id=$id2 ";
        $sql7 = "UPDATE articles_toi SET entities_content='$ent_content2' WHERE id=$id2";

        mysqli_query($conn,$sql6);
        mysqli_query($conn,$sql7);
        
    }

}


#function for analysing entities using GOOGLE NL API

function analyze_entities($text,$id) {

$language = new LanguageClient([
    'projectId' => $projectId
]);


$annotation = $language->analyzeEntities($text);
$entities = $annotation->entities();

foreach ($entities as $entity) {
        printf($entity['name']);
        printf(",");
        $temp = $temp. "," . $entity['name'];

    }
    printf("\n");
    $temp = substr($temp,1);
    return $temp;
 

}

 