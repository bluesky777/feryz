'use strict'

angular.module('feryzApp')

.controller('InformesCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter) ->

		$scope.verUsuarios = ()->
			$state.go 'panel.informes.ver_usuarios', {}, {reload: true}
		
		$scope.verPacientes = ()->
			$state.go 'panel.informes.ver_pacientes', {}, {reload: true}

		$scope.verExamenIngreso = ()->
			$state.go 'panel.informes.ver_exameningreso', {}, {reload: true}


		$scope.$on 'cambia_descripcion', (event, descrip)->
			$scope.descripcion_informe = descrip


	]
)


