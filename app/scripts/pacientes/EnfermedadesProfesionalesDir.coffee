angular.module('feryzApp')

.directive('enfermedadesProfesionalesDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/enfermedadesProfesionalesDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'EnfermedadesProfesionalesCtrl'
])

.controller('EnfermedadesProfesionalesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->	

		$scope.creandoEnferPro = false
		$scope.editandoEnferPro = false
		$scope.EnferProNuevo = {}
		$scope.EnferProActual = {}


		$scope.editarEnferPro = (antec)->
			$scope.editandoEnferPro = true
			$scope.creandoEnferPro = false
			$scope.EnferProActual = antec

		$scope.nuevoEnferPro = (antec)->
			$scope.creandoEnferPro = true
			$scope.editandoEnferPro = false
			$scope.EnferProNuevo = {}


		$scope.guardarEnfermedadProfesional = ()->
			console.log $scope.pacienteEdit.id
			$scope.EnferProNuevo.paciente_id = $scope.pacienteEdit.id
			
			$http.post('::enfermedades-profesionales/guardar', $scope.EnferProNuevo).then((r)->
				$scope.pacienteEdit.enfermedadesProfesionales.push r.data
				$scope.creandoEnferPro = false
				$scope.EnferProNuevo = {}
				toastr.success 'Enfermedad agregada'
			, (r2)->
				toastr.error 'No se pudo agregar Enfermedad'
			)

		$scope.actualizarEnferPro = ()->

			$http.put('::enfermedades-profesionales/actualizar', $scope.EnferProActual).then((r)->
				$scope.editandoEnferPro = false
				toastr.success 'Enfermedad actualizada'
			, (r2)->
				toastr.error 'No se pudo actualizar Enfermedad'
			)


])
