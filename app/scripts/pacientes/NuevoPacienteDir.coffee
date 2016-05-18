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
	
	$scope.imagesPath = App.images
	$scope.vm = {}

	$scope.guardarPaciente = ()->

		$http.post('::pacientes/guardar', $scope.pacienteNuevo ).then( (r)->

			$scope.opcionesGrid.data.push r.data
			toastr.success 'Ahora continua con los datos faltantes.'
			$scope.creando = false
			$scope.pacienteNuevo = 
				sexo: 'M'
				estereopsis: 'N' 
				test_color: 'N'
				sintomas_vision: []

			$scope.editarPaciente r.data
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)
		


])

