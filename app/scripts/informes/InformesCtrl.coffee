'use strict'

angular.module('feryzApp')

.controller('InformesCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'toastr', '$filter', 
	($scope, $http, $state, $cookieStore, $rootScope, toastr, $filter) ->
		
		$scope.config = {}


		$scope.verProductos = ()->
			$state.go 'panel.informes.ver_productos', {}, {reload: true}
		
		$scope.verProveedores = ()->
			$state.go 'panel.informes.ver_proveedores', {}, {reload: true}

		$scope.verUsuarios = ()->
			$state.go 'panel.informes.ver_usuarios', {}, {reload: true}


		$scope.$on 'cambia_descripcion', (event, descrip)->
			$scope.descripcion_informe = descrip



		if $cookieStore.get 'config'
			texto = $cookieStore.get 'config'
			$scope.config = JSON.parse texto
			$scope.informe_tab_productos 	= if $scope.config.informe_tab_actual 	=='productos' then true else false
			#console.log '$scope.config', $scope.config
		else
			$scope.config.orientacion = 'vertical'

		$scope.$watch 'config', (newVal, oldVal)->
			$cookieStore.put 'config', JSON.stringify newVal
			$scope.$broadcast 'change_config'
		, true


		$scope.tabSeleccionado = (selectedIndex)->
			console.log($scope.config)
			$scope.config.informe_tab_actual = selectedIndex
			$cookieStore.put 'config', JSON.stringify $scope.config



	]
)


