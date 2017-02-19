angular.module('feryzApp')

.controller('ConfiguracionesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
		

	$scope.configuracion = { }


	$scope.guardar = (usu)->
		$http.put('::configuracion/actualizar', $scope.configuracion).then( (r)->
			toastr.success $scope.configuracion.nombre_ips+ ' "Actualizada correctamente"'
		, (r2)->
			toastr.error 'No se pudo Actualizar', 'Error'
			console.log 'No se pudo actualizar configuracion', r2
		)

	
	$scope.traerConfiguracion = ()->

		$http.get('::configuracion/all').then((r)->
			$scope.configuracion = r.data[0]
		, (r2)->
			console.log 'No se pudo traer la configuracion', r2
		)
	$scope.traerConfiguracion()	
	



])