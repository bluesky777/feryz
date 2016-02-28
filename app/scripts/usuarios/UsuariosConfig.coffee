angular.module('feryzApp')

.config(['$stateProvider', 'App', 'PERMISSIONS', ($stateProvider, App, PERMISSIONS)->

	$stateProvider

	.state('panel.usuarios1', { #- Estado admin.
				url: '^/usuarios1'
				views:
					'contenido_panel1':
						templateUrl: "#{App.views}usuarios/usuarios.tpl.html1"
						controller: 'UsuariosCtrl1'

				data: 
					pageTitle: 'Usuarios1'
					needed_permissions: [PERMISSIONS.can_edit_usuarios]
			})


])