angular.module('app.meerkatSearch').directive 'lastRepeat', ->
    (scope, element, attrs) ->
      console.log "here"
      #if scope.$last
      #  for s in scope.streams
      #    if s.stream_identifier != null
      #      debugger
      #      videojs(s.stream_identifier)
      #return