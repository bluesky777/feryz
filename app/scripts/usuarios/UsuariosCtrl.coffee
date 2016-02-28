angular.module('feryzApp')

.controller('UsuariosCtrl', ['$scope', '$http', 'Restangular', '$state', '$cookies', '$rootScope', 'toastr', 'uiGridConstants', '$modal', '$filter', 'App', 'AuthService' 
	($scope, $http, Restangular, $state, $cookies, $rootScope, toastr, uiGridConstants, $modal, $filter, App, AuthService) ->

		AuthService.verificar_acceso()

	
		$scope.creando = false
		$scope.usuarioNuevo = {}
		$scope.editando = false
		$scope.usuarioEdit = {}
		$scope.usuarios = []
		$scope.usuarioNuevo = {
			sexo: 'M'
			nivel: ""
			inscripciones: []
		}
		
		$scope.crearUsuario = ()->
			$scope.creando = true
			$scope.editando = false
		
		$scope.guardarUsuario = ()->
			$scope.editando = false

			Restangular.one('usuarios/guardar').customPOST($scope.usuarioNuevo).then((r)->
				toastr.success 'Usuario guardado con éxito.'
				$scope.usuarios.push r
				$scope.creando = false
				console.log 'Usuario creado', r
			, (r2)->
				toastr.warning 'No se creó el usuario', 'Problema'
				console.log 'No se creó usuario ', r2
				$scope.creando = false
			)
		

		$scope.actualizarUsuario = ()->
			$scope.creando = false

			Restangular.one('usuarios/actualizar').customPUT($scope.usuarioActualizar).then((r)->
				toastr.success 'Cambios guardados.'
				$scope.editando = false
				console.log 'Cambios guardados', r
			, (r2)->
				toastr.warning 'No se guardó cambios del usuario', 'Problema'
				console.log 'No se guardó cambios del usuario ', r2
				$scope.editando = false
			)

		
		$scope.editarUsuario = (user)->
			$scope.creando = false
			$scope.editando = true
			$scope.usuarioActualizar = user
			

		$scope.eliminarUsuario = (user)->
				
			Restangular.one('usuarios/destroy').customDELETE(user.id).then( (r)->
				$scope.usarios = $filter('filter')($scope.usuarios, {id: '!'+user.id})
			, (r2)->
				console.log 'No se pudo eliminar usuarios', r2

			)


		$scope.traerUsuarios = ()->

			Restangular.one('usuarios').customGET('all').then( (r)->
				$scope.usuarios = r
			, (r2)->
				console.log 'No se pudo traer Usuarios', r2

			)
		    
		$scope.traerUsuarios()

		$scope.cancelarNuevo = ()->
			$scope.creando = false


		$scope.cancelarEdicion = ()->
			$scope.editando = false



		
	]
)






