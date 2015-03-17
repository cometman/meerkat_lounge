@meerkatSearch = angular
  .module('app.meerkatSearch', [
  	'restangular'
  ])
  .run(->
    console.log 'meerkatSearch running'
  )