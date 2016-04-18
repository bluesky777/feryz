angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('panel.configuraciones', {
		 		url: '^/configuraciones'
				views:
					'contenido_panel':
						templateUrl: "==configuraciones/configuraciones.tpl.html"
						controller: 'ConfiguracionesCtrl'
		 	})

	])