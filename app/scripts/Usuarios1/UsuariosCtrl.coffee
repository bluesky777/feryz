angular.module('feryzApp')

.controller('Usuarios1Ctrl', ['$scope', '$http', '$filter', 'toastr', ($scope, $http, $filter, toastr) ->
		
	$scope.creando = false
	$scope.usuarioNuevo = {}
	$scope.editando = false
	$scope.usuarioEdit = {}
	$scope.usuarios = []

	$scope.crearUsuario = ()->
		$scope.creando = true

	$scope.guardarUsuario = ()->

		$http.post('http://localhost:8080/feryz_server/public/usuarios/guardar', $scope.usuarioNuevo ).then( (r)->
			console.log '$scope.usuarios',$scope.usuarios
			$scope.usuarios.push r.data
			toastr.success 'Creado correctamente: ' + r.nombre
			$scope.creando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)
		

	$scope.eliminarUsuario = (usu)->
		
		Restangular.one('usuarios/eliminar').customDELETE(usu.id).then( (r)->
			$scope.usuarios = $filter('filter')($scope.usuarios, {id: '!'+usu.id})
		, (r2)->
			console.log 'No se pudo eliminar producto', r2

		)

	$scope.actualizarUsuario = (usu)->
		Restangular.one('usuarios/actualizar').customPUT($scope.usuarioEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)

	$scope.editarUsuario = (usu)->
		$scope.editando = true
		$scope.usuarioEdit = prod
		

	
	$scope.traerUsuarios = ()->

		$http.get('http://localhost:8080/feryz_server/public/usuarios/all').then((r)->
			$scope.usuarios = r.data
			$scope.gridOptions.data = r.data
		, (r2)->
			console.log 'No se pudo traer los usuarios', r2
		)
	$scope.traerUsuarios()

	$scope.gridOptions =
		showGridFooter: true,
		enableSorting: true,
		enableFiltering: true,
		enableGridColumnMenu: false,
		columnDefs: [
			{ field: 'id', displayName: 'Codigo'}
			{ field: 'nombre'}
			{ field: 'correo'}
		]

])