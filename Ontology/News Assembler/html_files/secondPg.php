<?php
/**
 * Created by PhpStorm.
 * User: amarv
 * Date: 3/10/2018
 * Time: 12:56 AM
 */

function generateModal($headline, $content, $id_link) {
    return '
        <!-- Modal -->
<div class="modal fade" id="'.$id_link.'" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">'.$headline.'</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        '.$content.'
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>';
}

$ied = $_GET['id'];

include ("top.php");
echo '<div class="container">
<div class="row">
  <div class="col-8">';

//col-8: left Side Column
include ("initdb.php");

$sql = "SELECT headline,content,entities_content FROM `articles_indianexp` WHERE id = " . $ied;
$result = $conn->query($sql);
$row = $result->fetch_assoc();
$headline = $row["headline"];
$content = $row["content"];
$ref_entities = $row["entities_content"];

echo "<h4 id='mainArticle'>" . $headline . "</h4>";
echo "<p id='mainContent'>" . $content . "</p>";

echo "<hr> <h5>Articles from other news sources on same News:</h5><br/>";

// Obtain IDs of related articles:
$con= mysqli_connect("localhost", "root", "","ontop2db");

// Obtain Article ID of The_Hindu
$query="SELECT * FROM articles_thehindu";
$result = mysqli_query($con,$query);

$id=[];
$count=[];
$c1=0;
$i=0;
$j=0;

while($it=mysqli_fetch_array($result))
{
    $token = strtok($ref_entities,",");
    $id[$c1]=$it[0];
    $count[$c1]=0;
    while ($token !== false)
    {
        $tags = explode(',',$it[3]);
        foreach($tags as $key)
        {
            if(strtolower(trim($token))===strtolower(trim($key)))
            {
                $count[$c1]=$count[$c1]+1;
                break;
            }
        }
        $token = strtok(",");
    }
    $c1=$c1+1;
}

for($i=0;$i<$c1-1;$i++)
{
    for($j=0;$j<$c1-1-$i;$j++)
    {
        if($count[$j]<$count[$j+1])
        {
            $temp=$count[$j];
            $count[$j]=$count[$j+1];
            $count[$j+1]=$temp;

            $temp=$id[$j];
            $id[$j]=$id[$j+1];
            $id[$j+1]=$temp;
        }
    }
}
//    echo "id count<br>";
//    for($i=0;$i<$c1;$i++)
//    {
//        if($count[$i]===0)
//            break;
//        else
//        {
//            echo "$id[$i] $count[$i]<br>";
//        }
//    }
$component_sql = "SELECT headline, content FROM `articles_thehindu` WHERE id=".$id[0];
$component_result = $conn->query($component_sql);
$component_row = $component_result->fetch_assoc();

$component_headline = $component_row['headline'];
$component_content = $component_row['content'];

echo '<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#thehindu">'.
  $component_headline
.'</button><br/><br/>';
echo generateModal($component_headline, $component_content, "thehindu");



// Obtain Article ID of TOI
$query="SELECT * FROM articles_toi";
$result = mysqli_query($con,$query);

$id=[];
$count=[];
$c1=0;
$i=0;
$j=0;

while($it=mysqli_fetch_array($result))
{
    $token = strtok($ref_entities,",");
    $id[$c1]=$it[0];
    $count[$c1]=0;
    while ($token !== false)
    {
        $tags = explode(',',$it[3]);
        foreach($tags as $key)
        {
            if(strtolower(trim($token))===strtolower(trim($key)))
            {
                $count[$c1]=$count[$c1]+1;
                break;
            }
        }
        $token = strtok(",");
    }
    $c1=$c1+1;
}

for($i=0;$i<$c1-1;$i++)
{
    for($j=0;$j<$c1-1-$i;$j++)
    {
        if($count[$j]<$count[$j+1])
        {
            $temp=$count[$j];
            $count[$j]=$count[$j+1];
            $count[$j+1]=$temp;

            $temp=$id[$j];
            $id[$j]=$id[$j+1];
            $id[$j+1]=$temp;
        }
    }
}
//    echo "id count<br>";
//    for($i=0;$i<$c1;$i++)
//    {
//        if($count[$i]===0)
//            break;
//        else
//        {
//            echo "$id[$i] $count[$i]<br>";
//        }
//    }
$component_sql = "SELECT headline, content FROM `articles_toi` WHERE id=".$id[0];
$component_result = $conn->query($component_sql);
$component_row = $component_result->fetch_assoc();

$component_headline = $component_row['headline'];
$component_content = $component_row['content'];

echo '<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#toi">'.
    $component_headline
    .'</button><br/>';
echo generateModal($component_headline, $component_content, "toi");

//echo '<div class="card card-1">'.preg_replace('/[^(:,‘’a-zA-Z-)]/i', " ", $headline).'</div><br>';


echo '</div>
  <div class="col-4">';

//col-4: Right Side Column
echo '<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Bangladesh pull off record chase against Sri Lanka after Mushfiqur Rahim heroics<a href="https://t.co/XevGcWUNJU">https://t.co/XevGcWUNJU</a></p>&mdash; Express Sports (@IExpressSports) <a href="https://twitter.com/IExpressSports/status/972539662442074113?ref_src=twsrc%5Etfw">March 10, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';

echo '<iframe src="https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Findianexpress%2Fposts%2F10156348882168826%2F&width=auto&show_text=true&appId=202572787159769&height=500&width=auto" width="348" height="500" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true"></iframe>';

echo '</div>
</div>';
include ("closedb.php");
include ("bottom.php");



//

//
//echo '<div id="articlesContainer">';
//include ("initdb.php");
//
//$sql = "SELECT entities_content FROM `articles_indianexp` WHERE id = " . $ied;
//$result = $conn->query($sql);
//$row = $result->fetch_assoc();
//$ref_entities =  $row['entities_content'];
////    echo '<div class="card card-1"><a href="secondPg.php?id='. $id .'">'.preg_replace('/[^(:,‘’a-zA-Z-)]/i', " ", $headline).'</a></div><br>';
//
//
//$con= mysqli_connect("localhost", "root", "","ontop2db");
//
//$articles=array("articles_thehindu","articles_toi");

//include ("closedb.php");
//echo '</div>';
//
