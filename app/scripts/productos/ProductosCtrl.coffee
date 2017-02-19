angular.module('feryzApp')

.controller('ProductosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', ($scope, $http, App, $filter, toastr, AuthService, $uibModal) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.prodActualizar = {}
	$scope.unidades 	= [
		{unidad: '-'}
		{unidad: 'metros'}
		{unidad: 'rollos'}
	]
	$scope.categorias = []
	

	$scope.prodNuevo = { unidad: {unidad: '-'} }




	$scope.crearProducto = ()->
		$scope.creando = true
		$scope.editando = false

	$scope.guardarProducto = ()->
		$scope.guardando = true
		$http.post('::productos/guardar', $scope.prodNuevo ).then( (r)->
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo crear Producto', 'Error'
		)
		

	$scope.eliminarProducto = (prov)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==productos/removeProducto.tpl.html'
			controller: 'RemoveProductoCtrl'
			resolve: 
				producto: ()->
					prov
		})
		modalInstance.result.then( (producto)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+producto.id})
		)

	$scope.actualizarProducto = (prov)->
		$scope.guardando = true
		$http.put('::productos/actualizar', $scope.prodActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.prodActualizar.nombre
			$scope.editando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarProducto = (prov)->

		$scope.creando = false
		$scope.editando = true
		angular.copy prov, $scope.prodActualizar
		$scope.prodActualizar.anterior = prov

	
	$scope.traerProductos = ()->

		$http.get('::categorias/all').then((r)->
			$scope.categorias = r.data
		, (r2)->
			console.log 'No se pudo traer las categorías', r2
		)

		$http.get('::productos/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los productos', r2
		)
	$scope.traerProductos()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Modificar</a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarProducto(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 120, enableCellEdit: false }
			{field: 'nombre', minWidth: 100}
			{field: 'proveedor_id', displayName: 'Proveedor', minWidth: 100}
			{field: 'categoria_id', displayName: 'Categoría', minWidth: 100}
			{field: 'precio_compra'}
			{field: 'precio_venta'}
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				
				if newValue != oldValue

					$http.put('::productos/actualizar/' + rowEntity.id, rowEntity).then((r)->
						toastr.success 'Producto actualizado con éxito', 'Actualizado'
					, (r2)->
						toastr.error 'Cambio no guardado', 'Error'
						console.log 'Falló al intentar guardar: ', r2
					)

				$scope.$apply()
			)

	}

])

.controller('RemoveProductoCtrl', ['$scope', '$uibModalInstance', 'Producto', '$http', 'toastr', ($scope, $modalInstance, Producto, $http, toastr)->
	$scope.Producto = Producto

	$scope.ok = ()->

		$http.delete('::productos/destroy/'+Producto.id).then((r)->
			toastr.success 'Producto eliminado: '+Producto.nombre, 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar el Producto.'
		)
		$modalInstance.close(Producto)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

