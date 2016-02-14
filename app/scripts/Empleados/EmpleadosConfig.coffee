
angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('empleados', {
		 		url: '/empleados'
				views:
					'principal':
						templateUrl: "#{App.views}empleados/empleados.tpl.html"
						controller: 'EmpleadosCtrl'
		 	})

	])
