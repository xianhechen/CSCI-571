<?php
  header('Access-Control-Allow-Origin: *');
  header('Access-Control-Allow-Method:GET, POST');
  header('Access-Control-Allow-Headers:x-requested-with,content-type');

$keyword = "";
$type = "";
$fields = "";
$access_token = 'EAACxu1kZBnhMBADkNL93SOToHuupSjtmdFZBOWtrghZAWu6P2lGZCiaOfQnAQVOyQQnQfHpBnz9ei4tEOEs7652Rl4xR0D4MB0oimyC8sjivlEZAmoXVTPOSBBnh8XI6ZAdjXjSwr6UeixeIBs10uUxAMZCJ218nCUZD';

$users = array();
$users['data']=array();
$allData = array();

if (isset($_GET['keyword']) && !isset($_GET['lat']) && !isset($_GET['lon']) && $_GET['type'] == 'user') {

  $keyword = $_GET['keyword'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=user&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["user"]=json_decode($result);
  echo json_encode($allData);
}


if (isset($_GET['keyword']) && !isset($_GET['lat']) && !isset($_GET['lon']) && $_GET['type'] == 'page') {

  $keyword = $_GET['keyword'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=page&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["page"]=json_decode($result);
  echo json_encode($allData);
}

if (isset($_GET['keyword']) && !isset($_GET['lat']) && !isset($_GET['lon']) && $_GET['type'] == 'place') {

  $keyword = $_GET['keyword'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=place&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["place"]=json_decode($result);
  echo json_encode($allData);
}

if (isset($_GET['keyword']) && isset($_GET['lat']) && isset($_GET['lon']) && $_GET['type'] == 'place') {

  $keyword = $_GET['keyword'];
  $longitude = $_GET['lon'];
  $latitude = $_GET['lat'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=place&center=".$latitude.",".$longitude."&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["place"]=json_decode($result);
  echo json_encode($allData);
}


if (isset($_GET['keyword']) && !isset($_GET['lat']) && !isset($_GET['lon']) && $_GET['type'] == 'event') {

  $keyword = $_GET['keyword'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=event&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["event"]=json_decode($result);
  echo json_encode($allData);
}

if (isset($_GET['keyword']) && !isset($_GET['lat']) && !isset($_GET['lon']) && $_GET['type'] == 'group') {
  $keyword = $_GET['keyword'];
  //$type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=group&fields=".$fields."&access_token=".$access_token."&limit=10";
  $result = file_get_contents($url);
  $allData["group"]=json_decode($result);
  echo json_encode($allData);
}















if(isset($_GET['userid']) && isset($_GET['type'])) {
  $userID = $_GET['userid'];
  $type = $_GET['type'];
  $fields = "fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5)";
  $url = "https://graph.facebook.com/v2.8/".$userID."?".$fields."&access_token=".$access_token;
  $result = file_get_contents($url);
  echo $result;
}

if(isset($_GET['picid'])){
  $url = "https://graph.facebook.com/v2.8/".$_GET['picid']."/picture?redirect=false&access_token=".$access_token;
  echo $url."</br>";

  $result = file_get_contents($url);
  echo $result;
}


?>
