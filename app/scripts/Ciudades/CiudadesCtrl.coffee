angular.module('feryzApp')

.controller('CiudadesCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', ($scope, $http, App, $filter, toastr) ->
		
	$scope.creandociudad = false
	$scope.creandodepartamento = false
	$scope.creandopais = false

	$scope.crearciudad = {nuevo_depart: false }

	$scope.creardepartamento = { }

	$scope.crearpais = { }

	$scope.crearActual = {}
	

	####################################################################################
	############################!traer paises###########################################
	

	$http.get('::paises/all').then((r)->
		$scope.paises = r.data
		$scope.crearciudad.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.creardepartamento.pais = $filter('filter')($scope.paises, { id: 1 })[0]
		$scope.paisSeleccionado($scope.crearciudad.pais)
		
	, ()->
		toastr.error 'No se pudo traer las ciudades.'
	)

	$scope.paisSeleccionado = (pais, modelo)->
		$scope.guardar = true
		$http.get('::ciudades/departamentos', {params: {pais_id: pais.id} }).then((r)->
			$scope.departamentos = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)

	$scope.departamentoSeleccionado = (depart, modelo)->

		$scope.guardar = false
		$http.get('::ciudades/ciudades', {params: {departamento: depart.departamento} }).then((r)->
			$scope.ciudades = r.data
		, ()->
			toastr.error 'No se pudo traer las ciudades.'
		)

	########################### !traer paises##############################################
	#######################################################################################


	$scope.crearCiudad = ()->
		$scope.creandociudad = true

	$scope.crearDepartamento = ()->
		$scope.creandodepartamento = true

	$scope.crearPais = ()->
		$scope.creandopais = true

	$scope.guardarCiudad = ()->

		$http.post('::ciudades/guardarciudad', $scope.crearciudad ).then( (r)->
			toastr.success 'Creado correctamente: ' + $scope.crearciudad.ciudad
			$scope.creandociudad = false
			$scope.crearciudad = {}
			$scope.guardar = true

			$http.get('::paises/all').then((r)->
			$scope.paises = r.data
			$scope.crearciudad.pais = $filter('filter')($scope.paises, { id: 1 })[0]
			$scope.paisSeleccionado($scope.crearciudad.pais)
			

			, (r2)->
				toastr.error 'No se pudo traer las ciudades.'
			)
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)

	$scope.guardarDepartamento = ()->

		$http.post('::ciudades/guardardepartamento', $scope.creardepartamento ).then( (r)->
			toastr.success 'Creado correctamente: ' + $scope.creardepartamento.departamento
			$scope.creardepartamento = []
			$scope.guardar = true
			$http.get('::paises/all').then((r)->
			$scope.paises = r.data
			$scope.creardepartamento.pais = $filter('filter')($scope.paises, { id: 1 })[0]
			$scope.paisSeleccionado($scope.crearciudad.pais)
			, (r2)->
				toastr.error 'No se pudo traer las ciudades.'
			)
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)

	$scope.eliminarUsuario = (usu)->
		
		$http.delete('::usuarios/eliminar/' + usu.id).then( (r)->
			$scope.usuarios = $filter('filter')($scope.usuarios, {id: '!'+usu.id})
		, (r2)->
			console.log 'No se pudo eliminar producto', r2
		)

	$scope.actualizarCiudad = (usu)->
		$http.put('::ciudades/actualizar', $scope.crear).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)

	$scope.editarUsuario = (usu)->
		$scope.editando = true
		$scope.usuarioActualizar = usu
		# Configuramos el tipo para el SELECT2
		tipo = $filter('filter')($scope.tipos_doc, {tipo: $scope.usuarioActualizar.doc_tipo}, true)
				
		if tipo.length > 0
			tipo = tipo[0]
		else
			tipo = $scope.tipos_doc[0]
		
		$scope.usuarioActualizar.doc_tipo = tipo

		
		# Configuramos la ciudad nac 

		if $scope.usuarioActualizar.ciudad_nac == null
			$scope.usuarioActualizar.pais = {id: 1, pais: 'COLOMBIA', abrev: 'CO'}
			$scope.paisSeleccionado($scope.usuarioActualizar.pais, $scope.usuarioActualizar.pais)
		else
			$http.get('::ciudades/datosciudad/'+$scope.usuarioActualizar.ciudad_nac).then (r2)->
				$scope.paises = r2.data.paises
				$scope.departamentosNac = r2.departamentos
				$scope.ciudadesNac = r2.ciudades
				$scope.usuarioActualizar.pais = r2.pais
				$scope.usuarioActualizar.depart_nac = r2.departamento
				$scope.usuarioActualizar.ciudad_nac = r2.ciudad
		

	
	

])