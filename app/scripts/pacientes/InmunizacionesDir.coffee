angular.module('feryzApp')

.directive('inmunizacionesDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/inmunizacionesDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'InmunizacionesCtrl'
])

.controller('InmunizacionesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', '$uibModal', ($scope, $http, App, $filter, toastr, $modal) ->	

		$scope.inmuDatos = {}
		$scope.creandoInmunizacion = false

		$scope.eliminarInmunizacion = (inmunizacion)->
			
			modalInstance = $modal.open({
				templateUrl: '==pacientes/removeInmunizacion.tpl.html'
				controller: 'RemoveInmunizacionCtrl'
				resolve: 
					inmunizacion: ()->
						inmunizacion
			})
			modalInstance.result.then( (inmunizacion)->
				$scope.pacienteEdit.inmunizaciones = $filter('filter')($scope.pacienteEdit.inmunizaciones, {id: '!'+inmunizacion.id})
			)



		$scope.guardarInmunizacion = (inmunizacion)->
			$scope.creandoInmunizacion = true
			$scope.datosEnv = {}
			$scope.datosEnv.paciente_id = $scope.pacienteEdit.id

			$scope.datosEnv.vacuna_id = $scope.inmuDatos.vacuna.id
			
			$http.post('::inmunizaciones/guardar', $scope.datosEnv).then((r)->
				$scope.pacienteEdit.inmunizaciones.push r.data
				$scope.creandoInmunizacion = false
				toastr.success 'Cambios en inmunizaciones guardados.'
			, (r2)->
				toastr.error 'No se pudo agregar antecedente'
				$scope.creandoInmunizacion = false
			)

		$scope.modificarInmunizacion = (inmunizacion)->

			$http.put('::inmunizaciones/actualizar', inmunizacion).then((r)->
				toastr.success 'Modificado'
			, (r2)->
				toastr.error 'No se pudo modificar'
			)


])


.controller('RemoveInmunizacionCtrl', ['$scope', '$uibModalInstance', 'inmunizacion', '$http', 'toastr', ($scope, $modalInstance, inmunizacion, $http, toastr)->
	$scope.inmunizacion = inmunizacion

	$scope.ok = ()->

		$http.delete('::inmunizaciones/destroy/'+inmunizacion.id).then((r)->
			toastr.success 'Vacuna: '+inmunizacion.vacuna+' eliminada.', 'Eliminada'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar la vacuna.'
		)
		$modalInstance.close(inmunizacion)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

