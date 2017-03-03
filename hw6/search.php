<?php
//session_start();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="format-detection" content="telephone=no">
    <style>
        html, body {
            width: 100%;
        }

        fieldset {
            margin: 0 auto;
            width: 50%;
            margin-bottom: 50px;
        }

        #usersTable, th, td {
            border-collapse: collapse;
            border: 1px solid black;
            margin: 0 auto;
            width: 60%;
            text-align: left;
        }

        #albumsButton, #postsButton {
            margin: 0 auto;
            width: 60%;
            text-align: center;
        }

        #albumsTable {
            border-collapse: collapse;
            border: 1px solid black;
            margin: 0 auto;
            width: 60%;
            text-align: left;
        }

        #postsTable {
            border-collapse: collapse;
            border: 1px solid black;
            margin: 0 auto;
            width: 60%;
            text-align: left;
        }



    </style>
    <script>
        function selectPlaces() {
            var selection = document.getElementById("type");
            if (selection.options[selection.selectedIndex].value == "place") {
                document.getElementById("locationDetails").innerHTML = '<label for="location">Location</label><input type="text" id="location" name="location" placeholder="Location" required>';
                document.getElementById("locationDetails").innerHTML += '<label for="distance"> Distance(meters)</label><input type="text" id="distance" name="distance" placeholder="Distance" required>'
            }
            else {
                document.getElementById("locationDetails").innerHTML = '';
            }
        }
        function resetForm() {
            window.location = "http://cs-server.usc.edu:16031/zuoyeliu/search.php";
        }

        function hideElement(target2, target1) {
            //target1 is the element getting hidden
                    //posts     //albums




            var x = document.getElementById(target1);//albums
            var y = document.getElementById(target2);//posts
            if (x.style.visibility == "hidden" && y.style.visibility == "hidden") {
                x.style.visibility = "visible";
                x.style.height = "auto";
            } else if (x.style.visibility == "visible" && y.style.visibility == "hidden") {
                x.style.visibility = "hidden";
                x.style.height = "0px";
            } else if (x.style.visibility == "hidden" && y.style.visibility == "visible") {
                y.style.visibility = "hidden";
                y.style.height = "0px";
            }


        }

        function toggle(target) {
            var x = document.getElementById(target);
            if (x.style.visibility == "hidden") {
                x.style.visibility = "visible";
                x.style.height = auto;
            } else {
                x.style.visibility = "hidden";
                x.style.height = "0px";
            }
        }


    </script>
</head>

<body>
<div class="mainpage">
<nav>

</nav>

<header class="main">

</header>

