'use strict'

angular.module('feryzApp')

.controller('InformesCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 
	($scope, $http, $state, $cookies, $rootScope, toastr, $filter) ->

		$scope.verUsuarios = ()->
			$state.go 'panel.informes.ver_usuarios', {}, {reload: true}


		$scope.$on 'cambia_descripcion', (event, descrip)->
			$scope.descripcion_informe = descrip


	]
)


