# angular.module('app.meerkatSearch').controller("MeerkatSearchCtrl", [
#   '$scope',
#   ($scope, Restangular)->
#     console.log 'MeerkatSearchCtrl running'

#     $scope.exampleValue = "Hello angular and rails"

#     console.log Restangular.getList("streams")

# ])

@MeerkatSearchCtrl = ($scope, $window, Restangular) ->
  $scope.streams = []
  $scope.page = 0
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
      $scope.page += 1
      Restangular.all("api/streams").getList({page: $scope.page, q:$scope.search}).then (data) ->
        if data.length > 0
          Array.prototype.push.apply($scope.streams,data)
          $scope.$apply
          return

  $scope.$watch 'search', (search) ->
    if search.length > 3
      Restangular.all("api/streams").getList({q: search}).then (data) ->
        $scope.streams = data
        $scope.$apply
        return
    if search.length == 0
      Restangular.all("api/streams").getList().then (data) ->
        $scope.streams = data
        $scope.$apply
        return
    