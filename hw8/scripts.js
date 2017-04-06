(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) return;
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/es_LA/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));

$(function(){
 $("#tabs a:first").tab('show');
 var options = {
   enableHighAccuracy: true,
   timeout: 5000,
   maximumAge: 0
 };
 function success(pos) {
   var crd = pos.coords;
   var lat = crd.latitude;
   var lon = crd.longitude;
   console.log("Got location!");
   $('[ng-controller="bodyController"]').scope().lat = lat;
   $('[ng-controller="bodyController"]').scope().lon = lon;
 };
 function error(err) {
   console.warn(`ERROR(${err.code}): ${err.message}`);
 };
 function getLocation() {
   navigator.geolocation.getCurrentPosition(success, error, options);
 }
 getLocation();
});

$("#searchForm").submit(function(e) {
 e.preventDefault();
});

angular.module('app', ['ngAnimate'])
.directive('loading', function () {
    return {
      restrict: 'E',
      replace:true,
      template: '<div class="progress" id="loading-indicator" style="margin-top: 20%; margin-left: 100px; margin-right: 100px;"><div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100" style="width: 70%"><span class="sr-only" id="percentComplete">70% Complete</span></div></div>',
      link: function (scope, element, attr) {
            scope.$watch('loading', function (val) {
                if (val)
                    $(element).show();
                else
                    $(element).hide();
            });
      }
    }
})

