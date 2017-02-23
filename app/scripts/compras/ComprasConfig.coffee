angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		$state.
			state('panel.compras', {
				url: '^/compras'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}compras/compras.tpl.html"
						controller: 'ComprasCtrl'

				data: 
					pageTitle: 'Compras - Feryz'
			})



	])