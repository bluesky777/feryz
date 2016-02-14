
angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('productos', {
		 		url: '/productos'
				views:
					'principal':
						templateUrl: "#{App.views}productos/productos.tpl.html"
						controller: 'ProductosCtrl'
		 	})

	])
