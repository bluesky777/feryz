angular.module('feryzApp')

.controller('ProductosCtrl', ['$scope', '$http', 'App', 'USER_ROLES', '$filter', 'toastr', 'AuthService', '$uibModal', '$timeout', '$q', 'removeAccents', ($scope, $http, App, USER_ROLES, $filter, toastr, AuthService, $uibModal, $timeout, $q, removeAccents) ->

	AuthService.verificar_acceso()
	$scope.hasRole 		= AuthService.hasRole
	$scope.USER_ROLES 	= USER_ROLES
	$scope.USER 		= $scope.USER # para evitar la búscada en scope padre
	USER 				= $scope.USER # para usarlo aquí sin el scope


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


	$scope.prodNuevo = { unidad_medida: {unidad: '-'}, iva: 0, activo: 1, cantidad_minima: 5 }


	$scope.bc = {
		format: 'CODE128',
		lineColor: '#000000',
		width: 2,
		height: 70,
		displayValue: true,
		fontOptions: '',
		font: 'monospace',
		textAlign: 'center',
		textPosition: 'bottom',
		textMargin: 2,
		fontSize: 20,
		background: '#ffffff',
		margin: 0,
		marginTop: undefined,
		marginBottom: undefined,
		marginLeft: undefined,
		marginRight: undefined,
		valid: (valid)->
			#console.log valid
	}

	ivasComunes = ['3.00', '9.5', '19']


	$scope.crearProducto = ()->
		$scope.creando = true
		$scope.editando = false
		$timeout(()->
			$scope.focusOnNuevo = true
		)

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


	$scope.eliminarProducto = (prod)->

		modalInstance = $uibModal.open({
			templateUrl: '==productos/removeProducto.tpl.html'
			controller: 'RemoveProductoCtrl'
			resolve:
				Producto: ()->
					prod
		})
		modalInstance.result.then( (producto)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+producto.id})
		)

	$scope.actualizarProducto = (prod)->
		$scope.guardando = true
		$http.put('::productos/actualizar', $scope.prodActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.prodActualizar.nombre
			$scope.editando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarProducto = (prod)->

		$scope.creando = false
		$scope.editando = true
		angular.copy prod, $scope.prodActualizar
		$scope.prodActualizar.anterior = prod

		categ = $filter('filter')($scope.categorias, {id: $scope.prodActualizar.categoria_id}, true)[0]
		$scope.prodActualizar.categoria = categ

		unid = $filter('filter')($scope.unidades, {unidad: $scope.prodActualizar.unidad_medida}, true)[0]
		$scope.prodActualizar.unidad_medida = unid

		$timeout(()->
			$scope.focusOnEdit = true
		, 100)


	$scope.resultProductos = (searchTerm)->
		d = $q.defer();

		removeAccents.search = searchTerm

		res = $filter('filter')($scope.opcionesGrid.data, removeAccents.ignoreAccents )

		d.resolve res
		promesa = d.promise

		return promesa


	$scope.traerDatos = ()->

		$http.put('::productos/datos').then((r)->
			r = r.data
			$scope.opcionesGrid.data 	= r.productos
			$scope.categorias 			= r.categorias
			$scope.codigos_barras 		= r.codigos_barras

			$scope.opcionesGrid.columnDefs[3].editDropdownOptionsArray = $scope.categorias;
		, (r2)->
			console.log 'No se pudo traer los datos', r2
		)
	$scope.traerDatos()

	console.log USER.deci_salida

	btn1 = '<span class="btn-group"><a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProducto(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Edit</a>'
	btn2 = '<a class="btn btn-danger btn-xs" ng-click="grid.appScope.eliminarProducto(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a><span>'
	ivaEdit = '<div><form name="inputForm"><input ui-percentage-mask="0" ui-percentage-value type="INPUT_TYPE" ng-class="\'colt\' + col.uid" ui-grid-editor ng-model="MODEL_COL_FIELD" /></form</div>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		enableFiltering: true,
		exporterSuppressColumns: [ 'Edición' ],
		exporterCsvColumnSeparator: ';',
		exporterMenuPdf: false,
		exporterMenuExcel: false,
		exporterCsvFilename: "Productos - Feryz.csv",
		enableGridMenu: true,
		enableCellEdit: $scope.isAdmin,
		enableCellEditOnFocus: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', visible: $scope.isAdmin, cellTemplate: btn1 + btn2, width: 90, enableCellEdit: false, enableFiltering: false }
			{field: 'nombre', minWidth: 270}
			{field: 'categoria_id',	displayName: 'Categoría', minWidth: 105,		cellFilter: 'mapCategorias:grid.appScope.categorias',
			filter: {
				condition: (searchTerm, cellValue)->
					foundCategorias = $filter('filter')($scope.categorias, {nombre: searchTerm})
					actual 			= $filter('filter')(foundCategorias, {id: cellValue}, true)
					return actual.length > 0;
			}
			editableCellTemplate: 'ui-grid/dropdownEditor', editDropdownIdLabel: 'id', editDropdownValueLabel: 'nombre', enableCellEditOnFocus: true }

			{field: 'cantidad_minima', displayName: 'Min', cellFilter: 'number'}
			{field: 'iva', minWidth: 50, cellTemplate: '<div class="ui-grid-cell-contents">{{row.entity.iva | number:0}}%</div>', editableCellTemplate: ivaEdit }
			{field: 'activo', type: 'boolean', width: 60, cellTemplate: '<input type="checkbox" ng-model="row.entity.activo" ng-true-value="1" ng-false-value="0" ng-change="grid.appScope.guardarToggleActivo(row.entity)" ng-disabled="!grid.appScope.isAdmin" style="width: 50px;height: 18px;">'}
			{field: 'precio_venta',	displayName: 'Prec venta', cellFilter: 'currency:undefined:grid.appScope.USER.deci_salida', minWidth: 90}
		],
		exporterFieldCallback: ( grid, row, col, input )->
			if col.name == 'categoria_id'
				categ = $filter('filter')($scope.categorias, {id: input}, true)[0]
				if categ
					return  categ.nombre
				else
					return ''
				#return row.entity.ciudad_nac_nombre
			if( col.name == 'activo' )
				if input
					return 'Si'
				else
					return 'No'

			return input;
		,
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->

				if newValue != oldValue

					$http.put('::productos/actualizar', rowEntity).then((r)->
						toastr.success 'Producto actualizado con éxito', 'Actualizado'
					, (r2)->
						toastr.error 'Cambio no guardado', 'Error'
						console.log 'Falló al intentar guardar: ', r2
					)

				$scope.$apply()
			)
	}

	$scope.guardarToggleActivo = (rowEntity)->
		if $scope.isAdmin
			$http.put('::productos/actualizar', rowEntity).then((r)->
				toastr.success 'Producto actualizado con éxito', 'Actualizado'
			, (r2)->
				toastr.error 'Cambio no guardado', 'Error'
				console.log 'Falló al intentar guardar: ', r2
			)
		else
			toastr.warning 'No tienes permiso para modificar productos', 'Lo sentimos'


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


.filter('mapCategorias', ['$filter', ($filter)->

	return (input, categorias)->
		if not input
			return 'Elija...'
		else
			categ = $filter('filter')(categorias, {id: input}, true)[0]
			if categ
				return  categ.nombre
			else
				return 'En papelera...'
])

.filter('porcentaje', ['$filter', ($filter)->
	return (input, decimals)->
		return $filter('number')(input * 100, decimals) + '%';
])