<form id = "request" class="request" method="post" action="http://cs-server.usc.edu:16031/zuoyeliu/search.php">
    <fieldset>
        <legend>Facebook Search</legend>
        <p>
            <label for="keyword">Keyword</label>
            <input type="text" id="keyword" name="keyword" placeholder="Keyword" required value="<?php
            if(isset($_POST['keyword'])) {
                echo htmlentities($_POST['keyword']);
            }
            else if(isset($_GET['keyword'])) {
                echo htmlentities($_GET['keyword']);
            }
            ?>">
        </p>
        <p>
            <label for="type">Type</label>
            <select id="type" name="type" onchange="selectPlaces()" >
                <option value="user" <?php if((isset($_POST['type'])&& $_POST['type']=='user') || (isset($_GET['type'])&& $_GET['type']=='user')) {echo 'selected="selected"';} ?>>Users</option>
                <option value="page" <?php if((isset($_POST['type'])&& $_POST['type']=='page') || (isset($_GET['type'])&& $_GET['type']=='page')) {echo 'selected="selected"';} ?>>Pages</option>
                <option value="event" <?php if((isset($_POST['type'])&& $_POST['type']=='event') || (isset($_GET['type'])&& $_GET['type']=='event')){echo 'selected="selected"';} ?>>Events</option>
                <option value="place" <?php if((isset($_POST['type'])&& $_POST['type']=='place') || (isset($_GET['type'])&& $_GET['type']=='place')){echo 'selected="selected"';} ?>>Places</option>
                <option value="group" <?php if((isset($_POST['type'])&& $_POST['type']=='group') || (isset($_GET['type'])&& $_GET['type']=='group')){echo 'selected="selected"';} ?>>Groups</option>
            </select>
        </p>
        <p id="locationDetails">
            <?php if((isset($_POST['type'])&& $_POST['type']=='place') || (isset($_GET['type'])&& $_GET['type']=='place')){
                if (isset($_POST['location'])){
                    $loc = htmlentities($_POST['location']);
                } else if (isset($_GET['location'])) {
                    $loc = htmlentities($_GET['location']);
                }
                if (isset($_POST['distance'])) {
                    $dist = htmlentities($_POST['distance']);
                } else if (isset($_GET['distance'])) {
                    $dist = htmlentities($_GET['distance']);
                }
                $html = <<<HTML
<label for="location">Location</label><input type="text" id="location" name="location" placeholder="Location" required value="$loc">
<label for="distance"> Distance(meters)</label><input type="text" id="distance" name="distance" placeholder="Distance" required value="$dist">
HTML;
                echo $html;
            } ?>
        </p>
        <p>
            <input type="submit" value="Search">
            <input type="button" value="Clear" onclick="resetForm()">
        </p>

    </fieldset>

    <div id="searchResult">
        <?php
        require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';
        $keyword = '';
        $type = '';
        $fields = '';
        $center = '';
        $distance = '';
        $access_token = 'EAACxu1kZBnhMBAFeLhHQbC1v46oD0qU0dtvLZAy0m0TGXhRXdggSzkf69U63KoQE8C7Sl86BpJJZCTsTvOylTiLyaLIJl3ZCARh5ZBf9Ad721r9qIZBdO3vJBcSENm0iVIb6xqj2NpLVWaKwTMPOtrSZAblVK5qqFIZD';
        $fb = new Facebook\Facebook([
            'app_id' => '195418214276627',
            'app_secret' => '990556fe84a777b6926f9c2df96bc7d6',
            'default_graph_version' => 'v2.8',
        ]);
        $fb->setDefaultAccessToken($access_token);

        function getResponse($request, $fb) {
            try {
                $response = $fb->getClient()->sendRequest($request);
            } catch(Facebook\Exceptions\FacebookResponseException $e) {
                // When Graph returns an error
                echo 'Graph returned an error: ' . $e->getMessage();
                exit;
            } catch(Facebook\Exceptions\FacebookSDKException $e) {
                // When validation fails or other local issues
                echo 'Facebook SDK returned an error: ' . $e->getMessage();
                exit;
            }
            $graphNode = $response->getDecodedBody();
            return $graphNode;
        }

        function displayResult($result,$token) {
            if (sizeof($result) == 1 && sizeof($result['data']) == 0) {
                echo "<p>No  Records  have  been found</p>";
            } else {
                $html = <<<HTML
                <table id='usersTable'>
                <tr>
                  <th>Profile Photo</th>
                  <th>Name</th>
                  <th>Detail</th>
                </tr>
HTML;
                echo $html;
                foreach ($result['data'] as $data) {
                    $pic_url = $data['picture']['data']['url'];
                    $locationP = '';
                    $distanceP = '';
                    if (isset($_POST['location']) && isset($_POST['distance'])) {
                        $locationP = $_POST['location'];
                        $distanceP = $_POST['distance'];
                    }
                    echo "<tr><td><a href=".$pic_url." target=\'_blank\'><img src='".$pic_url."' height='30px' width='30px'></a></td><td>".$data['name']."</td><td><a href='http://cs-server.usc.edu:16031/zuoyeliu/search.php?userid=".$data['id']."&keyword=".$_POST['keyword']."&type=".$_POST['type']."&location=".$locationP."&distance=".$distanceP."'> Details </a></td></tr>";
                }
                echo "</table>";
            }
        }

        function findCenter($string){
            $string = str_replace (" ", "+", urlencode($string));
            $details_url = "https://maps.googleapis.com/maps/api/geocode/json?address=".$string."&key=AIzaSyBSZNvwwsgMZf6a8l6-gtFAdLjus34W19I";
            $urlContent = json_decode(file_get_contents($details_url), true);
            $result = $urlContent['results'][0]['geometry']['location']['lat'].",".$urlContent['results'][0]['geometry']['location']['lng'];
            return $result;
        }





        if (isset($_GET['userid']) && isset($_GET['keyword'])) {
            //echo $_GET['userid'];
            $userID =  $_GET['userid'];
            //echo $_GET['keyword'];
            $detailsURL = "https://graph.facebook.com/v2.8/".$userID."?fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5)&access_token=".$access_token;
            $urlContent = json_decode(file_get_contents($detailsURL), true);
            //var_dump($urlContent);
            //echo "<div id='testArea'>";



            // commented for clean coding
            $albumsJSON = array();
            //var_dump($urlContent);
            if (isset($urlContent['albums'])){
                //echo "<table id='albumsTable'>";


                echo "<div id='albumsButton'><a href='#' onclick='hideElement(\"postsTable\",\"albumsTable\")'>Albums</a></div>";
                echo "<div id='albumsTable' style='visibility: hidden; height: 0px;'>";
                echo "<table id='albumsTable'>";
                //var_dump($urlContent);
                foreach ($urlContent['albums'] as $albums) {
                    //var_dump($albums);
                    for ($i=0; $i!=5; $i++) {
                        if (isset($albums[$i])) {
                            array_push($albumsJSON, $albums[$i]);
                        } else {
                        }
                    }
                }
                foreach ($albumsJSON as $album) {
                    //var_dump(sizeof($album['photos']['data']));
                    if (isset($album['name'])) {
                        if (isset($album['photos']['data'])){
                            echo "<tr><td>";
                            echo "<a href='#'>".$album['name']."</a></td></tr><tr><td>";
                            foreach ($album['photos']['data'] as $picture) {
                                if (isset($picture['picture']) && isset($picture['id'])) {
                                    $picID = $picture['id'];
                                    $hiResRequest = "https://graph.facebook.com/v2.8/".$picID."/picture?access_token=".$access_token;
                                    echo "<a href=".$hiResRequest." target='_blank'><img width='80px' height='80px' src=".$picture['picture']."></a>";
                                }
                            }
                            echo "</td></tr>";
                        }
                        else {
                            echo $album['name']."</br></br>";
                        }
                    }
                    //var_dump($album);
                    //echo "</br>";
                }
                echo "</table>";
                echo "</div>";
            } else {
                echo "<table id='albumsTable'>";
                echo "<div id='albums' style='visibility: hidden; height: 0px;'>";
                echo "</div>";
                echo "<th><p>No albums were found.</p></th></table>";
                //var_dump($urlContent);
            }
            echo "</div>";

            $postsJSON = array();
            if (isset($urlContent['posts'])){
                //echo "<table id='postsTable'>";

                echo "<div id='postsButton'><a href='#' onclick='hideElement(\"postsTable\",\"albumsTable\")'>Posts</a></div>";
                echo "<div id='postsTable' style='visibility: hidden; height: 0px;'>";
                echo "<table id='postsTable'>";
                //echo "</div>";
                //var_dump($urlContent['posts']);
                foreach ($urlContent['posts'] as $posts) {
                    //var_dump($posts);
                    for ($i=0; $i!=5; $i++) {
                        if (isset($posts[$i])) {
                            array_push($postsJSON, $posts[$i]);
                        }
                    }
                }
                foreach ($postsJSON as $post) {
                    if (isset($post['message'])) {
                        echo "<tr><td>".$post['message']."</td></tr>";
                    }
                }

            } else {
                echo "<table id='postsTable'>";
                echo "<div id='posts' style='visibility: hidden; height: 0px;'>";
                echo "</div>";
                echo "<th><p>No posts were found.</p></th></table>";
                //var_dump($urlContent);
            }

            echo "</div>";
            //var_dump($albumsJSON);
        } else {
            //echo "not found";
        }
        if ($_SERVER["REQUEST_METHOD"] == "POST") { //form submitted
            $keyword = $_POST['keyword'];
            $type = $_POST['type'];
            if ($type == 'place') {
                $center = $_POST['location'];
                $distance = $_POST['distance'];
                $latNlong = findCenter($center);
                $request = $fb->request('GET', '/search', ['q' => $keyword, 'type' => $type, 'center' => $latNlong, 'distance' => $distance, 'fields'=>'id,name,picture.width(700).height(700)']);
                $result = getResponse($request, $fb);
                displayResult($result, $access_token);
            }
            else {
                $request = $fb->request('GET', '/search', ['q' => $keyword, 'type' => $type, 'fields'=>'id,name,picture.width(700).height(700)']);
                $result = getResponse($request, $fb);
                displayResult($result, $access_token);
            }
        }
        ?>
    </div>
</form>

<footer>

</footer>

</div>

</body>
</html>
