'use strict'

angular.module('feryzApp')

.controller('VerUsuariosCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'usuarios', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, usuarios) ->

		$scope.usuarios = usuarios.data


	]
)


