angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		$state.
			state('panel.proveedores', {
				url: '^/proveedores'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}proveedores_clientes/proveedores.tpl.html"
						controller: 'ProveedoresCtrl'

				data: 
					pageTitle: 'Proveedores - Feryz'
		 	})


		$state.
			state('panel.clientes', {
				url: '^/clientes'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}proveedores_clientes/clientes.tpl.html"
						controller: 'ClientesCtrl'

				data: 
					pageTitle: 'Clientes - Feryz'
		 	})

	])