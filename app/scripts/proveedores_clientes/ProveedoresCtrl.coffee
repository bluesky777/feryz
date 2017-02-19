angular.module('feryzApp')

.controller('ProveedoresCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', ($scope, $http, App, $filter, toastr, AuthService, $uibModal) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.provActualizar = {}
	

	$scope.provNuevo = { sexo: 'M', password: '', password_confirm: '', tipo_doc: {id: 1, tipo: 'Cédula'} }






	####################################################################################
	############################ traer paises ##########################################

	$http.get('::paises/all').then((r)->
		$scope.paises = r.data
		$scope.provNuevo.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.paisSeleccionado($scope.provNuevo.pais)
	, ()->
		toastr.error 'No se pudo traer las ciudades.'
	)

	$scope.paisSeleccionado = (pais, modelo)->
		$http.get('::ciudades/departamentos', {params: {pais_id: pais.id} }).then((r)->
			$scope.departamentos = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)


	$scope.departamentoSeleccionado = (depart, modelo)->
		$http.get('::ciudades/ciudades', {params: {departamento: depart.departamento} }).then((r)->
			$scope.ciudades = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)



	########################### !traer paises##############################################
	#######################################################################################


	$scope.crearProveedor = ()->
		$scope.creando = true
		$scope.editando = false

	$scope.guardarProveedor = ()->
		$scope.guardando = true
		$http.post('::proveedores/guardar', $scope.provNuevo ).then( (r)->
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo crear proveedor', 'Error'
		)
		

	$scope.eliminarProveedor = (prov)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==proveedores_clientes/removeProveedor.tpl.html'
			controller: 'RemoveProveedorCtrl'
			resolve: 
				proveedor: ()->
					prov
		})
		modalInstance.result.then( (proveedor)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+proveedor.id})
		)

	$scope.actualizarProveedor = (prov)->
		$scope.guardando = true
		$http.put('::proveedores/actualizar', $scope.provActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.provActualizar.nombre
			$scope.editando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarProveedor = (prov)->

		$scope.creando = false
		$scope.editando = true
		angular.copy prov, $scope.provActualizar
		$scope.provActualizar.anterior = prov

		# Configuramos la ciudad nac 

		if $scope.provActualizar.ciudad_id == null
			$scope.provActualizar.pais = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.provActualizar.pais, $scope.provActualizar.pais)
		else
			$http.get('::ciudades/datosciudad/'+$scope.provActualizar.ciudad_id).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentos 			= r2.data.departamentos
				$scope.ciudades 				= r2.data.ciudades
				$scope.provActualizar.pais 		= r2.data.pais
				$scope.provActualizar.departamento = r2.data.departamento
				$scope.provActualizar.ciudad 	= r2.data.ciudad

	
	$scope.traerProveedores = ()->

		$http.get('::proveedores/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los proveedores', r2
		)
	$scope.traerProveedores()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarProveedor(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Modificar</a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarProveedor(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 120, enableCellEdit: false }
			{field: 'nombre', minWidth: 100}
			{field: 'direccion', displayName: 'Dirección', minWidth: 100}
			{field: 'persona_contacto', displayName: 'Persona contacto', minWidth: 100}
			{field: 'email'}
			{field: 'telefono1'}
		]
		onRegisterApi: ( gridApi ) ->
			$scope.gridApi = gridApi
			gridApi.edit.on.afterCellEdit($scope, (rowEntity, colDef, newValue, oldValue)->
				#console.log 'Fila editada, ', rowEntity, ' Column:', colDef, ' newValue:' + newValue + ' oldValue:' + oldValue ;
				
				if newValue != oldValue

					$http.put('::proveedores/actualizar/' + rowEntity.id, rowEntity).then((r)->
						toastr.success 'Proveedor actualizado con éxito', 'Actualizado'
					, (r2)->
						toastr.error 'Cambio no guardado', 'Error'
						console.log 'Falló al intentar guardar: ', r2
					)

				$scope.$apply()
			)

	}

])

.controller('RemoveProveedorCtrl', ['$scope', '$uibModalInstance', 'proveedor', '$http', 'toastr', ($scope, $modalInstance, proveedor, $http, toastr)->
	$scope.proveedor = proveedor

	$scope.ok = ()->

		$http.delete('::proveedores/destroy/'+proveedor.id).then((r)->
			toastr.success 'Proveedor eliminado: '+proveedor.nombre, 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar el proveedor.'
		)
		$modalInstance.close(proveedor)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

