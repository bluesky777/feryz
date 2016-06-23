angular.module('feryzApp')

.directive('examenVisiometriaDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/examenVisiometriaDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'ExamenVisiometriaCtrl'
])

.controller('ExamenVisiometriaCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', '$uibModal', ($scope, $http, App, $filter, toastr, $modal) ->	


	$scope.modificarAntAudit = ()->

		$http.put('::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)


])



