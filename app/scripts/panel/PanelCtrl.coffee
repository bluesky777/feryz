'use strict'

angular.module('feryzApp')

.controller('PanelCtrl', ['$scope', '$http', '$state', '$cookies', '$rootScope', 'AuthService', 'Perfil', 'App', 'resolved_user', 'toastr', '$translate', '$filter', '$uibModal', 'Fullscreen', 
	($scope, $http, $state, $cookies, $rootScope, AuthService, Perfil, App, resolved_user, toastr, $translate, $filter, $uibModal, Fullscreen) ->


		$scope.USER = resolved_user
		#console.log '$scope.USER', $scope.USER
		$scope.imagesPath = App.images + 'perfil/'

		AuthService.verificar_acceso()


		$rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams)->
			$scope.cambiarTema('theme-zero')


			
		$scope.openMenu = ($mdOpenMenu, ev)->
			originatorEv = ev
			$mdOpenMenu(ev)

		$scope.gotoFilemanager = ()->
			$state.go 'panel.filemanager'

		$scope.gotoUsuarios = ()->
			$state.go 'panel.usuarios'


			
		$scope.set_user_event = (evento)->
			$http.put('eventos/set-user-event', {'evento_id': evento.id}).then((r)->
				console.log 'Evento cambiado: ', r

				$scope.USER.evento_selected_id = evento.id
				$scope.el_evento_actual() # Actualizamos el modelo del evento actual
				toastr.success 'Evento actual cambiado por ' + evento.alias

				$rootScope.$broadcast 'cambio_evento_user' # Anunciamos el cambio de evento.

			, (r2)->
				console.log 'Error conectando!', r2
				toastr.warning 'No se pudo cambiar el evento actual.'

			)

		$scope.logout = ()->
			AuthService.logout()

			$http.put('login/logout').then((r)->
				console.log 'Desconectado con éxito: ', r
			, (r2)->
				console.log 'Error desconectando!', r2
			)

			#$state.go 'login'


		$scope.setImagenPrincipal = ()->
			ini = App.images+'perfil/'

			imgUsuario = $scope.USER.image_nombre
			pathUsu = ini + imgUsuario
			$scope.imagenPrincipal = pathUsu

		$scope.setImagenPrincipal()
		

		$scope.$on 'cambianImgs', (event, data)->
			console.log Perfil.User()
			$scope.USER = Perfil.User()
			$scope.setImagenPrincipal()


		$scope.setFullScreen = ()->
			Fullscreen.toggleAll()

				
		return
	]
)


