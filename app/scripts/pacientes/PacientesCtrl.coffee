angular.module('feryzApp')

.controller('PacientesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
	$scope.pacienteEdit = {}
	$scope.pacienteNuevo = 
		sexo: 'M'
		estereopsis: 'N' 
		test_color: 'N'
		sintomas_vision: []

	$scope.creando = false
	$scope.editando = false


	$scope.crearPaciente = ()->
		$scope.creando = true

	
	$scope.opt_sintomas_vision = [
		{nombre: 'Ver borroso'}
		{nombre: 'Tiene ojos grandes'}
		{nombre: 'Me asusta'}
		{nombre: 'Visión de medusa'}
	]
	for sint in $scope.opt_sintomas_vision
		sint._lowername = sint.nombre.toLowerCase();


	
	$scope.dateOptions =  {formatYear: 'yy'}
	$scope.tipos_doc = [
		{id: 1, tipo: 'Cédula'}
		{id: 2, tipo: 'Cédula extranjera'}
		{id: 3, tipo: 'Tarjeta de identidad'}
	]

	$scope.ctrl = {}

	$scope.transformChip = (chip)->
		if (angular.isObject(chip))
			return chip
		return { nombre: chip, type: 'new' }


	$scope.ctrl.querySearch = (query)->
		results = if query then $scope.opt_sintomas_vision.filter($scope.createFilterFor(query)) else []
		return results;

	$scope.createFilterFor = (query)->
		lowercaseQuery = angular.lowercase(query);
		return (sintoma_vision)->
			return (sintoma_vision._lowername.indexOf(lowercaseQuery) != -1)




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


	$scope.eliminarPaciente = (pac)->
		
		$http.delete('::pacientes/eliminar/' + pac.id).then( (r)->
			$scope.pacientes = $filter('filter')($scope.pacientes, {id: '!'+pac.id})
		, (r2)->
			console.log 'No se pudo eliminar pacientes', r2
		)


	########################################################################
	########################	 EDITAR PACIENTE 	  ######################
	########################################################################
	$scope.editarPaciente = (pac)->

		$scope.editando = true
		$scope.pacienteEdit = pac

		# Configuramos el tipo para el SELECT2
		tipo = $filter('filter')($scope.tipos_doc, {tipo: $scope.pacienteEdit.doc_tipo}, true)
				
		if tipo.length > 0
			tipo = tipo[0]
		else
			tipo = $scope.tipos_doc[0]
		
		$scope.pacienteEdit.doc_tipo = tipo

		
		# Configuramos la ciudad nac 

		if $scope.pacienteEdit.ciudad_nac_id == null
			$scope.pacienteEdit.pais = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.pacienteEdit.pais, $scope.pacienteEdit.pais)
		else
			$http.get('::ciudades/datosciudad/'+$scope.pacienteEdit.ciudad_nac_id).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentosNac = r2.data.departamentos
				$scope.ciudadesNac = r2.data.ciudades
				$scope.pacienteEdit.pais = r2.data.pais
				$scope.pacienteEdit.depart_nac = r2.data.departamento
				$scope.pacienteEdit.ciudad_nac = r2.data.ciudad



		$http.put('::antecedentes-laborales/paciente', {paciente_id: pac.id}).then((r)->
			$scope.pacienteEdit.antecedentesLaborales = r.data
		, (r2)->
			console.log 'No se pudo traer los antecedentes', r2
		)		
		$http.put('::accidentes-trabajo/paciente', {paciente_id: pac.id}).then((r)->
			$scope.pacienteEdit.accidentesTrabajo = r.data
		, (r2)->
			console.log 'No se pudo traer los accidentes', r2
		)
		$http.put('::enfermedades-profesionales/paciente', {paciente_id: pac.id}).then((r)->
			$scope.pacienteEdit.enfermedadesProfesionales = r.data
		, (r2)->
			console.log 'No se pudo traer los accidentes', r2
		)

	########################	!!! EDITAR PACIENTE 	  ##################
	########################################################################

		

	
	$scope.traerPacientes = ()->

		$http.get('::pacientes/all').then((r)->
			$scope.opcionesGrid.data = r.data
		, (r2)->
			console.log 'No se pudo traer los usuarios', r2
		)
	$scope.traerPacientes()


	btn1 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.editarPaciente(row.entity)"><md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i></a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarPaciente(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

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
							$http.put('::pacientes/actualizar/' + rowEntity.id, rowEntity).then((r)->
								toastr.success 'Paciente actualizado con éxito', 'Actualizado'
							, (r2)->
								toastr.error 'Cambio no guardado', 'Error'
								console.log 'Falló al intentar guardar: ', r2
							)
						else
							$scope.toastr.warning 'Debe usar M o F'
							rowEntity.sexo = oldValue
					else

						$http.put('::pacientes/actualizar/' + rowEntity.id, rowEntity).then((r)->
							toastr.success 'Paciente actualizado con éxito', 'Actualizado'
						, (r2)->
							toastr.error 'Cambio no guardado', 'Error'
							console.log 'Falló al intentar guardar: ', r2
						)

				$scope.$apply()
			)

	}

])