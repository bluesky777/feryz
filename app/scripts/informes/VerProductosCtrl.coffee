'use strict'

angular.module('feryzApp')

.controller('VerProductosCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'productos', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, productos) ->

		$scope.productos = productos.data
		

	]
)


