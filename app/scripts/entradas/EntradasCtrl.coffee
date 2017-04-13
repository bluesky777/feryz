angular.module('feryzApp')

.controller('EntradasCtrl', ['$scope', '$http', 'App', 'USER_ROLES', '$filter', 'toastr', 'AuthService', '$uibModal', '$timeout', 'Local', 'hotkeys', ($scope, $http, App, USER_ROLES, $filter, toastr, AuthService, $uibModal, $timeout, Local, hotkeys) ->
	
	AuthService.verificar_acceso()
	$scope.hasRole 		= AuthService.hasRole
	$scope.USER_ROLES 	= USER_ROLES
	$scope.USER 		= $scope.USER # para evitar la búscada en scope padre
	USER 				= $scope.USER # para usarlo aquí sin el scope

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.prodActualizar = {}
	$scope.conIva 		= true
	$scope.altura 		= 400

	$scope.focusOnConSinIva = false

	$scope.mostrarPrecioVentaConIva = true
	$scope.entradaNueva 	= { fecha: new Date(), proveedor: undefined, productos_agregados: [] }
	$scope.entradaNuevaT 	= { fecha: new Date(), proveedor: undefined, productos_agregados: [] } # Para cuando tenga que crear una nueva entrada vacía
	$scope.detalle 			= { precio_venta: 0, precio_costo: 0, cantidad: 1, iva: 0, codigo_barras: undefined }
	$scope.detalleT 		= { precio_venta: 0, precio_costo: 0, cantidad: 1, iva: 0, codigo_barras: undefined }
	$scope.EntSinGuardar 	= [] # Todas las entradas que NO están en la nube
	$scope.indiceEnt		= 0 # Indica la entrada sin guardar que está seleccionada

	# Para el date
	$scope.data = {} 
	$scope.dateOptions = 
		formatYear: 'yy'


	$scope.ocultarNav() # Oculto la Navbar


	$scope.productos 			= []
	$scope.proveedores 			= []
	$scope.categorias 			= []
	$scope.codigos_barras 		= []


	$scope.mostrandoEntrada = false

	
	$scope.traerDatos = ()->

		$http.put('::entradas/datos').then((r)->
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



	verificarEntidadesGuardadas = ()->

		Local.getEntradasSinGuardar().then((r)->
			
			if r.length > 0
				$scope.EntSinGuardar = r
				console.log $scope.EntSinGuardar

				for entrada in $scope.EntSinGuardar
					entrada.fecha = new Date(entrada.fecha + ' 00:00:00')

				$scope.setEntradaSinGuardar($scope.EntSinGuardar.length-1)
			else
				Local.insertEntrada().then((newEnt)->
					verificarEntidadesGuardadas()
				, (r2)->
					console.log r2
				)

		, (r2)->
			console.log r2, 'pailas'
		)

	verificarEntidadesGuardadas()


	$scope.nuevaEntrada = ()->
		Local.insertEntrada().then((newEnt)->
			newEnt.fecha = new Date(newEnt.fecha + ' 00:00:00')
			$scope.EntSinGuardar.push newEnt
			$scope.setEntradaSinGuardar($scope.EntSinGuardar.length-1)
		, (r2)->
			console.log r2
		)

	$scope.descartarEntrada = (event, hotKey, entrada)->
		if entrada == 'undefined' or entrada == undefined
			entrada = $scope.EntSinGuardar[ $scope.indiceEnt ]
		
		descartar = true
		
		if entrada.productos_agregados.length > 0 
			descartar = confirm('¿Seguro quiere descartar esta entrada?')

		if descartar
			Local.deleteEntrada(entrada.rowid).then((r)->
				entrada.descartada = true
				$scope.setEntradaSinGuardar()
			, (r2)->
				console.log r2
			)

	$scope.setEntradaSinGuardar = (indice)->
		if indice == 0 or indice > 0
			$scope.indiceEnt 	= indice
		else
			$scope.indiceEnt++
			if $scope.indiceEnt > ($scope.EntSinGuardar.length - 1)
				$scope.indiceEnt = 0
		
		$scope.entradaNueva = $scope.EntSinGuardar[$scope.indiceEnt]
		$scope.opcionesGrid.data = $scope.entradaNueva.productos_agregados
		console.log $scope.entradaNueva
		###
		# PARA PRUEBAS, QUITAR!
		$scope.entradaNueva.productos_agregados = [
			{cantidad:16, iva:34, nombre: "GALON VINILO BLANCO TIPO 1", precio_costo: 14000, precio_venta: 30000, 			proveedor_id:2, producto_id:1}
			{cantidad:30, iva:19, nombre: "UNION PRESION PVC 1/2", precio_costo: 53000, precio_venta: 76000, 				proveedor_id:2, producto_id:2}
			{cantidad:27, iva:19, nombre: "UNION PRESION PVC 1", precio_costo: 80000, precio_venta: 160000, 				proveedor_id:2, producto_id:4}
			{cantidad:60, iva:19, nombre: "ADAPTADOR HEMBRA PRESION PVC 1/2", precio_costo: 80000, precio_venta: 160000, 	proveedor_id:2, producto_id:18}
		]
		###



	# Accesos rápidos de teclado
	hotkeys.bindTo($scope)
	.add({
		combo: 'n',
		description: 'Nueva transacción de Entrada',
		callback: $scope.nuevaEntrada
	})
	.add({
		combo: 'f2',
		description: 'Ir a la siguiente Entrada',
		callback: $scope.setEntradaSinGuardar
	})
	.add({
		combo: 'esc',
		description: 'Salir de input',
		allowIn: ['INPUT', 'SELECT', 'TEXTAREA'],
		callback: (event, hotkey)->
			angular.element('#focusOnConSinIva').trigger('focus');

	})
	.add({
		combo: 'ctrl+d',
		description: 'Descartar entrada',
		allowIn: ['INPUT', 'SELECT', 'TEXTAREA'],
		callback: $scope.descartarEntrada
	});




	


	$scope.totalDetalle = (primero)->
		if primero
			primero = false
			return 0
		else
			res = $scope.detalle.cantidad * $scope.detalle.precio_costo
			cres = $filter('currency')( res, undefined, USER.deci_total )
			return cres
	$scope.totalDetalle(true)


	$scope.totalEntrada = (filas)->
		sum_sin = 0
		sum_con = 0

		for fila in filas
			precio 	= fila.entity.precio_entrada
			sum_sin = sum_sin + (fila.entity.cantidad * precio)
			sum_con = sum_con + (fila.entity.cantidad * (precio + precio * (fila.entity.iva/100)))

		total_sin_iva = $filter('currency')(sum_sin, undefined, USER.deci_total)
		total_con_iva = $filter('currency')(sum_con, undefined, USER.deci_total)

		diagn = 'Tot Iva: ' + total_con_iva + ' - Sin Iva: ' + total_sin_iva

		return diagn


	$scope.totalEntradaValue = (filas)->
		if filas
			sum = 0
			for fila in filas
				precio 	= fila.precio_costo
				if $scope.conIva
					precio = fila.precio_costo + fila.precio_costo * (fila.iva/100)

				sum = sum + (fila.cantidad * precio)

			total = $filter('currency')(sum, undefined, USER.deci_total)

			return total
		else
			return 0

	$scope.toggleConIva = ()->
		$scope.conIva = !$scope.conIva




	$scope.proveedorSeleccionado = ($item, $model)->
		if $item
			$scope.$broadcast('focusOnCodigoBarras');


	$scope.codigoBarrasSeleccionado = ($item, $model)->
		if $item
			
			$timeout(()->
				$scope.focusOnPrecioCosto = true
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
				$scope.focusOnPrecioCosto = true
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
		$scope.mostrarPrecioVentaConIva = false
		$scope.detalle.precio_venta = conIva

		$timeout(()->
			$scope.focusOnPrecioVenta = true
		)

		$timeout(()->
			$scope.mostrarPrecioVentaConIva = true
		, 1000)


	# Agregar producto a la grilla (a la entrada)
	$scope.agregarProducto = ()->
		if $scope.detalle.producto
			$scope.agregando_producto = true
			otro = {}
			angular.copy $scope.detalle, otro 
			$scope.entradaNueva.productos_agregados.push otro

			$scope.opcionesGrid.data = $scope.entradaNueva.productos_agregados

			$scope.detalleT.producto_id 	= $scope.detalle.producto.id

			angular.copy $scope.detalleT, $scope.detalle
			$scope.agregando_producto = false
			
			if $scope.entradaNueva.productos_agregados.length > 10
				$scope.altura = 600
		else
			toastr.warning 'Debe elegir un producto'
			$scope.agregando_producto = false
		

	# Quitar producto de la entrada
	$scope.quitarProducto = (prod)->

		$scope.entradaNueva.productos_agregados = $filter('filter')($scope.entradaNueva.productos_agregados, {producto_id: '!'+prod.producto_id})
		$scope.opcionesGrid.data = $scope.entradaNueva.productos_agregados
		
		if $scope.entradaNueva.productos_agregados.length < 11
			$scope.altura = 400
		


	# Guardar en el servidor
	$scope.guardarEntradas = ()->
		if $scope.entradasNueva.proveedor

			$http.post('::entradas/guardar', {productos: $scope.entradaNueva.productos_agregados, compra: $scope.compraNueva }).then((r)->
				toastr.success 'Guardada'
			, (r2)->
				toastr.error 'No se pudo guardar la entrada'
			)
		else
			toastr.warning 'Debes elegir el proveedor'




	btn1 	= '<span class="btn-group"><a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Edit</a>'
	btn2 	= '<a class="btn btn-danger btn-xs" ng-click="grid.appScope.quitarProducto(row.entity)"><md-tooltip md-direction="left">Quitar</md-tooltip><i class="fa fa-times "></i></a><span>'
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
			{field: 'Ed', displayName: '', cellTemplate: btn2, width: 35, enableCellEdit: false, enableFiltering: false }
			{field: 'nombre', displayName: 'Producto', minWidth: 270 }
			{field: 'iva', type: 'text', cellTemplate: '<div class="ui-grid-cell-contents">{{row.entity.iva | number:0}}%</div>', editableCellTemplate: ivaEdit, width: 50 }
			{field: 'precio_costo', displayName: '$Costo', cellFilter: 'currency:undefined:grid.appScope.USER.deci_entrada', cellClass: 'grid-align-right', minWidth: 80}
			{field: 'precio_venta', displayName: '$Venta', cellFilter: 'currency:undefined:grid.appScope.USER.deci_salida', cellClass: 'grid-align-right', minWidth: 70}
			{field: 'cantidad', displayName: 'Cant', enableSorting: true, cellFilter: 'number', minWidth: 50, maxWidth: 70}
			{displayName: 'Total', name: 'Total', enableSorting: true, enableCellEdit: false, cellFilter: 'number', minWidth: 100, cellTemplate: '<div class="ui-grid-cell-contents" style="text-align: right">{{row.entity.precio_costo * row.entity.cantidad | currency:undefined:grid.appScope.USER.deci_total}}</div>' }
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				
				if newValue != oldValue
					if colDef.field == 'nombre'
						$http.put('::productos/actualizar-nombre', {producto_id: rowEntity.producto.id, nombre: rowEntity.nombre}).then((r)->
							toastr.success 'Nombre de Producto actualizado', 'Actualizado'
						, (r2)->
							toastr.error 'Cambio no guardado', 'Error'
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

	





	# LÓGICA PARA LAS Entradas


	$scope.gridEntradas = {
		showGridFooter: true,
		enableSorting: false,
		enableColumnMenus: false,
		enableFiltering: true,
		enableCellEdit: true,
		enableCellEditOnFocus: true,
		gridFooterTemplate: '<div class="ui-grid-footer-info ui-grid-grid-footer row"><span class="col-lg-4 col-sm-4">Productos: {{grid.rows.length}}<span ng-if="grid.renderContainers.body.visibleRowCache.length !== grid.rows.length" class="ngLabel"> (mostrando {{grid.renderContainers.body.visibleRowCache.length}})</span></span>   <span class="col-lg-8 col-sm-8 formato-total">{{grid.appScope.totalEntrada(grid.rows)}}</span></div>'
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Ed', displayName: '', cellTemplate: btn2, width: 35, enableCellEdit: false, enableFiltering: false }
			{field: 'fecha'}
			{field: 'proveedor_id'}
			{field: 'created_by', displayName: 'Creado por'}
			{field: 'created_at', displayName: 'Creado en'}
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				
				if newValue != oldValue
					if colDef.field == 'nombre'
						$http.put('::productos/actualizar-nombre', {producto_id: rowEntity.producto.id, nombre: rowEntity.nombre}).then((r)->
							toastr.success 'Nombre de Producto actualizado', 'Actualizado'
						, (r2)->
							toastr.error 'Cambio no guardado', 'Error'
						)

				$scope.$apply()
			)
	}


	$scope.mostrarEntradas = ()->
		$http.put('::entradas/all').then((r)->
			$scope.gridEntradas.data = r.data.entradas
			$scope.mostrandoEntradas = true
		, (r2)->
			toastr.error 'No se pudo traer las Entradas'
		)
	
	$scope.ocultarEntradas = ()->
		$scope.mostrandoEntradas = false




])

.controller('RemoveEntradaCtrl', ['$scope', '$uibModalInstance', 'Producto', '$http', 'toastr', ($scope, $modalInstance, Producto, $http, toastr)->
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




