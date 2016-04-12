angular.module('feryzApp')

.directive('antecedentesTrabajoDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/antecedentesTrabajoDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'AntecedentesTrabajoCtrl'
])

.controller('AntecedentesTrabajoCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->	

		$scope.creandoAccidTrabajo = false
		$scope.editandoAccidTrabajo = false
		$scope.AccidTrabajoNuevo = {}
		$scope.AccidTrabajoActual = {}


		$scope.editarAccidTrabajo = (antec)->
			$scope.editandoAccidTrabajo = true
			$scope.AccidTrabajoActual = antec

		$scope.nuevoAccidTrabajo = (antec)->
			$scope.creandoAccidTrabajo = true
			$scope.editandoAccidTrabajo = false
			$scope.AccidTrabajoNuevo = {}


		$scope.guardarAccidenteTrabajo = ()->
			$scope.AntecLaborNuevo.paciente_id = $scope.pacienteEdit.id
			
			$http.post('::accidentes-trabajo/guardar', $scope.AntecLaborNuevo).then((r)->
				$scope.pacienteEdit.antecedentesLaborales.push r.data
				$scope.creandoAntecLabor = false
				$scope.AntecLaborNuevo = {}
				toastr.success 'Antecedente agregado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)

		$scope.actualizarAntecLaboral = ()->

			$http.put('::accidentes-trabajo/actualizar', $scope.AntecLaborActual).then((r)->
				$scope.editandoAntecLabor = false
				toastr.success 'Antecedente actualizado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)


])
