angular.module('feryzApp')

.directive('pacienteEditarDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/pacienteEditarDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'

	controller: 'PacienteEditarCtrl'
])

.controller('PacienteEditarCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
	
	$http.get('::antecedentes-laborales/all').then((r)->
		$scope.antecedentesLaborales = r.data
	, (r2)->
		console.log 'No se pudo traer los antecedentes', r2
	)

	$scope.actualizarPaciente = ()->
		console.log $scope.pacienteEdit
		$http.put('::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Paciente', r2
		)

	
])

