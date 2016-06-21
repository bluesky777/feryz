angular.module('feryzApp')

.directive('diagnosticosDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/diagnosticosDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'diagnosticosCtrl'
])

.controller('diagnosticosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', '$uibModal', ($scope, $http, App, $filter, toastr, $modal) ->	



	$scope.guardarPaciente = ()->

		$http.post('::pacientes/guardar', $scope.pacienteNuevo ).then( (r)->

			$scope.opcionesGrid.data.push r.data
			toastr.success 'Ahora continua con los datos faltantes.'
			$scope.creando = false
			$scope.editarPaciente r.data
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)
		

])



