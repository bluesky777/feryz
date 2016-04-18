angular.module('feryzApp')

.controller('ConfiguracionesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
		

	$scope.configuracion = { }


	$scope.paisSeleccionado = (pais, modelo)->
		$http.get('::ciudades/departamentos', {params: {pais_id: pais.id} }).then((r)->
			$scope.departamentos = r.data
			if $scope.configuracion.departamento
				$scope.configuracion.depart = $filter('filter')($scope.departamentos, { departamento: $scope.configuracion.departamento }, true)[0]
				$scope.departamentoSeleccionado($scope.configuracion.depart)
		, ()->
			toastr.error 'No se pudo traer los departamentos.'
		)

	$scope.departamentoSeleccionado = (depart, modelo)->
		$http.get('::ciudades/ciudades', {params: {departamento: depart.departamento} }).then((r)->
			$scope.ciudades = r.data
			if $scope.configuracion.ciudad_id
				$scope.configuracion.ciudad = $filter('filter')($scope.ciudades, { id: $scope.configuracion.ciudad_id }, true)[0]
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)


	$scope.eliminarConfiguracion = (usu)->
		
		$http.delete('::configuracion/eliminar/' + usu.id).then( (r)->
			$scope.usuarios = $filter('filter')($scope.usuarios, {id: '!'+usu.id})
		, (r2)->
			console.log 'No se pudo eliminar producto', r2
		)

	$scope.actualizarConfiguracion = (usu)->
		$http.put(App.Server + '::configuracion/actualizar', $scope.configuracion).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)

	
	$scope.traerConfiguracion = ()->

		$http.get('::configuracion/all').then((r)->
			$scope.configuracion = r.data[0]

			$http.get('::paises/all').then((r)->
				$scope.paises =  r.data
				$scope.configuracion.pais = $filter('filter')($scope.paises, { id: $scope.configuracion.pais_id }, true)[0]
				$scope.paisSeleccionado($scope.configuracion.pais)
			, ()->
				toastr.error 'No se pudo traer las ciudades.'
			)
		, (r2)->
			console.log 'No se pudo traer la configuracion', r2
		)
	$scope.traerConfiguracion()	
	



])