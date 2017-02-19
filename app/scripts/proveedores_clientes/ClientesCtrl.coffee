angular.module('feryzApp')

.controller('ClientesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', ($scope, $http, App, $filter, toastr, AuthService, $uibModal) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.clieActualizar = {}
	

	$scope.clieNuevo = { sexo: 'M', password: '', password_confirm: '', tipo_doc: {id: 1, tipo: 'Cédula'} }






	####################################################################################
	############################ traer paises ##########################################

	$http.get('::paises/all').then((r)->
		$scope.paises = r.data
		$scope.clieNuevo.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.paisSeleccionado($scope.clieNuevo.pais)
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


	$scope.crearCliente = ()->
		$scope.creando = true
		$scope.editando = false

	$scope.guardarCliente = ()->
		$scope.guardando = true
		$http.post('::clientes/guardar', $scope.clieNuevo ).then( (r)->
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo crear Cliente', 'Error'
		)
		

	$scope.eliminarCliente = (prov)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==proveedores_clientes/removeCliente.tpl.html'
			controller: 'RemoveClienteCtrl'
			resolve: 
				cliente: ()->
					prov
		})
		modalInstance.result.then( (cliente)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+cliente.id})
		)

	$scope.actualizarCliente = (prov)->
		$scope.guardando = true
		$http.put('::clientes/actualizar', $scope.clieActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.clieActualizar.nombre
			$scope.editando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarCliente = (prov)->

		$scope.creando = false
		$scope.editando = true
		angular.copy prov, $scope.clieActualizar
		$scope.clieActualizar.anterior = prov

		# Configuramos la ciudad nac 

		if $scope.clieActualizar.ciudad_id == null
			$scope.clieActualizar.pais = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.clieActualizar.pais, $scope.clieActualizar.pais)
		else
			$http.get('::ciudades/datosciudad/'+$scope.clieActualizar.ciudad_id).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentos 			= r2.data.departamentos
				$scope.ciudades 				= r2.data.ciudades
				$scope.clieActualizar.pais 		= r2.data.pais
				$scope.clieActualizar.departamento = r2.data.departamento
				$scope.clieActualizar.ciudad 	= r2.data.ciudad

	
	$scope.traerClientes = ()->

		$http.get('::clientes/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los clientes', r2
		)
	$scope.traerClientes()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarCliente(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Modificar</a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarCliente(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

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

					$http.put('::clientes/actualizar/' + rowEntity.id, rowEntity).then((r)->
						toastr.success 'Cliente actualizado con éxito', 'Actualizado'
					, (r2)->
						toastr.error 'Cambio no guardado', 'Error'
						console.log 'Falló al intentar guardar: ', r2
					)

				$scope.$apply()
			)

	}

])

.controller('RemoveClienteCtrl', ['$scope', '$uibModalInstance', 'cliente', '$http', 'toastr', ($scope, $modalInstance, cliente, $http, toastr)->
	$scope.cliente = cliente

	$scope.ok = ()->

		$http.delete('::clientes/destroy/'+cliente.id).then((r)->
			toastr.success 'Cliente eliminado: '+cliente.nombre, 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar el cliente.'
		)
		$modalInstance.close(cliente)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

