# angular.module('app.meerkatSearch').controller("MeerkatSearchCtrl", [
#   '$scope',
#   ($scope, Restangular)->
#     console.log 'MeerkatSearchCtrl running'

#     $scope.exampleValue = "Hello angular and rails"

#     console.log Restangular.getList("streams")

# ])

@meerkatShowCtrl = ($scope, $window, Restangular) ->
  # videojs.options.flash.swf = "http://www.flashls.org/videojs/video-js.swf" 
  id = location.pathname.substr(9)
  source = "http://cdn.meerkatapp.co/broadcast/e37a64df-9723-4a99-ac5e-a867b7350931/live.m3u8"
  #window.location.href.substr(window.location.href.indexOf('?')+6) 
  videojs("player");
  Restangular.one("api/streams").get({id}).then (data) ->
    $scope.stream = data
    player = videojs("player");
  # debugger
  




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

    