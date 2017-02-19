angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		$state.
			state('panel.productos', {
				url: '^/productos'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}productos/productos.tpl.html"
						controller: 'ProductosCtrl'

				data: 
					pageTitle: 'Productos - Feryz'
		 	})


		$state.
			state('panel.categorias', {
				url: '^/categorias'
				views:
					'contenido_panel':
						templateUrl: "#{App.views}productos/categorias.tpl.html"
						controller: 'CategoriasCtrl'

				data: 
					pageTitle: 'Categorías - Feryz'
		 	})

	])