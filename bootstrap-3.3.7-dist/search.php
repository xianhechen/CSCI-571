<?php
$keyword = "";
$type = "";
$fields = "";
$access_token = 'EAACxu1kZBnhMBADkNL93SOToHuupSjtmdFZBOWtrghZAWu6P2lGZCiaOfQnAQVOyQQnQfHpBnz9ei4tEOEs7652Rl4xR0D4MB0oimyC8sjivlEZAmoXVTPOSBBnh8XI6ZAdjXjSwr6UeixeIBs10uUxAMZCJ218nCUZD';

$users = array();
$users['data']=array();

if (isset($_GET['keyword']) && isset($_GET['type'])) {

  $keyword = $_GET['keyword'];
  $type = $_GET['type'];
  $fields = "id,name,picture.width(700).height(700)";
  $url = "https://graph.facebook.com/v2.8/search?q=".urlencode($keyword)."&type=".$type."&fields=".$fields."&access_token=".$access_token;
  $result = file_get_contents($url);
  echo $result;
  /*
  if (sizeof($result) == 1 && sizeof($result['data']) == 0) {
      echo "<table id='usersTable'><tr><th>No Records have been found</th></tr></table>";
  } else {
      if ($_GET['type'] == 'event') {
          echo displayTableHead();
          foreach ($result['data'] as $data) {
              $pic_url = $data['picture']['data']['url'];
              if (isset($data['place']['name'])) {
                  $eventLoc = $data['place']['name'];
                  echo "<tr><td><div onclick='openInNewTab(\"".$pic_url."\")'><img src='".$pic_url."' height='30px' width='30px'></div></td><td>".$data['name']."</td><td>".$eventLoc."</td></tr>";
              } else {
                  echo "<tr><td><div onclick='openInNewTab(\"".$pic_url."\")'><img src='".$pic_url."' height='30px' width='30px'></div></td><td>".$data['name']."</td><td></td></tr>";
              }
          }
      } else {
          foreach ($result['data'] as $data) {
              $user = array();
              $user['id']=$data['id'];
              $user['name']=$data['name'];
              $user['pic_url']=$data['picture']['data']['url'];
              array_push($users['data'], $user);
          }
          //print_r ($users);
          header('Content-Type: application/json');
          $done = json_encode($users,JSON_UNESCAPED_SLASHES);

          print_r($done);
      }

  }
  */
}
?>
