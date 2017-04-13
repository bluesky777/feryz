angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		$state.
			state('panel.entradas', {
				url: '^/entradas'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}entradas/entradas.tpl.html"
						controller: 'EntradasCtrl'
						

				data: 
					pageTitle: 'Entradas - Feryz'
					hotkeys: [
						['n', 'Nueva entrada', 'nuevaEntrada()']
					]
				
			})




	])