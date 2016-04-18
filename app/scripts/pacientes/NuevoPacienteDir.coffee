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

.controller('NuevoPacienteCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'Upload', ($scope, $http, App, $filter, toastr, Upload) ->
	
	$scope.imagesPath = App.images
	$scope.vm = {}

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

