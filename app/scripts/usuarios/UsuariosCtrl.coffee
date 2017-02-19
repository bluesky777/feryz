angular.module('feryzApp')

.controller('UsuariosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService', '$uibModal', ($scope, $http, App, $filter, toastr, AuthService, $uibModal) ->
	
	AuthService.verificar_acceso()

	$scope.creando 		= false
	$scope.editando 	= false
	$scope.guardando 	= false
	$scope.usuarioActualizar = {}
	$scope.tipos_doc = [
		{id: 1, tipo: 'Cédula'}
		{id: 2, tipo: 'Cédula extranjera'}
		{id: 3, tipo: 'Tarjeta de identidad'}
	]
	$scope.tipos_usuarios = [
		{id: 1, tipo: 'Administrador'}
		{id: 2, tipo: 'Vendedor'}
		{id: 3, tipo: 'Técnico'}
	]

	$scope.usuarioNuevo = { sexo: 'M', password: '', password_confirm: '', tipo_doc: {id: 1, tipo: 'Cédula'} }






	####################################################################################
	############################ traer paises ##########################################

	$http.get('::paises/all').then((r)->
		$scope.paises = r.data
		$scope.usuarioNuevo.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.usuarioNuevo.pais_doc = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.paisSeleccionado($scope.usuarioNuevo.pais)
		$scope.paisdocSeleccionado($scope.usuarioNuevo.pais_doc)
	, ()->
		toastr.error 'No se pudo traer las ciudades.'
	)

	$scope.paisSeleccionado = (pais, modelo)->
		$http.get('::ciudades/departamentos', {params: {pais_id: pais.id} }).then((r)->
			$scope.departamentos = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)

	$scope.paisdocSeleccionado = (paisdoc, modelo)->
		$http.get('::ciudades/departamentos', {params: {pais_id: paisdoc.id} }).then((r)->
			$scope.departamentos_doc = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)

	$scope.departamentoSeleccionado = (depart, modelo)->
		$http.get('::ciudades/ciudades', {params: {departamento: depart.departamento} }).then((r)->
			$scope.ciudades = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)

	$scope.departamentoDocSeleccionado = (depart, modelo)->
		$http.get('::ciudades/ciudades', {params: {departamento: depart.departamento} }).then((r)->
			$scope.ciudades_doc = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)





	########################### !traer paises##############################################
	#######################################################################################


	$scope.crearUsuario = ()->
		$scope.creando = true
		$scope.editando = false

	$scope.guardarUsuario = ()->
		$scope.guardando 	= true

		if $scope.usuarioNuevo.password != $scope.usuarioNuevo.password_confirm
			toastr.warning 'La contraseña y confirmación no coinciden'
			$scope.guardando = false
			return false

		if $scope.usuarioNuevo.password.length < 3
			toastr.warning 'La contraseña debe tener al menos 3 caracteres'
			$scope.guardando = false
			return false

		$http.post('::usuarios/guardar', $scope.usuarioNuevo ).then( (r)->
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombres
			$scope.creando = false
			$scope.guardando = false
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo crear usuario', 'Error'
		)
		

	$scope.eliminarUsuario = (usu)->
		
		modalInstance = $uibModal.open({
			templateUrl: '==usuarios/removeUsuario.tpl.html'
			controller: 'RemoveUsuarioCtrl'
			resolve: 
				usuario: ()->
					usu
		})
		modalInstance.result.then( (usuario)->
			$scope.opcionesGrid.data = $filter('filter')($scope.opcionesGrid.data, {id: '!'+usuario.id})
		)

		

	$scope.actualizarUsuario = (usu)->
		$scope.guardando = true

		if $scope.usuarioActualizar.password != '' and $scope.usuarioActualizar.password_confirm != ''
			if $scope.usuarioActualizar.password != $scope.usuarioActualizar.password_confirm
				toastr.warning 'La contraseña y confirmación no coinciden'
				$scope.guardando = false
				return false

			if $scope.usuarioActualizar.password.length < 3
				toastr.warning 'La contraseña debe tener al menos 3 caracteres'
				$scope.guardando = false
				return false

		$http.put('::usuarios/actualizar', $scope.usuarioActualizar).then( (r)->
			toastr.success 'Actualizado correctamente: ' + $scope.usuarioActualizar.nombres
			$scope.editando = false
			$scope.guardando = false

			$scope.usuarioActualizar.anterior.tipo = $scope.usuarioActualizar.tipo.id
			$scope.usuarioActualizar.anterior.tipo_doc = $scope.usuarioActualizar.tipo_doc.id
		, (r2)->
			$scope.guardando = false
			toastr.error 'No se pudo actualizar', 'Error'
		)

	$scope.editarUsuario = (usu)->

		$scope.creando = false
		$scope.editando = true
		angular.copy usu, $scope.usuarioActualizar
		$scope.usuarioActualizar.anterior = usu

		$scope.usuarioActualizar.password = ''
		$scope.usuarioActualizar.password_confirm = ''


		# Configuramos el tipo para el SELECT2
		tipo_doc = $filter('filter')($scope.tipos_doc, {tipo: $scope.usuarioActualizar.tipo_doc}, true)

		if tipo_doc.length > 0
			tipo_doc = tipo_doc[0]
		else
			tipo_doc = $scope.tipos_doc[0]
		
		$scope.usuarioActualizar.tipo_doc = tipo_doc
		

		# Configuramos el tipo usuario para el SELECT2
		tipo_usu = $filter('filter')($scope.tipos_usuarios, {tipo: $scope.usuarioActualizar.tipo}, true)

		if tipo_usu.length > 0
			tipo_usu = tipo_usu[0]
		else
			tipo_usu = $scope.tipos_usuarios[0]
		
		$scope.usuarioActualizar.tipo = tipo_usu
		

		# Configuramos la ciudad nac 

		if $scope.usuarioActualizar.ciudad_nac == null
			$scope.usuarioActualizar.pais = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.usuarioActualizar.pais, $scope.usuarioActualizar.pais)
		else
			$http.get('::ciudades/datosciudad/'+$scope.usuarioActualizar.ciudad_nac).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentosNac = r2.data.departamentos
				$scope.ciudadesNac = r2.data.ciudades
				$scope.usuarioActualizar.pais = r2.data.pais
				$scope.usuarioActualizar.depart_nac = r2.data.departamento
				$scope.usuarioActualizar.ciudad_nac = r2.data.ciudad

		# Configuramos la ciudad doc 

		if $scope.usuarioActualizar.ciudad_doc == null
			$scope.usuarioActualizar.pais_doc = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.usuarioActualizar.pais_doc, $scope.usuarioActualizar.pais_doc)
		else
			$http.get('::ciudades/datosciudad/'+$scope.usuarioActualizar.ciudad_doc).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentosNac = r2.data.departamentos
				$scope.ciudadesNac = r2.data.ciudades
				$scope.usuarioActualizar.pais_doc = r2.data.pais
				$scope.usuarioActualizar.depart_doc = r2.data.departamento
				$scope.usuarioActualizar.ciudad_doc = r2.data.ciudad
		

	
	$scope.traerUsuarios = ()->

		$http.get('::usuarios/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los usuarios', r2
		)
	$scope.traerUsuarios()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarUsuario(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i>Modificar</a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarUsuario(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 60, enableCellEdit: false}
			{field: 'Edición', cellTemplate: btn1 + btn2, width: 120, enableCellEdit: false }
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

.controller('RemoveUsuarioCtrl', ['$scope', '$uibModalInstance', 'usuario', '$http', 'toastr', ($scope, $modalInstance, usuario, $http, toastr)->
	$scope.usuario = usuario

	$scope.ok = ()->

		$http.delete('::usuarios/destroy/'+usuario.id).then((r)->
			toastr.success 'Usuario eliminado: '+usuario.nombres, 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar el usuario.'
		)
		$modalInstance.close(usuario)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

