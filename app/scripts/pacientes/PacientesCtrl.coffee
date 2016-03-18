angular.module('feryzApp')

.controller('PacientesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
		
	$scope.creando = false
	$scope.pacienteNuevo = { sexo: 'M' }

	$scope.editando = false
	$scope.pacienteEdit = {}
	$scope.dateOptions =  {formatYear: 'yy'}
	$scope.tipos_doc = [
		{id: 1, tipo: 'Cédula'}
		{id: 2, tipo: 'Cédula extranjera'}
		{id: 3, tipo: 'Tarjeta de identidad'}
	]


	$http.get('::paises/all').then((r)->
		$scope.paises = r.data
		$scope.pacienteNuevo.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.paisSeleccionado($scope.pacienteNuevo.pais)
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

	$scope.crearPaciente = ()->
		$scope.creando = true

	$scope.guardarPaciente = ()->

		$http.post('::pacientes/guardar', $scope.pacienteNuevo ).then( (r)->
			console.log '$scope.pacientes',$scope.pacientes
			$scope.opcionesGrid.data.push r.data
			toastr.success 'Creado correctamente: ' + r.data.nombre
			$scope.creando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar paciente', r2
		)
		

	$scope.eliminarPaciente = (pac)->
		
		$http.delete('::pacientes/eliminar/' + pac.id).then( (r)->
			$scope.pacientes = $filter('filter')($scope.pacientes, {id: '!'+pac.id})
		, (r2)->
			console.log 'No se pudo eliminar pacientes', r2
		)

	$scope.actualizarPaciente = (pac)->
		$http.put(App.Server + '::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Paciente', r2
		)

	$scope.editarPaciente = (pac)->
		$scope.editando = true
		$scope.pacienteEdit = pac
		

	
	$scope.traerPacientes = ()->

		$http.get('::pacientes/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los usuarios', r2
		)
	$scope.traerPacientes()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarUsuario(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i></a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarUsuario(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

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