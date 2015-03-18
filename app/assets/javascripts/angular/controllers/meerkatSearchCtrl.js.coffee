# angular.module('app.meerkatSearch').controller("MeerkatSearchCtrl", [
#   '$scope',
#   ($scope, Restangular)->
#     console.log 'MeerkatSearchCtrl running'

#     $scope.exampleValue = "Hello angular and rails"

#     console.log Restangular.getList("streams")

# ])

@MeerkatSearchCtrl = ($scope, $window, Restangular) ->
  $scope.page = 1
  $scope.search = ''
  Restangular.all("api/streams").getList().then (data) ->
    console.log data
    $scope.streams = data
    return
  console.log 'MeerkatSearchCtrl wwow'

  angular.element($window).bind 'scroll', ->
    windowHeight = if 'innerHeight' in window then window.innerHeight else document.documentElement.offsetHeight
    body = document.body
    html = document.documentElement
    docHeight = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)
    windowBottom = windowHeight + window.pageYOffset
    if windowBottom >= (docHeight - 100)
      # Only bring in next page when the size of the array indciates we need to
      if ($scope.streams.length / 10) == $scope.page
        $scope.page += 1
        Restangular.all("api/streams").getList({page: $scope.page, q:$scope.search}).then (data) ->
          if data.length > 0
            if $scope.streams == undefined || $scope.streams.length == 0
              $scope.streams = data
            else
              Array.prototype.push.apply($scope.streams,data)
            $scope.$apply
            return

  $scope.$watch 'search', (search) ->
    if search.length > 2
      $scope.page = 1
      Restangular.all("api/streams").getList({q: search}).then (data) ->
        $scope.streams = data
        $scope.$apply
        return
    if search.length == 0
      $scope.page = 1
      Restangular.all("api/streams").getList().then (data) ->
        $scope.streams = data
        $scope.$apply
        return

  # $scope.$watch 'streams', (stream) ->

  #   stream_length = stream.length - 1
  #   if stream.length > 20
  #     videojs(stream[stream_length]._id, {
  #       'techOrder': [ 'flash' ]
  #       'controls': false
  #       'autoplay': false
  #       'preload': 'auto'
  #       'width': 300
  #       'height': 300
  #     }, ->
  #     )
  #     .on 'mouseout', (player) ->
  #       player.pause()
  #       return
  #     .on 'mouseover', (player) ->
  #       console.log player.currentTime()
  #       console.log player.duration()
  #       player.currentTime player.currentTime() + player.duration()
  #       player.play()
  #       return

    