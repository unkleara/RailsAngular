App = angular.module('RailsAngular', ['services.SharedServices'])

App.controller "MainCtrl", ["$scope", "$filter", "ServeMeVideos", ($scope, $filter, Video) ->
  $scope.loadVideos = ->
		
    url = "videos.json"
    Video.getVideos(url).then (response) ->
      $scope.videos = $scope.videos.concat(response.data.result)
     	$scope.status = "Displaying " + $filter("number")($scope.videos.length) + " videos"

  $scope.displayMore = (max) ->
    $scope.offset += 40
    $scope.max = max
    $scope.loadVideos()

  #Default params
  #$scope.offset = 0
  $scope.max = 40

  $scope.videos = []
  $scope.more = true
  $scope.status = ""
  $scope.loadVideos()
]
App.factory "ServeMeVideos", ["$http", ($http) ->
  getVideos: (url) ->
    $http.get url
]

angular.module("services.SharedServices", []).config(($httpProvider) ->
  $httpProvider.responseInterceptors.push "myHttpInterceptor"
  spinnerFunction = (data) ->
    $("#loading").show()
    data

  $httpProvider.defaults.transformRequest.push spinnerFunction
).factory "myHttpInterceptor", ($q, $window) ->
  (promise) ->
    promise.then ((response) ->
      $("#loading").hide()
      response
    ), (response) ->
      $("#loading").hide()
      $q.reject response

