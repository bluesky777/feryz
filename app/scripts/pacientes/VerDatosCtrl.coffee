angular.module('feryzApp')

.directive('verDatosCtrl',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/verDatos.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'

	controller: 'VerDatosCtrl'
])

.controller('VerDatosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
	

	
])