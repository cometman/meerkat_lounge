angular.module('app.meerkatSearch').filter 'trusted', [
  '$sce'
  ($sce) ->
    (url) ->
      $sce.trustAsResourceUrl url
]
