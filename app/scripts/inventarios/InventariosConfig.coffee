angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('panel.inventarios', {
		 		url: '^/inventarios'
				views:
					'contenido_panel':
						templateUrl: "==inventarios/inventarios.tpl.html"
						controller: 'InventariosCtrl'
		 	})

	])