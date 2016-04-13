angular.module('feryzApp')

.directive('accidentesTrabajoDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/accidentesTrabajoDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'AccidentesTrabajoCtrl'
])

.controller('AccidentesTrabajoCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->	

		$scope.creandoAccidTrabajo = false
		$scope.editandoAccidTrabajo = false
		$scope.AccidTrabajoNuevo = {}
		$scope.AccidTrabajoActual = {}


		$scope.editarAccidTrabajo = (antec)->
			$scope.editandoAccidTrabajo = true
			$scope.creandoAccidTrabajo = false
			$scope.AccidTrabajoActual = antec

		$scope.nuevoAccidTrabajo = (antec)->
			$scope.creandoAccidTrabajo = true
			$scope.editandoAccidTrabajo = false
			$scope.AccidTrabajoNuevo = {}


		$scope.guardarAccidenteTrabajo = ()->
			$scope.AccidTrabajoNuevo.paciente_id = $scope.pacienteEdit.id
			
			$http.post('::accidentes-trabajo/guardar', $scope.AccidTrabajoNuevo).then((r)->
				$scope.pacienteEdit.accidentesTrabajo.push r.data
				$scope.creandoAccidTrabajo = false
				$scope.AccidTrabajoNuevo = {}
				toastr.success 'Antecedente agregado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)

		$scope.actualizarAccidTrabajo = ()->

			$http.put('::accidentes-trabajo/actualizar', $scope.AccidTrabajoActual).then((r)->
				$scope.editandoAccidTrabajo = false
				toastr.success 'Antecedente actualizado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)


])
