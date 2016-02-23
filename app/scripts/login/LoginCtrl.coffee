'use strict'

angular.module('feryzApp')
.controller('LoginCtrl', ['$scope', '$rootScope', 'AUTH_EVENTS', 'AuthService', '$location', '$cookies', 'Perfil', 'App', '$state', 'cfpLoadingBar', ($scope, $rootScope, AUTH_EVENTS, AuthService, $location, $cookies, Perfil, App, $state, cfpLoadingBar)->
	
	
	$scope.logoPath = 'images/MyVc-1.gif'

	$scope.credentials = 
		username: ''
		password: ''


	cfpLoadingBar.complete()


	#$scope.host = $location.host()

	$scope.login = ()->

		user = AuthService.login_credentials($scope.credentials)
		
		user.then((r)->
			$state.go 'panel'
			return
		, (r2)->
			console.log 'Promise de login_credentials rechazada', r2
		)


	return

])