.directive('detprogress', function () {
   return {
     restrict: 'E',
     replace:true,
     template: '<div class="progress" id="loading-indicator" style="margin-left: 10px; margin-right: 10px;"><div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100" style="width: 70%"><span class="sr-only" id="percentComplete">70% Complete</span></div></div>',
     link: function (scope, element, attr) {
           scope.$watch('detProgress', function (val) {
               if (val)
                   $(element).show();
               else
                   $(element).hide();
           });
     }
   }
 })

 .controller('bodyController', ['$scope','$http', function($scope, $http){
   $scope.lat = "34.02179";
   $scope.lon = "-118.28305"; //default values, will be changed by javascript function
   //details state machine
   $scope.showTable = false;
   $scope.showTable2 = false;
   $scope.showPagesTab = false;
   $scope.showPagesTab2 = false;
   $scope.showEventsTab = false;
   $scope.showEventsTab2 = false;
   $scope.showPlacesTab = false;
   $scope.showPlacesTab2 = false;
   $scope.showGroupsTab = false;
   $scope.showGroupsTab2 = false;
   $scope.hideThis = true;
   //table state machine
   $scope.showDetails = false;
   $scope.showPages = false;
   $scope.showPrev = false;
   $scope.showNext = false;
   $scope.detProgress = true;
   $scope.showPosts = false;
   $scope.showAlbums = false;
   $scope.showFav = false;
   $scope.showFav2 = false;
   $scope.showNoAlbum = false;
   $scope.showNoPost = false;
   //user information
   $scope.profile = "";
   $scope.name = "";
   $scope.prev = "";
   $scope.next = "";
   $scope.userPicHiRes = "";
   $scope.userName = "";
   $scope.userID = "";
   $scope.inFav = false;
   $scope.inUsers = true;
   $scope.inPages = false;
   $scope.inEvents = false;
   $scope.inPlaces = false;
   $scope.inGroups = false;
   $scope.allFavs =  [];
   $scope.currUserId = "";
   $scope.currUserPic = "";
   $scope.currUserName = "";

   if (localStorage.getItem('data') != null){
     $scope.allFavs = JSON.parse(localStorage.getItem("data"));
   }

   $scope.message = function (post) {
     if (post.message != null) {
       return post.message;
     }  else if (post.message == null && post.story != null) {
       return post.story;
     } else if (post.message == null && post.story == null) {
       return " ";
     }
   }

   $scope.toggle = function () {
    $scope.showTable = true;
    $scope.showDetails = false;
   }

   $scope.toggle2 = function (id, url, name) {
    $scope.showNoAlbum = false;
    $scope.showNoPost = false;
    $scope.currUserId = id;
    $scope.currUserPic = url;
    $scope.currUserName = name;
    $scope.allTabsFalse();
    $scope.hideThis = false;
    $scope.showDetails = true;
    $scope.detailPressed(id, url, name);
   }

   $scope.toggle3 = function () {
    $scope.showTable = false;
    $scope.showDetails = false;
    $scope.showFav = true;
   }

   $scope.toggle4 = function () {
     if ($scope.inFav == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showFav = true;
     } else if ($scope.inUsers == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showTable = true;
     } else if ($scope.inPages == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showPagesTab = true;
     } else if ($scope.inEvents == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showEventsTab = true;
     } else if ($scope.inPlaces == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showPlacesTab = true;
     } else if ($scope.inGroups == true) {
       $scope.allTabsFalse();
       $scope.hideThis = true;
       $scope.showGroupsTab = true;
     }
   }

   $scope.allTabsFalse = function () {
     $scope.showTable = false;
     $scope.showDetails = false;
     $scope.showFav = false;
     $scope.showPagesTab = false;
     $scope.showEventsTab = false;
     $scope.showPlacesTab = false;
     $scope.showGroupsTab = false;
   }

  $scope.printDetails = function (response, profile, name) {
    if (response['data']['albums'] != undefined) {
      $scope.jsonAlbums = response['data']['albums']['data'];
      $scope.showAlbums = true;
      $scope.showNoAlbum = false;
    } else {
      $scope.showNoAlbum = true;
      $scope.showAlbums = false;;
    }
    if (response['data']['posts'] != undefined) {
      $scope.jsonPosts = response['data']['posts']['data'];
      $scope.showPosts = true;
      $scope.showNoPost = false;
    } else {
      $scope.showNoPost = true;
      $scope.showPosts = false;
    }
    $scope.profile = profile;
    $scope.name = name;
  }

  $scope.search = function () {
    if ($('#keyword').val() != "") {
      $(function () {
        $('#keyword').tooltip('destroy');
      })
      $scope.loading = true;
      if ($('#tabs li.active a').attr('id') == 'user') {
        $scope.showTable = true;
      }
      $scope.showTable2 = false;
      $scope.showPagesTab2 = false;
      $scope.showEventsTab2 = false;
      $scope.showPlacesTab2 = false;
      $scope.showGroupsTab2 = false;
      var param = $('#keyword').val();
       $http({
         method: 'GET',
         url: 'http://csci571hw8.us-west-2.elasticbeanstalk.com/search.php?keyword='+param+'&lat='+$scope.lat+"&lon="+$scope.lon,
       }).then(function successCallback(response) {
         $scope.jsonRecordsUser = response['data']['user']['data'];
         $scope.jsonUserPaging = response['data']['user']['paging'];
         $scope.jsonRecordsPage = response['data']['page']['data'];
         $scope.jsonPagePaging = response['data']['page']['paging'];
         $scope.jsonRecordsEvent = response['data']['event']['data'];
         $scope.jsonEventPaging = response['data']['event']['paging'];
         $scope.jsonRecordsPlace = response['data']['place']['data'];
         $scope.jsonPlacePaging = response['data']['place']['paging'];
         $scope.jsonRecordsGroup = response['data']['group']['data'];
         $scope.jsonGroupPaging = response['data']['group']['paging']
         $scope.loading = false;
         $scope.showTable2 = true;
         $scope.showPagesTab2 = true;
         $scope.showEventsTab2 = true;
         $scope.showPlacesTab2 = true;
         $scope.showGroupsTab2 = true;
         if ($('#tabs li.active a').attr('id') == 'page') {
           $scope.showPagesTabFunc();
         } else if ($('#tabs li.active a').attr('id') == 'user') {
           $scope.showUsersTabFunc();
         } else if ($('#tabs li.active a').attr('id') == 'place') {
           $scope.showPlacesTabFunc();
         } else if ($('#tabs li.active a').attr('id') == 'event') {
           $scope.showEventsTabFunc();
         } else if ($('#tabs li.active a').attr('id') == 'group') {
           $scope.showGroupsTabFunc();
         } else if ($('#tabs li.active a').attr('id') == 'fav') {
           $scope.showFavoritesTab();
         }
       }, function errorCallback(response) {
       });
    } else {
      $(function () {
        $('#keyword').tooltip('show');
      })
    }
  }
  //pages for users
  $scope.nextPage = function () {
    $http({
      method: 'GET',
      url: $scope.next,
    }).then(function successCallback(response) {
      $scope.jsonRecordsUser = response['data']['data'];
      $scope.jsonUserPaging = response['data']['paging'];
      $scope.showUsersTabFunc();
    }, function errorCallback(response) {
    });
   }
   $scope.prevPage = function () {
     $scope.showUsersTabFunc();
      $http({
        method: 'GET',
        url: $scope.prev,
      }).then(function successCallback(response) {
        $scope.jsonRecordsUser = response['data']['data'];
        $scope.jsonUserPaging = response['data']['paging'];
        $scope.showUsersTabFunc();
      }, function errorCallback(response) {
      });
   }

   //pages for pages
   $scope.nextPagePage = function () {
     $scope.showPagesTabFunc();
      $http({
        method: 'GET',
        url: $scope.next,
      }).then(function successCallback(response) {
        $scope.jsonRecordsPage = response['data']['data'];
        $scope.jsonPagePaging = response['data']['paging'];
        $scope.showPagesTabFunc();
      }, function errorCallback(response) {
      });
   }
   $scope.prevPagePage = function () {
     $scope.showPagesTabFunc();
      $http({
        method: 'GET',
        url: $scope.prev,
      }).then(function successCallback(response) {
        $scope.jsonRecordsPage = response['data']['data'];
        $scope.jsonPagePaging = response['data']['paging'];
        $scope.showPagesTabFunc();
      }, function errorCallback(response) {
      });
   }

   //pages for events
   $scope.nextEventPage = function () {
      $http({
        method: 'GET',
        url: $scope.next,
      }).then(function successCallback(response) {
        $scope.jsonRecordsEvent = response['data']['data'];
        $scope.jsonEventPaging = response['data']['paging'];
        $scope.showEventsTabFunc();
      }, function errorCallback(response) {
      });
   }
   $scope.prevEventPage = function () {
     $scope.showEventsTabFunc();
      $http({
        method: 'GET',
        url: $scope.prev,
      }).then(function successCallback(response) {
        $scope.jsonRecordsEvent = response['data']['data'];
        $scope.jsonEventPaging = response['data']['paging'];
        $scope.showEventsTabFunc();
      }, function errorCallback(response) {
      });
   }

   //pages for places
   $scope.nextPlacePage = function () {
      $http({
        method: 'GET',
        url: $scope.next,
      }).then(function successCallback(response) {
        $scope.jsonRecordsPlace = response['data']['data'];
        $scope.jsonPlacePaging = response['data']['paging'];
        $scope.showPlacesTabFunc();
      }, function errorCallback(response) {
      });
   }
   $scope.prevPlacePage = function () {
     $scope.showPlacesTabFunc();
      $http({
        method: 'GET',
        url: $scope.prev,
      }).then(function successCallback(response) {
        $scope.jsonRecordsPlace = response['data']['data'];
        $scope.jsonPlacePaging = response['data']['paging'];
        $scope.showPlacesTabFunc();
      }, function errorCallback(response) {
      });
   }

   //pages for groups
   $scope.nextGroupPage = function () {
      $http({
        method: 'GET',
        url: $scope.next,
      }).then(function successCallback(response) {
        $scope.jsonRecordsGroup = response['data']['data'];
        $scope.jsonGroupPaging = response['data']['paging'];
        $scope.showGroupsTabFunc();
      }, function errorCallback(response) {
      });
   }
   $scope.prevGroupPage = function () {
     $scope.showGroupsTabFunc();
      $http({
        method: 'GET',
        url: $scope.prev,
      }).then(function successCallback(response) {
        $scope.jsonRecordsGroup = response['data']['data'];
        $scope.jsonGroupPaging = response['data']['paging'];
        $scope.showGroupsTabFunc();
      }, function errorCallback(response) {
      });
   }

   $scope.detailPressed = function (id, profile, name) {
     $scope.detProgress = true;
     $scope.showAlbums = false;
     $scope.showPosts = false;
     $scope.showFav = false;
     $scope.userPicHiRes = profile;
     $scope.userName = name;
     var param = id + "&type=" + $("ul#tabs li.active a").attr("id");
     $http({
       method: 'GET',
       url: 'http://csci571hw8.us-west-2.elasticbeanstalk.com/search.php?userid='+param,
     }).then(function successCallback(response) {
       $scope.printDetails(response, profile, name);
       $scope.detProgress = false;
     }, function errorCallback(response) {
     });
   }

   $scope.isFirstAlbum = function (index) {
     if (index == 1) {
       return "in";
     } else {
       return "";
     }
   }

   $scope.shareFB = function (picURL, name) {
     FB.init({
       appId: '195418214276627',
       status: true,
       cookie: true,
       xfbml: true,
       version: 'v2.8'
     });
     FB.ui({
        app_id:'195418214276627',
        method:'feed',
        link:window.location.href,
        picture:picURL,
        name:name,
        caption: 'FB SEARCH FROM USC CSCI571',
      }, function(response){
        if (response && ! response.error_message) {
          alert("Posted Successfully");
        }
        else {
          alert("Not Posted");
        }
      });
    }

    $scope.isStored = function (id) {
      if (typeof(Storage) !== "undefined") {
        for (var j = 0; j!=$scope.allFavs.length; j++) {
          if ($scope.allFavs[j]['id'] == id){
            return "glyphicon glyphicon-star";
          }
        }
        return "glyphicon glyphicon-star-empty";
      } else {
          alert("Sorry, your browser does not support Web Storage...");
      }
    }

    $scope.storeLocal = function (pic, name, id) {
      type = $('ul#tabs li.active a').attr('id');
      $scope.favInfo = {"id":id, "pic": pic, "name": name, "type": type+'s'};
      if (typeof(Storage) !== "undefined") {
        for (var j = 0; j!=$scope.allFavs.length; j++) {
          if ($scope.allFavs[j]['id'] == id){ //found, remove
            $scope.removeLocal(id);
            return;
          }
        }
        $scope.allFavs.push($scope.favInfo);
        localStorage.setItem("data", JSON.stringify($scope.allFavs));
      } else {
          alert("Sorry, your browser does not support Web Storage...");
      }
    }

    $scope.removeLocal = function (id) {
      $scope.allFavs = JSON.parse(localStorage.getItem("data"));
      for (var i = 0; i!=$scope.allFavs.length; i++) {
        if ($scope.allFavs[i]['id'] == id){
          break;
        }
      }
      if(i != -1) {
        $scope.allFavs.splice(i, 1);
        localStorage.setItem("data", JSON.stringify($scope.allFavs));
      }
    }

    $scope.showUsersTabFunc = function () {
      $scope.setTabsFalse();
      $scope.showTable = true;
      $scope.inUsers = true;
      $scope.showPages = true;
      $scope.detProgress = true;
      $scope.hideThis = true;
      if ($scope.jsonUserPaging != undefined) {
        $scope.next = $scope.jsonUserPaging['next'];
        $scope.prev = $scope.jsonUserPaging['previous'];
        $scope.setPages($scope.jsonRecordsUser);
      } else {
        $scope.showNext = false;
      }
    }
    $scope.showPagesTabFunc = function() {
      $scope.setTabsFalse();
      $scope.showPagesTab = true;
      $scope.inPages = true;
      $scope.detProgress = true;
      $scope.showPages = true;
      $scope.hideThis = true;
      if ($scope.jsonPagePaging != undefined) {
        $scope.next = $scope.jsonPagePaging['next'];
        $scope.prev = $scope.jsonPagePaging['previous'];
        $scope.setPages($scope.jsonRecordsPage);
      } else {
        $scope.showNext = false;
      }
    }
    $scope.showEventsTabFunc = function() {
      $scope.setTabsFalse();
      $scope.inEvents = true;
      $scope.showPages = true;
      $scope.detProgress = true;
      $scope.showEventsTab = true;
      $scope.hideThis = true;
      if ($scope.jsonEventPaging != undefined) {
        $scope.next = $scope.jsonEventPaging['next'];
        $scope.prev = $scope.jsonEventPaging['previous'];
        $scope.setPages($scope.jsonRecordsEvent);
      } else {
        $scope.showNext = false;
      }
    }
    $scope.showPlacesTabFunc = function() {
      $scope.setTabsFalse();
      $scope.inPlaces = true;
      $scope.showPages = true;
      $scope.detProgress = true;
      $scope.showPlacesTab = true;
      $scope.hideThis = true;
      if ($scope.jsonPlacePaging != undefined) {
        $scope.next = $scope.jsonPlacePaging['next'];
        $scope.setPages($scope.jsonRecordsPlace);
      } else {
        $scope.showNext = false;
      }
    }
    $scope.showGroupsTabFunc = function () {
      $scope.setTabsFalse();
      $scope.inGroups = true;
      $scope.showPages = true;
      $scope.detProgress = true;
      $scope.showGroupsTab = true;
      $scope.hideThis = true;
      if ($scope.jsonGroupPaging != undefined) {
        $scope.next = $scope.jsonGroupPaging['next'];
        $scope.prev = $scope.jsonGroupPaging['previous'];
        $scope.setPages($scope.jsonRecordsGroup);
      } else {
        $scope.showNext = false;
      }
    }
    $scope.showFavoritesTab = function () {
      $scope.setTabsFalse();
      $scope.inFav = true;
      $scope.detProgress = true;
      $scope.showFav = true;
      $scope.hideThis = true;
    }

    $scope.clear = function() {
      $("#tabs a:first").tab('show');
      $scope.setEverythingToFalse();
      $scope.inUsers = true;
    }

    $scope.setPages = function (data) {
      if (data.length < 24) {
        $scope.showNext = false;
      } else {
        $scope.showNext = true;
      }
      if ($scope.prev == undefined) {
        $scope.showPrev = false;
      } else {
        $scope.showPrev = true;
      }
    }

    $scope.setTabsFalse = function () {
      $scope.inFav = false;
      $scope.inUsers = false;
      $scope.inPages = false;
      $scope.inEvents = false;
      $scope.inPlaces = false;
      $scope.inGroups = false;
      $scope.showPagesTab = false;
      $scope.showTable = false;
      $scope.showDetails = false;
      $scope.showPages = false;
      $scope.detProgress = false;
      $scope.showPages = false;
      $scope.showPosts = false;
      $scope.showAlbums = false;
      $scope.showFav = false;
      $scope.showEventsTab = false;
      $scope.showPlacesTab = false;
      $scope.showGroupsTab = false;
    }

    $scope.setEverythingToFalse = function() {
      $scope.setTabsFalse();
      $scope.loading = false;
      $scope.showTable2 = false;
      $scope.showPagesTab2 = false;
      $scope.showEventsTab2 = false;
      $scope.showPlacesTab2 = false;
      $scope.showGroupsTab2 = false;
    }
 }])
