angular.module('feryzApp')
	.config(['$stateProvider', 'App', 'USER_ROLES', ($state, App, USER_ROLES) ->

		 $state.
		 	state('panel.usuarios', {
		 		url: '^/usuarios'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}usuarios/usuarios.tpl.html"
						controller: 'UsuariosCtrl'

				data: 
					pageTitle: 'Usuarios - Feryz'
					needed_roles: [USER_ROLES.administrador]
		 	})

	])