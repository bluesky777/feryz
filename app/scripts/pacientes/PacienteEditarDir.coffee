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

		$http.put('::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Paciente', r2
		)



	$scope.upload = ()->
		file = $scope.vm.picture
		console.log file 
		if (file) 

			Upload.upload({
					url: "::imagenes/store",
					fields: {'Title': "test"},
					file: file,
					headers: {
						'Accept': 'application/json;odata=verbose', 'content-type': 'image/jpeg', 'X-RequestDigest': $("#__REQUESTDIGEST").val()
				}
			}).progress((evt)->
				progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
				console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
			).success((data, status, headers, config)->
				console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
			);

		

	
])

