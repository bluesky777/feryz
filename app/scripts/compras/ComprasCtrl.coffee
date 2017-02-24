angular.module('feryzApp')

.controller('ComprasCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', '$timeout', ($scope, $http, App, $filter, toastr, AuthService, $uibModal, $timeout) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.prodActualizar = {}

	$scope.mostrarPrecioVentaConIva = true
	$scope.compraNueva = { precio_venta: 0, fecha: new Date(), precio_compra: 0, cantidad: 1, iva: 0, codigo_barras: undefined }
	$scope.compraNuevaT = { precio_venta: 0, fecha: new Date(), precio_compra: 0, cantidad: 1, iva: 0, codigo_barras: undefined }

	# Para el date
	$scope.data = {} 
	$scope.dateOptions = 
		formatYear: 'yy'
	#$scope.compraNueva.fecha = new Date()


	
	$scope.ocultarNav() # Oculto la Navbar


	$scope.productos 			= []
	$scope.proveedores 			= []
	$scope.categorias 			= []
	$scope.codigos_barras 		= []
	$scope.productos_agregados 	= []

	
	$scope.traerDatos = ()->

		$http.put('::compras/datos').then((r)->
			r = r.data
			$scope.productos 	= r.productos
			$scope.proveedores 	= r.proveedores
			$scope.categorias 	= r.categorias
			$scope.codigos_barras 	= r.codigos_barras
			$scope.opcionesGrid.columnDefs[3].editDropdownOptionsArray = $scope.proveedores;
		, (r2)->
			toastr.error 'Error trayendo los datos.'
			console.log 'No se pudo traer los datos', r2
		)

	$scope.traerDatos()


	$scope.totalCompra = (primero)->
		if primero
			primero = false
			return 0
		else
			res = $scope.compraNueva.cantidad * $scope.compraNueva.precio_compra
			cres = $filter('currency')( res )
			return cres
	$scope.totalCompra(true)



	$scope.proveedorSeleccionado = ($item, $model)->
		if $item
			$scope.compraNueva.proveedor_id = $item.id
			$scope.$broadcast('focusOnCodigoBarras');


	$scope.codigoBarrasSeleccionado = ($item, $model)->
		if $item
			
			$timeout(()->
				$scope.focusOnPrecioCompra = true
			, 100)

			produc = $filter('filter')($scope.productos, {id: $item.id}, true )

			if produc.length > 0
				$scope.compraNueva.producto = produc[0]
				$scope.compraNueva.nombre = $scope.compraNueva.producto.nombre

			if $item.iva 
				$scope.compraNueva.iva = $item.iva
			else if $item.iva == 0
				$scope.compraNueva.iva = $item.iva

		else
			$scope.compraNueva.producto = undefined

	$scope.productoSeleccionado = ($item, $model)->
		if $item

			$scope.compraNueva.nombre = $scope.compraNueva.producto.nombre

			$timeout(()->
				$scope.focusOnPrecioCompra = true
			, 100)

			codigo = $filter('filter')($scope.codigos_barras, {id: $item.id}, true )
			if codigo.length > 0
				$scope.compraNueva.codigo_barras = codigo[0]
			else
				$scope.compraNueva.codigo_barras = undefined

			if $item.iva 
				$scope.compraNueva.iva = $item.iva
			else if $item.iva == 0
				$scope.compraNueva.iva = $item.iva

		else
			$scope.compraNueva.codigo_barras = undefined






	# Asignar iva al precio venta
	$scope.clickPrecioVentaConIva = (conIva)->
		console.log $scope.mostrarPrecioVentaConIva
		$scope.mostrarPrecioVentaConIva = false
		$scope.compraNueva.precio_venta = conIva

		$timeout(()->
			$scope.focusOnPrecioVenta = true
		)

		$timeout(()->
			$scope.mostrarPrecioVentaConIva = true
		, 1000)


	# Agregar producto a la grilla (a la compra)
	$scope.agregarProducto = ()->
		$scope.agregando_producto = true
		otro = {}
		angular.copy $scope.compraNueva, otro 
		$scope.productos_agregados.push otro

		$scope.opcionesGrid.data = $scope.productos_agregados
		console.log $scope.compraNueva

		# Para que no se borre el proveedor en el siguiente producto
		$scope.compraNuevaT.proveedor_id = $scope.compraNueva.proveedor_id
		$scope.compraNuevaT.proveedor = $scope.compraNueva.proveedor

		angular.copy $scope.compraNuevaT, $scope.compraNueva
		$scope.agregando_producto = false
		

	# Quitar producto de la compra
	$scope.quitarProducto = (prod)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==productos/removeProducto.tpl.html'
			controller: 'RemoveProductoCtrl'
			resolve: 
				producto: ()->
					prod
		})
		modalInstance.result.then( (producto)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+producto.id})
		)




	btn1 = '<span class="btn-group"><a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Edit</a>'
	btn2 = '<a class="btn btn-danger btn-xs" ng-click="grid.appScope.eliminarProducto(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a><span>'
	ivaEdit = '<div><form name="inputForm"><input ui-percentage-mask="0" ui-percentage-value type="INPUT_TYPE" ng-class="\'colt\' + col.uid" ui-grid-editor ng-model="MODEL_COL_FIELD" /></form</div>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		enableFiltering: true,
		enableCellEdit: true,
		enableCellEditOnFocus: true,
		columnDefs: [
			{field: 'No', width: 60, enableCellEdit: false, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex + 1}}</div>'}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 90, enableCellEdit: false, enableFiltering: false }
			{field: 'nombre', displayName: 'Producto', minWidth: 270 }
			{field: 'proveedor_id',	displayName: 'Proveedor',		cellFilter: 'mapProveedores:grid.appScope.proveedores',
			filter: {
				condition: (searchTerm, cellValue)->
					foundProveed 	= $filter('filter')($scope.proveedores, {nombre: searchTerm})
					actual 			= $filter('filter')(foundProveed, {id: cellValue}, true)
					return actual.length > 0;
			}
			editableCellTemplate: 'ui-grid/dropdownEditor', editDropdownIdLabel: 'id', editDropdownValueLabel: 'nombre', enableCellEditOnFocus: true }
			
			{field: 'iva', cellTemplate: '<div class="ui-grid-cell-contents">{{row.entity.iva}}%</div>', editableCellTemplate: ivaEdit }
			{field: 'precio_compra', cellFilter: 'currency', cellClass: 'grid-align-right'}
			{field: 'precio_venta', cellFilter: 'currency', cellClass: 'grid-align-right'}
			{field: 'cantidad', displayName: 'Cant', cellFilter: 'number', minWidth: 70}
			{displayName: 'Total', name: 'Total', enableCellEdit: false, cellFilter: 'number', minWidth: 70, cellTemplate: '<div class="ui-grid-cell-contents" style="text-align: right">{{row.entity.precio_compra * row.entity.cantidad | currency}}</div>' }
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				
				$scope.$apply()
				
				if newValue != oldValue
					if colDef.field == 'nombre'
						$http.put('::productos/actualizar-nombre', {producto_id: rowEntity.producto.id, nombre: rowEntity.nombre}).then((r)->
							toastr.success 'Nombre de Producto actualizado', 'Actualizado'
						, (r2)->
							toastr.error 'Cambio no guardado', 'Error'
						)


				return
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

	$scope.guardarToggleActivo = (rowEntity)->
		$http.put('::productos/actualizar/' + rowEntity.id, rowEntity).then((r)->
			toastr.success 'Producto actualizado con éxito', 'Actualizado'
		, (r2)->
			toastr.error 'Cambio no guardado', 'Error'
			console.log 'Falló al intentar guardar: ', r2
		)

	

])

.controller('RemoveCompraCtrl', ['$scope', '$uibModalInstance', 'Producto', '$http', 'toastr', ($scope, $modalInstance, Producto, $http, toastr)->
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


.filter('mapProveedores', ['$filter', ($filter)->

	return (input, proveedores)->
		if not input
			return 'Elija...'
		else
			prov = $filter('filter')(proveedores, {id: input}, true)[0]
			if prov
				return  prov.nombre
			else
				return 'En papelera...'
])




