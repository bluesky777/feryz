'use strict'

angular.module('feryzApp')

.controller('VerProveedoresCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'proveedores', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, proveedores) ->

		$scope.proveedores = proveedores.data
		console.log $scope.proveedores

	]
)


