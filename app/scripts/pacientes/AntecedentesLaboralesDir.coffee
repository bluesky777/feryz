angular.module('feryzApp')

.directive('antecedentesLaboralesDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/antecedentesLaborales.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'AntecedentesLaboralesCtrl'
])

.controller('AntecedentesLaboralesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->	

		$scope.creandoAntecLabor = false
		$scope.editandoAntecLabor = false
		$scope.AntecLaborNuevo = {}
		$scope.AntecLaborActual = {}


		$scope.editarAntecLabor = (antec)->
			$scope.editandoAntecLabor = true
			$scope.creandoAntecLabor = false
			$scope.AntecLaborActual = antec

		$scope.nuevoAntecLabor = (antec)->
			$scope.creandoAntecLabor = true
			$scope.editandoAntecLabor = false
			$scope.AntecLaborNuevo = {}


		$scope.guardarAntecedenteLaboral = ()->
			$scope.AntecLaborNuevo.paciente_id = $scope.pacienteEdit.id
			
			$http.post('::antecedentes-laborales/guardar', $scope.AntecLaborNuevo).then((r)->
				$scope.pacienteEdit.antecedentesLaborales.push r.data
				$scope.creandoAntecLabor = false
				$scope.AntecLaborNuevo = {}
				toastr.success 'Antecedente agregado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)

		$scope.actualizarAntecLaboral = ()->

			$http.put('::antecedentes-laborales/actualizar', $scope.AntecLaborActual).then((r)->
				$scope.editandoAntecLabor = false
				toastr.success 'Antecedente actualizado'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
			)


])
