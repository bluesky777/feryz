angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('panel.usuarios', {
		 		url: '^/usuarios'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}usuarios/usuarios.tpl.html"
						controller: 'UsuariosCtrl'
		 	})

	])