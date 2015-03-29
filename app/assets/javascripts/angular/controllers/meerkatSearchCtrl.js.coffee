# angular.module('app.meerkatSearch').controller("MeerkatSearchCtrl", [
#   '$scope',
#   ($scope, Restangular)->
#     console.log 'MeerkatSearchCtrl running'

#     $scope.exampleValue = "Hello angular and rails"

#     console.log Restangular.getList("streams")

# ])

@meerkatSearchCtrl = ($scope, $window, Restangular) ->
  angular.element(document).ready ->
    

    $scope.page = 1
    $scope.search = ''
    $scope.allowRefresh = true
    $scope.streams = null
    $scope.searchstring = ''
    $scope.typeSelection = 'all'

    # videojs.options.flash.swf = "http://www.flashls.org/videojs/video-js.swf" 
    

    $scope.streamClick = (event, stream) ->
      console.log stream
      console.log event.currentTarget 
      if event.currentTarget.children[0].tagName == "IMG"
        unless /iPhone|iPad|iPod/i.test(navigator.userAgent)
          videojs.options.flash.swf = "http://www.flashls.org/videojs/video-js.swf"
          # unless /iPhone|iPad|iPod/i.test(navigator.userAgent)
          videojs.options.techOrder = ["flash"]
        event.currentTarget.innerHTML = "
          <video autoplay=true id='"+stream.stream_identifier+"' class='video-js vjs-default-skin' controls=true height='255' width='100%'>
            <source src='"+stream.playlist+"' type='video/mp4'></source>
          </video>"
        
        videojs(stream.stream_identifier) 
        return


    $scope.selectionClick = (selection) ->
      $scope.typeSelection = selection
      Restangular.all("api/streams").getList({q: $scope.search, t: $scope.typeSelection}).then (data) ->
        $scope.streams = data
        $scope.$apply
        return

    $scope.keyup = (keyevent) ->
      console.log('keyup', keyevent);
      return
    $scope.setId = (id) ->

      #videojs(id).ready ->
      ##  videoPlayer = this
      #  videoPlayer.on 'error', ->
      #    # error event listener
      ##    # dispose the old player and its HTML
      #   videoPlayer.dispose()
      #    # re-add the <video> element to the container
      #    jQuery('.video-container').append '<video id="' + id + '" controls autoplay class="video-js vjs-default-skin" preload="auto" data-setup="{}">' + '<source src="video.mp4" type="video/mp4" /></video>'
      ##    # force Flash as the only playback option
      #    videojs(id, 'techOrder': [ 'flash' ]).ready ->
      #      videoPlayer = this
      #      return
      #    return
      #  return



      unless /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
        setTimeout (->
          console.log "First time"
          videojs(id)
          return
        ), 3000
        return id
      return id
    # Check every 500ms to see if ID is set, once it is we can

    Restangular.all("api/streams").getList().then (data) ->
      console.log data
      $scope.streams = data
      $scope.$apply
      return

    angular.element($window).bind 'scroll', ->
      windowHeight = if 'innerHeight' in window then window.innerHeight else document.documentElement.offsetHeight
      body = document.body
      html = document.documentElement
      docHeight = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)
      windowBottom = windowHeight + window.pageYOffset
      # If user pulls all the way to the top, refresh the list
      if window.pageYOffset <= -5 && $scope.allowRefresh
        $scope.allowRefresh = false
        Restangular.all("api/streams").getList({q:$scope.search, t: $scope.typeSelection}).then (data) ->
          if data.length > 0
            if $scope.streams == undefined || $scope.streams.length == 0
              $scope.streams = data
            else
              # Make sure the data isn't already added
              # Loop through new data in reverse (newest will be at the front of our result) and compare to existing
              for d in data.reverse()
                match = false
                for o in $scope.streams
                  if o.stream_identifier == d.stream_identifier
                    match = true
                    break
                if match == false
                  $scope.streams.unshift(d)
            $scope.$apply
          $scope.allowRefresh = true
          return
      if windowBottom >= (docHeight - 100)
        # Only bring in next page when the size of the array indciates we need to
        if $scope.streams != null && ($scope.streams.length / 12) >= $scope.page - 1
          $scope.page += 1
          Restangular.all("api/streams").getList({page: $scope.page, q:$scope.search, t:$scope.typeSelection}).then (data) ->
            if data.length > 0
              if $scope.streams == undefined || $scope.streams.length == 0
                $scope.streams = data
              else
                for d in data.reverse()
                  match = false
                  for o in $scope.streams
                    if o.stream_identifier == d.stream_identifier
                      match = true
                      break
                  if match == false
                    $scope.streams.push(d)
                    $scope.$apply 
            return


    $scope.$watch 'search', (search) ->
      debugger
      setTimeout ( ->
        if search.length > 2 && $scope.recent_key_pressed == false
          $scope.page = 1
          Restangular.all("api/streams").getList({q: search, t: $scope.typeSelection}).then (data) ->
            $scope.streams = data
            $scope.$apply
            return
        if search.length == 0 
          $scope.page = 1
          Restangular.all("api/streams").getList().then (data) ->
            $scope.streams = data
            $scope.$apply
            return
      ), 3000

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

    