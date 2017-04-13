angular.module('feryzApp')

.controller('InventariosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'USER_ROLES', 'AuthService', ($scope, $http, App, $filter, toastr, USER_ROLES, AuthService) ->
		

	AuthService.verificar_acceso()
	$scope.hasRole 		= AuthService.hasRole
	$scope.USER_ROLES 	= USER_ROLES
	$scope.USER 		= $scope.USER # para evitar la búscada en scope padre
	USER 				= $scope.USER # para usarlo aquí sin el scope

	$scope.creando 		= false
	$scope.editando 	= false

	
	$scope.traerDatos = ()->

		$http.put('::inventarios/datos').then((r)->
			r = r.data
			$scope.inventarios 					= r.inventarios
			$scope.detalles_inventario_actual 	= r.detalles_inventario_actual
			$scope.inventario_actual 			= r.inventario_actual

			$scope.opcionesGrid.data = r.detalles_inventario_actual
		, (r2)->
			toastr.error 'Error trayendo los datos.'
			console.log 'No se pudo traer los datos', r2
		)

	$scope.traerDatos()



	$scope.seleccionarInventario = (inventario)->
		for invn in $scope.inventarios
			invn.seleccionado = false
		inventario.seleccionado = true

	$scope.guardar = (usu)->
		$http.put('::configuracion/actualizar', $scope.configuracion).then( (r)->
			toastr.success $scope.configuracion.nombre_ips+ ' "Actualizada correctamente"'
		, (r2)->
			toastr.error 'No se pudo Actualizar', 'Error'
			console.log 'No se pudo actualizar configuracion', r2
		)

	

	btn1 	= '<span class="btn-group"><a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Edit</a>'
	btn2 	= '<a class="btn btn-danger btn-xs" ng-click="grid.appScope.quitarProducto(row.entity)"><md-tooltip md-direction="left">Quitar</md-tooltip><i class="fa fa-times "></i></a><span>'
	
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
			{field: 'nombre', displayName: 'Producto', minWidth: 270, enableCellEdit: false }
			{field: 'iva', type: 'text', cellTemplate: '<div class="ui-grid-cell-contents">{{row.entity.iva | number:0}}%</div>', enableCellEdit: false, width: 50 }
			{field: 'precio_costo', displayName: '$Costo', cellFilter: 'currency:undefined:grid.appScope.USER.deci_entrada', cellClass: 'grid-align-right', minWidth: 80}
			{field: 'precio_venta', displayName: '$Venta', cellFilter: 'currency:undefined:grid.appScope.USER.deci_salida', cellClass: 'grid-align-right', minWidth: 70}
			{displayName: 'Diferencia', name: 'Diferencia', enableSorting: true, enableCellEdit: false, cellFilter: 'number', minWidth: 100, cellTemplate: '<div class="ui-grid-cell-contents" style="text-align: right">{{ (row.entity.precio_venta - row.entity.precio_costo) | currency:undefined:grid.appScope.USER.deci_total}}</div>' }
			{field: 'cantidad', displayName: 'Cant', enableSorting: true, cellFilter: 'number', minWidth: 50, maxWidth: 70}
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


	



])