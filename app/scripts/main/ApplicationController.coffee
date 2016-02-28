'use strict'

angular.module('feryzApp')

.controller('ApplicationController', ['$scope', 'USER_ROLES', 'AuthService', 'toastr', '$state', '$rootScope', '$http', '$filter', ($scope, USER_ROLES, AuthService, toastr, $state, $rootScope, $http, $filter)->


	$scope.isAuthorized = AuthService.isAuthorized
	$scope.hasRoleOrPerm = AuthService.hasRoleOrPerm

	$scope.USER_ROLES = USER_ROLES

	$scope.isLoginPage = false

	$scope.main = 
		skin: 21


	$scope.navFull = true
	$scope.toggleNav = ()->
		$scope.navFull = !$scope.navFull


	
	$scope.tema = 'theme-zero'
	$scope.cambiarTema = (actual)->
		$scope.tema = actual


	$scope.floatingSidebar = 0
	$scope.toggleFloatingSidebar = ()->
		$scope.floatingSidebar = if $scope.floatingSidebar then false else true







])




