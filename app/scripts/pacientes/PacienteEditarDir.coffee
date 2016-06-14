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

.controller('PacienteEditarCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'Upload', ($scope, $http, App, $filter, toastr, Upload) ->
	
	$scope.actualizarPaciente = ()->

		console.log $scope.pacienteEdit

		$http.put('::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Paciente', r2
		)



	$scope.upload = ()->
		file = $scope.vm.picture
		
		if (file) 

			file = file.replace(/^data\:image\/\w+\;base64\,/, '')

			$http.post('::imagenes/store', {foto: file, paciente_id: $scope.pacienteEdit.id}).then( (r)->
				toastr.success 'Foto subida correctamente.'
			, (r2)->
				toastr.error 'No se pudo subir foto', 'Error'
			)


		

	
])

