'use strict'

angular.module('feryzApp')

.controller('VerExamenIngresoCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 'exameningreso', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter, exameningreso) ->

		$scope.exameningreso = exameningreso.data


	]
)


