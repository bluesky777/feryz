
angular.module('feryzApp')
	.config(['$stateProvider','App',($state, App)->

		$state.
			state('panel.pacientes',{
				url:'^/pacientes'
				views:
					'contenido_panel':
						templateUrl:"==pacientes/pacientes.tpl.html"
						controller: 'PacientesCtrl'

			})

		return

	])