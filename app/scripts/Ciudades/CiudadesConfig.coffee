angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('panel.ciudades', {
		 		url: '^/ciudades'
				views:
					'contenido_panel':
						templateUrl: "==ciudades/ciudades.tpl.html"
						controller: 'CiudadesCtrl'
		 	})

	])