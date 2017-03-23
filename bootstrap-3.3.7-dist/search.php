<?php
$keyword = "";
$type = "";
$fields = "";
$access_token = 'EAACxu1kZBnhMBADkNL93SOToHuupSjtmdFZBOWtrghZAWu6P2lGZCiaOfQnAQVOyQQnQfHpBnz9ei4tEOEs7652Rl4xR0D4MB0oimyC8sjivlEZAmoXVTPOSBBnh8XI6ZAdjXjSwr6UeixeIBs10uUxAMZCJ218nCUZD';
if (isset($_GET['keyword']) && isset($_GET['type'])) {
  $keyword = $_GET['keyword'];
  $type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".$keyword."&type=".$type."&fields=".$fields."&access_token=".$access_token;
  echo file_get_contents($url);

}
?>
