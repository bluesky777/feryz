angular.module('feryzApp')

.controller('UsuariosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
		
	$scope.creando = false
	$scope.usuarioNuevo = { sexo: 'M' }
	$scope.editando = false
	$scope.usuarioEdit = {}

	$scope.crearUsuario = ()->
		$scope.creando = true

	$scope.guardarUsuario = ()->

		$http.post('::usuarios/guardar', $scope.usuarioNuevo ).then( (r)->
			console.log '$scope.usuarios',$scope.usuarios
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)
		

	$scope.eliminarUsuario = (usu)->
		
		$http.delete('::usuarios/eliminar/' + usu.id).then( (r)->
			$scope.usuarios = $filter('filter')($scope.usuarios, {id: '!'+usu.id})
		, (r2)->
			console.log 'No se pudo eliminar producto', r2
		)

	$scope.actualizarUsuario = (usu)->
		$http.put(App.Server + '::usuarios/actualizar', $scope.usuarioEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)

	$scope.editarUsuario = (usu)->
		$scope.editando = true
		$scope.usuarioEdit = usu
		

	
	$scope.traerUsuarios = ()->

		$http.get('::usuarios/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los usuarios', r2
		)
	$scope.traerUsuarios()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarUsuario(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i></a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarUsuario(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edit', cellTemplate: btn1 + btn2, width: 70, enableCellEdit: false }
			{field: 'nombres', minWidth: 100}
			{field: 'apellidos', minWidth: 100}
			{field: 'sexo', width: 50}
			{field: 'username', displayName: 'Usuario'}
			{field: 'email'}
			{field: 'fecha_nac', type: 'date', format: 'yyyy-mm-dd'}
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				#console.log 'Fila editada, ', rowEntity, ' Column:', colDef, ' newValue:' + newValue + ' oldValue:' + oldValue ;
				
				if newValue != oldValue

					if colDef.field == "sexo"
						if newValue == 'M' or newValue == 'F'
							# Es correcto...
							$http.put('::usuarios/actualizar/' + rowEntity.id, rowEntity).then((r)->
								toastr.success 'Usuario actualizado con éxito', 'Actualizado'
							, (r2)->
								toastr.error 'Cambio no guardado', 'Error'
								console.log 'Falló al intentar guardar: ', r2
							)
						else
							$scope.toastr.warning 'Debe usar M o F'
							rowEntity.sexo = oldValue
					else

						$http.put('::usuarios/actualizar/' + rowEntity.id, rowEntity).then((r)->
							toastr.success 'Usuario actualizado con éxito', 'Actualizado'
						, (r2)->
							toastr.error 'Cambio no guardado', 'Error'
							console.log 'Falló al intentar guardar: ', r2
						)

				$scope.$apply()
			)

	}

])