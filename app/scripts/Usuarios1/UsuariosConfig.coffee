angular.module('feryzApp')
	.config(['$stateProvider', 'App', ($state, App) ->

		 $state.
		 	state('usuarios', {
		 		url: '/usuarios1'
				views:
					'principal':
						templateUrl: "#{App.views}usuarios1/usuarios1.tpl.html"
						controller: 'Usuarios1Ctrl'
		 	})

	])