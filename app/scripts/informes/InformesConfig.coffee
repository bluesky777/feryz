'use strict'

angular.module('feryzApp')
	.config ['$stateProvider', 'App', 'USER_ROLES', 'PERMISSIONS', '$translateProvider', ($state, App, USER_ROLES, PERMISSIONS, $translateProvider) ->

		$state
			.state('panel.informes', { #- Estado admin.
				url: '^/informes/'
				views:
					'contenido_panel':
						templateUrl: "==informes/informes.tpl.html"
						controller: 'InformesCtrl'
				###resolve: { 
					resolved_user: ['AuthService', (AuthService)->
						AuthService.verificar()
					]
					pacientes: ['$http', ($http)->
						$http.get('::pacientes/all')
					]
				}
				###
				data: 
					pageTitle: 'Informes'
			})

		
		.state 'panel.informes.ver_usuarios',
			url: 'ver_usuarios'
			views: 
				'report_content':
					templateUrl: "==informes/verUsuarios.tpl.html"
					controller: 'VerUsuariosCtrl'
					resolve:
						usuarios: ['$http', '$stateParams', ($http, $stateParams)->
							$http.get('::usuarios/all');
						],
			data: 
				pageTitle: 'Usuarios - Feryz'


		.state 'panel.informes.ver_productos',
			url: 'ver_productos'
			views: 
				'report_content':
					templateUrl: "==informes/verProductos.tpl.html"
					controller: 'VerProductosCtrl'
					resolve:
						productos: ['$http', '$stateParams', ($http, $stateParams)->
							$http.get('::productos/all');
						],
			data: 
				pageTitle: 'Productos - Feryz'


		.state 'panel.informes.ver_proveedores',
			url: 'ver_proveedores'
			views: 
				'report_content':
					templateUrl: "==informes/verProveedores.tpl.html"
					controller: 'VerProveedoresCtrl'
					resolve:
						proveedores: ['$http', '$stateParams', ($http, $stateParams)->
							$http.get('::proveedores/all');
						],
			data: 
				pageTitle: 'Proveedores - Feryz'


		


		return
	]
