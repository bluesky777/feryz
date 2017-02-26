angular.module('feryzApp')

.controller('ComprasCtrl', ['$scope', '$http', 'App', 'USER_ROLES', '$filter', 'toastr', 'AuthService', '$uibModal', '$timeout', ($scope, $http, App, USER_ROLES, $filter, toastr, AuthService, $uibModal, $timeout) ->
	
	AuthService.verificar_acceso()
	$scope.hasRole 		= AuthService.hasRole
	$scope.USER_ROLES 	= USER_ROLES

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.prodActualizar = {}
	$scope.conIva 		= true

	$scope.mostrarPrecioVentaConIva = true
	$scope.compraNueva 		= { fecha: new Date() }
	$scope.detalle 			= { precio_venta: 0, precio_compra: 0, cantidad: 1, iva: 0, codigo_barras: undefined }
	$scope.detalleT 		= { precio_venta: 0, precio_compra: 0, cantidad: 1, iva: 0, codigo_barras: undefined }

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


	$scope.totalDetalle = (primero)->
		if primero
			primero = false
			return 0
		else
			res = $scope.detalle.cantidad * $scope.detalle.precio_compra
			cres = $filter('currency')( res )
			return cres
	$scope.totalDetalle(true)


	$scope.totalCompra = (filas)->
		sum_sin = 0
		sum_con = 0

		for fila in filas
			precio 	= fila.entity.precio_compra
			sum_sin = sum_sin + (fila.entity.cantidad * precio)
			sum_con = sum_con + (fila.entity.cantidad * (precio + precio * (fila.entity.iva/100)))

		total_sin_iva = $filter('currency')(sum_sin)
		total_con_iva = $filter('currency')(sum_con)

		diagn = 'Tot Iva: ' + total_con_iva + ' - Sin Iva: ' + total_sin_iva

		return diagn


	$scope.totalCompraValue = (filas)->
		sum = 0
		for fila in filas
			precio 	= fila.precio_compra
			if $scope.conIva
				precio = fila.precio_compra + fila.precio_compra * (fila.iva/100)

			sum = sum + (fila.cantidad * precio)

		total = $filter('currency')(sum)

		return total




	$scope.proveedorSeleccionado = ($item, $model)->
		if $item
			$scope.detalle.proveedor_id = $item.id
			$scope.$broadcast('focusOnCodigoBarras');


	$scope.codigoBarrasSeleccionado = ($item, $model)->
		if $item
			
			$timeout(()->
				$scope.focusOnPrecioCompra = true
			, 100)

			produc = $filter('filter')($scope.productos, {id: $item.id}, true )

			if produc.length > 0
				$scope.detalle.producto 	= produc[0]
				$scope.detalle.nombre 		= $scope.detalle.producto.nombre
				$scope.detalle.producto_id 	= $item.id

			if $item.iva 
				$scope.detalle.iva = $item.iva
			else if $item.iva == 0
				$scope.detalle.iva = $item.iva

		else
			$scope.detalle.producto = undefined

	$scope.productoSeleccionado = ($item, $model)->
		if $item

			$scope.detalle.nombre 		= $scope.detalle.producto.nombre
			$scope.detalle.producto_id 	= $item.id

			$timeout(()->
				$scope.focusOnPrecioCompra = true
			, 100)

			codigo = $filter('filter')($scope.codigos_barras, {id: $item.id}, true )
			if codigo.length > 0
				$scope.detalle.codigo_barras = codigo[0]
			else
				$scope.detalle.codigo_barras = undefined

			if $item.iva 
				$scope.detalle.iva = $item.iva
			else if $item.iva == 0
				$scope.detalle.iva = $item.iva

		else
			$scope.detalle.codigo_barras = undefined






	# Asignar iva al precio venta
	$scope.clickPrecioVentaConIva = (conIva)->
		console.log $scope.mostrarPrecioVentaConIva
		$scope.mostrarPrecioVentaConIva = false
		$scope.detalle.precio_venta = conIva

		$timeout(()->
			$scope.focusOnPrecioVenta = true
		)

		$timeout(()->
			$scope.mostrarPrecioVentaConIva = true
		, 1000)


	# Agregar producto a la grilla (a la compra)
	$scope.agregarProducto = ()->
		if $scope.detalle.producto
			$scope.agregando_producto = true
			otro = {}
			angular.copy $scope.detalle, otro 
			$scope.productos_agregados.push otro

			$scope.opcionesGrid.data = $scope.productos_agregados
			console.log $scope.opcionesGrid.data

			# Para que no se borre el proveedor en el siguiente producto
			$scope.detalleT.proveedor_id 	= $scope.detalle.proveedor_id
			$scope.detalleT.proveedor 		= $scope.detalle.proveedor

			$scope.detalleT.producto_id 	= $scope.detalle.producto.id

			angular.copy $scope.detalleT, $scope.detalle
			$scope.agregando_producto = false
		else
			toastr.warning 'Debe elegir un producto'
			$scope.agregando_producto = false
		

	# Quitar producto de la compra
	$scope.quitarProducto = (prod)->
		
		console.log prod




	btn1 = '<span class="btn-group"><a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Edit</a>'
	btn2 = '<a class="btn btn-danger btn-xs" ng-click="grid.appScope.quitarProducto(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a><span>'
	ivaEdit = '<div><form name="inputForm"><input ui-percentage-mask="0" ui-percentage-value type="INPUT_TYPE" ng-class="\'colt\' + col.uid" ui-grid-editor ng-model="MODEL_COL_FIELD" /></form</div>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: false,
		enableColumnMenus: false,
		enableFiltering: true,
		enableCellEdit: true,
		enableCellEditOnFocus: true,
		gridFooterTemplate: '<div class="ui-grid-footer-info ui-grid-grid-footer row"><span class="col-lg-4 col-sm-4">Productos: {{grid.rows.length}}<span ng-if="grid.renderContainers.body.visibleRowCache.length !== grid.rows.length" class="ngLabel"> (mostrando {{grid.renderContainers.body.visibleRowCache.length}})</span></span>   <span class="col-lg-8 col-sm-8 formato-total">{{grid.appScope.totalCompra(grid.rows)}}</span></div>'
		columnDefs: [
			{field: 'No', width: 60, enableCellEdit: false, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex + 1}}</div>'}
			{field: 'Edit', cellTemplate: btn2, width: 40, enableCellEdit: false, enableFiltering: false }
			{field: 'nombre', displayName: 'Producto', minWidth: 270 }
			{field: 'proveedor_id',	displayName: 'Proveedor',		cellFilter: 'mapProveedores:grid.appScope.proveedores',
			filter: {
				condition: (searchTerm, cellValue)->
					foundProveed 	= $filter('filter')($scope.proveedores, {nombre: searchTerm})
					actual 			= $filter('filter')(foundProveed, {id: cellValue}, true)
					return actual.length > 0;
			}
			editableCellTemplate: 'ui-grid/dropdownEditor', editDropdownIdLabel: 'id', editDropdownValueLabel: 'nombre', enableCellEditOnFocus: true, minWidth: 80 }
			
			{field: 'iva', type: 'text', cellTemplate: '<div class="ui-grid-cell-contents">{{row.entity.iva}}%</div>', editableCellTemplate: ivaEdit, minWidth: 70 }
			{field: 'precio_compra', displayName: '$Compra', cellFilter: 'currency', cellClass: 'grid-align-right', minWidth: 80}
			{field: 'precio_venta', displayName: '$Venta', cellFilter: 'currency', cellClass: 'grid-align-right', minWidth: 70}
			{field: 'cantidad', displayName: 'Cant', enableSorting: true, cellFilter: 'number', minWidth: 70}
			{displayName: 'Total', name: 'Total', enableSorting: true, enableCellEdit: false, cellFilter: 'number', minWidth: 70, cellTemplate: '<div class="ui-grid-cell-contents" style="text-align: right">{{row.entity.precio_compra * row.entity.cantidad | currency}}</div>' }
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


	# PARA PRUEBAS, QUITAR!
	$scope.productos_agregados = [
		{cantidad:16, iva:34, nombre: "GALON VINILO BLANCO TIPO 1", precio_compra: 14000, precio_venta: 30000, 			proveedor_id:2, producto_id:1}
		{cantidad:30, iva:19, nombre: "UNION PRESION PVC 1/2", precio_compra: 53000, precio_venta: 76000, 				proveedor_id:2, producto_id:2}
		{cantidad:27, iva:19, nombre: "UNION PRESION PVC 1", precio_compra: 80000, precio_venta: 160000, 				proveedor_id:2, producto_id:4}
		{cantidad:60, iva:19, nombre: "ADAPTADOR HEMBRA PRESION PVC 1/2", precio_compra: 80000, precio_venta: 160000, 	proveedor_id:2, producto_id:18}
	]
	$scope.opcionesGrid.data = $scope.productos_agregados
	#


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




