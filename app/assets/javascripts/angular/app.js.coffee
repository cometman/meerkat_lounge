@app = angular.module('app', ['templates','restangular'
])
		

# for compatibility with Rails CSRF protection

@app.config([
  '$httpProvider', ($httpProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  'restangular', (RestangularProvider)->
  	RestangularProvider.setBaseUrl('/api')
])

@app.run(->
  console.log 'angular app running'
)