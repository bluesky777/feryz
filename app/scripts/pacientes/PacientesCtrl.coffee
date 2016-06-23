angular.module('feryzApp')

.controller('PacientesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', 'AuthService','$state', ($scope, $http, App, $filter, toastr, AuthService, $state) ->
	$scope.pacienteEdit = {}
	$scope.pacienteNuevo = 
		sexo: 'M'
		estereopsis: 'N' 
		test_color: 'N'
		sintomas_vision: []
		cigarrillo : 0
		alcohol : 0
		drogas : 0
		dieta : 1
		ejercicio : 1




	$scope.creando = false
	$scope.editando = false
	$scope.estados_generales = [
		{descripcion: 'Alerta, orientado en persona, tiempo y lugar, ingresa caminando por sus propios medios, responde atento al interrogatorio.'}
		{descripcion: 'calmado, todo bien todo bonito, tiempo y lugar, ingresa caminando por sus propios medios, responde atento al interrogatorio.'}
		{descripcion: 'otro, todo bien todo bonito, tiempo y lugar, ingresa caminando por sus propios medios, responde atento al interrogatorio.'}
	]
	$scope.constituciones = [
		{descripcion: 'Eutrófica.'}
		{descripcion: 'Eulargica.'}
		{descripcion: 'Histérica.'}
	]
	$scope.dominancias = [
		{descripcion: 'Mano derecha.'}
		{descripcion: 'Mano izquierda.'}
	]
	$scope.agudeza_visual = [
		{descripcion: 'Normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.ojo_derecho = [
		{descripcion: 'Normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.ojo_izquierdo = [
		{descripcion: 'Normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.organos_sentidos = [
		{descripcion: 'Otoscopia bilateral normal, orofaringe normal, ojos sin alteracion.'}
		{descripcion: 'Anormal.'}
	]
	$scope.cardio_pulmonar = [
		{descripcion: 'Ruidos cardiacos ritmicos, sin soplos, murmullo vesicular normal. resto normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.abdomen = [
		{descripcion: 'Blando, no masas, pristaltismo normal, no eventraciones.'}
		{descripcion: 'Anormal.'}
	]
	$scope.genito_urinario = [
		{descripcion: 'No masas ni eventraciones.'}
		{descripcion: 'Anormal.'}
	]
	$scope.columna_vertebral = [
		{descripcion: 'Simetrica, sin desviaciones, no deformidades patologicas evidentes.'}
		{descripcion: 'Anormal.'}
	]
	$scope.neurologico = [
		{descripcion: 'No deficit motor ni sensitivo, marcha normal, sensibilidad superficial y profunda sin alteraciones, equilibrio normal, romberg normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.osteo_muscular = [
		{descripcion: 'Fuerza muscular consevada, reflejos musculotendinosos presentes simetricos.'}
		{descripcion: 'Anormal.'}
	]
	$scope.extremidades = [
		{descripcion: 'Eutroficas, moviles, sin eema, articulaciones estables, arcos de movimiento conservados sin limitacion.'}
		{descripcion: 'Anormal.'}
	]
	$scope.piel_anexos = [
		{descripcion: 'Piel eucromica, uñas normales, cabello de implantacion normal.'}
		{descripcion: 'Anormal.'}
	]
	$scope.examen_mental = [
		{descripcion: 'Porte y actitud adecuados, lenguaje y pensamiento normal, memoria sin alteraciones.'}
		{descripcion: 'Anormal.'}
	]
	$scope.observaciones = [
		{descripcion: 'ADULTO EN BUENAS CONDICIONES GENERALES DE SALUD. CON EXAMEN MEDICO DENTRO DE LIMITES NORMALES. EXAMENES VALORADOS.'}
		{descripcion: 'Anormal.'}
	]
	$scope.hasRoleOrPerm = AuthService.hasRoleOrPerm

	$scope.cancelarEdicion = ()->
	
		$scope.editando = false

	$scope.crearPaciente = ()->

		$scope.editando = false
		$scope.creando = true
		$scope.pacienteNuevo.doc_tipo = $filter('filter')($scope.tipos_doc,{id:1} )[0]




	
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
		$scope.creando = false
		
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



		$http.put('::pacientes/datos', {paciente_id: pac.id}).then((r)->
			r = r.data
			$scope.pacienteEdit.antecedentesLaborales 	= r.antLab
			$scope.pacienteEdit.enfermedadesProfesionales = r.enfProf
			$scope.pacienteEdit.accidentesTrabajo 		= r.accTrab
			$scope.pacienteEdit.visiometria 			= r.visiometria
			$scope.pacienteEdit.vacunas 				= r.vacunas
			$scope.pacienteEdit.habitos 				= r.habitos
			$scope.pacienteEdit.inmunizaciones 			= r.inmunizaciones
			$scope.pacienteEdit.examen_fisico 			= r.examen_fisico
			$scope.pacienteEdit.examenes_paraclinicos 	= r.examenes_paraclinicos
			$scope.pacienteEdit.diagnostico 			= r.diagnostico
			$scope.pacienteEdit.AntAudit 				= r.antAud
			$scope.pacienteEdit.audiometria 			= r.audiometria
			$scope.pacienteEdit.otoscopia 				= r.otoscopia


			$scope.pacienteEdit.examen_fisico.estado_general 		= if $scope.pacienteEdit.examen_fisico.estado_general == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.estado_general}
			$scope.pacienteEdit.examen_fisico.contitucion 			= if $scope.pacienteEdit.examen_fisico.contitucion == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.contitucion}
			$scope.pacienteEdit.examen_fisico.dominancia 			= if $scope.pacienteEdit.examen_fisico.dominancia == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.dominancia}
			$scope.pacienteEdit.examen_fisico.agudeza_visual 		= if $scope.pacienteEdit.examen_fisico.agudeza_visual == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.agudeza_visual}
			$scope.pacienteEdit.examen_fisico.ojo_derecho 			= if $scope.pacienteEdit.examen_fisico.ojo_derecho == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.ojo_derecho}
			$scope.pacienteEdit.examen_fisico.ojo_izquierdo			= if $scope.pacienteEdit.examen_fisico.ojo_izquierdo == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.ojo_izquierdo}
			$scope.pacienteEdit.examen_fisico.organos_sentidos		= if $scope.pacienteEdit.examen_fisico.organos_sentidos == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.organos_sentidos}
			$scope.pacienteEdit.examen_fisico.cardio_pulmonar		= if $scope.pacienteEdit.examen_fisico.cardio_pulmonar == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.cardio_pulmonar}
			$scope.pacienteEdit.examen_fisico.abdomen				= if $scope.pacienteEdit.examen_fisico.abdomen == "" 			then null else {descripcion: $scope.pacienteEdit.examen_fisico.abdomen}
			$scope.pacienteEdit.examen_fisico.genito_urinario		= if $scope.pacienteEdit.examen_fisico.genito_urinario == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.genito_urinario}
			$scope.pacienteEdit.examen_fisico.columna_vertebral		= if $scope.pacienteEdit.examen_fisico.columna_vertebral == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.columna_vertebral}
			$scope.pacienteEdit.examen_fisico.neurologico			= if $scope.pacienteEdit.examen_fisico.neurologico == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.neurologico}
			$scope.pacienteEdit.examen_fisico.osteo_muscular		= if $scope.pacienteEdit.examen_fisico.osteo_muscular == "" 	then null else {descripcion: $scope.pacienteEdit.examen_fisico.osteo_muscular}
			$scope.pacienteEdit.examen_fisico.extremidades			= if $scope.pacienteEdit.examen_fisico.extremidades == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.extremidades}
			$scope.pacienteEdit.examen_fisico.piel_anexos			= if $scope.pacienteEdit.examen_fisico.piel_anexos == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.piel_anexos}
			$scope.pacienteEdit.examen_fisico.examen_mental			= if $scope.pacienteEdit.examen_fisico.examen_mental == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.examen_mental}
			$scope.pacienteEdit.examen_fisico.observaciones			= if $scope.pacienteEdit.examen_fisico.observaciones == "" 		then null else {descripcion: $scope.pacienteEdit.examen_fisico.observaciones}

			$scope.editando = true

		, (r2)->
			console.log 'No se pudo traer los antecedentes', r2
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


	btn1 = '<a class="btn btn-primary btn-xs" ng-click="grid.appScope.editarPaciente(row.entity)">MODIFICAR <md-tooltip md-direction="left">Editar</md-tooltip><i class="fa fa-edit "></i></a>'
	btn2 = '<a class="btn btn-default btn-xs" ng-click="grid.appScope.eliminarPaciente(row.entity)"><md-tooltip md-direction="left">Eliminar</md-tooltip><i class="fa fa-times "></i></a>'

	$scope.opcionesGrid = {
		showGridFooter: true,
		enableSorting: true,
		columnDefs: [
			{field: 'id', width: 40, enableCellEdit: false}
			{field: 'Editar', cellTemplate: btn1 + btn2, width: 145, enableCellEdit: false }
			{field: 'nombres', minWidth: 100}
			{field: 'apellidos', minWidth: 100}
			{field: 'sexo', width: 50}
			{field: 'empresa_usuaria', displayName: 'Empresa'}
			{field: 'actividad_economica', displayName: 'Actividad'}
			{field: 'fecha_ingreso', type: 'date', format: 'yyyy-mm-dd'}
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