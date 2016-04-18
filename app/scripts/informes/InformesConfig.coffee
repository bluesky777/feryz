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

		$translateProvider.translations('EN',
			INICIO_MENU: 'Home'
		)
		.translations('ES',
			INICIO_MENU: 'Inicio'

		)
		.translations('PT',
			INICIO_MENU: 'Inicio'

		)
		.translations('FR',
			INICIO_MENU: 'Inicio'

		)

		


		return
	]
