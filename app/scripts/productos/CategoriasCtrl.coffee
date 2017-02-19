angular.module('feryzApp')

.controller('CategoriasCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', ($scope, $http, App, $filter, toastr, AuthService, $uibModal) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.cateActualizar = {}
	

	$scope.cateNuevo = { }


	$scope.crearCategoria = ()->
		$scope.creando = true
		$scope.editando = false

	$scope.guardarCategoria = ()->
		$scope.guardando = true
		$http.post('::categorias/guardar', $scope.cateNuevo ).then( (r)->
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo crear categoría', 'Error'
		)
		

	$scope.eliminarCategoria = (cate)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==productos/removeCategoria.tpl.html'
			controller: 'RemoveCategoriaCtrl'
			resolve: 
				categoria: ()->
					cate
		})
		modalInstance.result.then( (categoria)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+categoria.id})
		)

	$scope.actualizarCategoria = (prov)->
		$scope.guardando = true
		$http.put('::categorias/actualizar', $scope.cateActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.cateActualizar.nombre
			$scope.editando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarCategoria = (categ)->

		$scope.creando = false
		$scope.editando = true
		angular.copy categ, $scope.cateActualizar
		$scope.cateActualizar.anterior = categ

	
	$scope.traerCategorias = ()->

		$http.get('::categorias/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los categorías', r2
		)
	$scope.traerCategorias()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarCategoria(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Modificar</a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarCategoria(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 120, enableCellEdit: false }
			{field: 'nombre', minWidth: 100}
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				#console.log 'Fila editada, ', rowEntity, ' Column:', colDef, ' newValue:' + newValue + ' oldValue:' + oldValue ;
				
				if newValue != oldValue

					$http.put('::categorias/actualizar/' + rowEntity.id, rowEntity).then((r)->
						toastr.success 'categoria actualizado con éxito', 'Actualizado'
					, (r2)->
						toastr.error 'Cambio no guardado', 'Error'
						console.log 'Falló al intentar guardar: ', r2
					)

				$scope.$apply()
			)

	}

])

.controller('RemoveCategoriaCtrl', ['$scope', '$uibModalInstance', 'categoria', '$http', 'toastr', ($scope, $modalInstance, categoria, $http, toastr)->
	$scope.categoria = categoria

	$scope.ok = ()->

		$http.delete('::categorias/destroy/'+categoria.id).then((r)->
			toastr.success 'Categoría eliminado: '+categoria.nombre, 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar el categoria.'
		)
		$modalInstance.close(categoria)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

