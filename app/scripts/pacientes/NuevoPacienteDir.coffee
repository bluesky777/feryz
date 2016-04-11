angular.module('feryzApp')

.directive('nuevoPacienteDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/nuevoPacienteDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'

	controller: 'NuevoPacienteCtrl'
])

.controller('NuevoPacienteCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->

	$scope.guardarPaciente = ()->

		$http.post('::pacientes/guardar', $scope.pacienteNuevo ).then( (r)->
			console.log '$scope.pacienteNuevo',$scope.pacienteNuevo
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombres
			$scope.creando = false
			$scope.pacienteNuevo = 
				sexo: 'M'
				estereopsis: 'N' 
				test_color: 'N'
				sintomas_vision: []
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar paciente', r2
		)
		

		

])

