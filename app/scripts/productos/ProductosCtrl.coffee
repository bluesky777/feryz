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
	

	$scope.prodNuevo = { unidad_medida: {unidad: '-'} }




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
		

	$scope.eliminarProducto = (prod)->
		
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

	
	$scope.traerProductos = ()->

		$http.get('::categorias/all').then((r)->
			$scope.categorias = r.data
			$scope.opcionesGrid.columnDefs[3].editDropdownOptionsArray = $scope.categorias;
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
		enableFiltering: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 120, enableCellEdit: false }
			{field: 'nombre', minWidth: 100}
			{field: 'categoria_id',	displayName: 'Categoría',		cellFilter: 'mapCategorias:grid.appScope.categorias',
			filter: {
				condition: (searchTerm, cellValue)->
					foundCategorias = $filter('filter')($scope.categorias, {nombre: searchTerm})
					actual 			= $filter('filter')(foundCategorias, {id: cellValue}, true)
					return actual.length > 0;
			}
			editableCellTemplate: 'ui-grid/dropdownEditor', editDropdownIdLabel: 'id', editDropdownValueLabel: 'nombre', enableCellEditOnFocus: true }
			
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


