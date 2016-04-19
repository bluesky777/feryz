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
				resolve: { 
					resolved_user: ['AuthService', (AuthService)->
						AuthService.verificar()
					]
				}
				data: 
					pageTitle: 'Informes'
			})

		
		.state 'panel.informes.ver_usuarios',
			url: 'ver_usuarios'
			views: 
				'report_content':
					templateUrl: "==informes/verUsuarios.tpl.html"
					controller: 'PuestosGrupoPeriodoCtrl'
					resolve:
						usuarios: ['$http', '$stateParams', ($http, $stateParams)->
							$http.get('::usuarios/all');
						],
			data: 
				pageTitle: 'Usuarios - Feryz'


		


		return
	]
