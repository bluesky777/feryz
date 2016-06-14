'use strict'

angular.module('feryzApp')

.controller('VerExamenIngresoCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'exameningreso', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, exameningreso) ->

		exameningreso.data.imagen.nombre = exameningreso.data.imagen.nombre + '?' + new Date().getTime()
		$scope.exameningreso = exameningreso.data


	]
)


