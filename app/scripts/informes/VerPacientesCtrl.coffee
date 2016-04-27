'use strict'

angular.module('feryzApp')

.controller('VerPacientesCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'pacientes', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, pacientes) ->

		$scope.pacientes = pacientes.data
		

	]
)


