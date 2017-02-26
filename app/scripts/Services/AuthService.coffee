angular.module('feryzApp')

.factory('AuthService', ['App', '$state', '$http', '$cookies', 'Perfil', '$rootScope', 'AUTH_EVENTS', '$q', '$filter', 'toastr', (App, $state, $http, $cookies, Perfil, $rootScope, AUTH_EVENTS, $q, $filter, toastr)->
	authService = {}


	authService.verificando = false
	authService.promesa_de_verificacion = {}


	authService.verificar = ()->

		if authService.verificando

			return authService.promesa_de_verificacion

		else

			d = $q.defer();

			# No necesitaría verificar si ya se ha logueado
			if Perfil.User().id
				d.resolve Perfil.User()
			else
				if $cookies.get('xtoken')
					if $cookies.get('xtoken') != undefined and $cookies.get('xtoken') != 'undefined'  and $cookies.get('xtoken') != '[object Object]'
						authService.login_from_token().then((usuario)->
							Perfil.setUser usuario
							d.resolve usuario
						, (r2)->
							console.log 'No se logueó from token'
							d.reject r2
							#authService.borrarToken()
							#$rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
						)
					else
						console.log 'Token mal estructurado: ', $cookies.get('xtoken')
						authService.borrarToken()
						$rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
						d.reject 'Token mal estructurado.'
				else
					console.log 'No hay cookie token.'
					d.reject 'No hay cookie token.'
					$state.go 'login'
					$rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)

			authService.promesa_de_verificacion = d.promise

			return authService.promesa_de_verificacion


	authService.verificar_acceso = ()->
		if !Perfil.User().id
			$state.go 'login'

		next = $state.current

		if next.data.needed_roles
			needed_roles = next.data.needed_roles 

			if (!authService.isAuthorized(needed_roles))
				#event.preventDefault()
				console.log 'No tiene permisos, y... '
				
				$rootScope.lastState = next.name
				if (authService.isAuthenticated())
					# user is not allowed
					$rootScope.$broadcast(AUTH_EVENTS.notAuthorized)
					console.log '...está Autenticado.'
				else
					# user is not logged in
					#$rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
					console.log '...NO está Autenticado.'
					$state.transitionTo 'login'
			else
				return true
		else
			return true



	authService.login_credentials = (credentials)->

		d = $q.defer();

		authService.borrarToken()

		$http.post('::login/login', credentials).then((r)->
			#debugger
			if r.data.token
				$cookies.put('xtoken', r.data.token)
				
				$http.defaults.headers.common['Authorization'] = 'Bearer ' + $cookies.get('xtoken')

				Perfil.setUser r.data
				
				$rootScope.$broadcast AUTH_EVENTS.loginSuccess
				d.resolve r.data
			else
				#console.log 'No se trajo un token en el login.', r.data
				$rootScope.$broadcast AUTH_EVENTS.loginFailed
				d.reject 'Error en login'


		, (r2)->
			$rootScope.$broadcast AUTH_EVENTS.loginFailed

			if r2
				if r2.status
					if r2.status == 400
						toastr.error 'Datos inválidos', '', {timeOut: 8000}
					else if r2.status == -1
						toastr.error 'No parece haber comunicación con el servidor', '', {timeOut: 8000}
					else if r2.status == 500
						toastr.error 'No parece haber comunicación con la Base de datos', '', {timeOut: 8000}

				else if r2.data
					if r2.data.error
						if r2.data.error == 'Token expirado' or r2.error == 'token_expired'
							toastr.warning 'La sesión ha expirado'
							if $state.current.name != 'login'
								$state.go 'login'
							
						else
							$rootScope.$broadcast AUTH_EVENTS.loginFailed
				else
					toastr.error 'No parece haber comunicación con el servidor'
			else
				toastr.error 'No parece haber comunicación con el servidor'
			d.reject 'Error en login'
		)
		return d.promise


	authService.login_from_token = ()->

		d = $q.defer();

		#console.log Perfil.User()

		if Perfil.User().id or Perfil.User().id == undefined

			$http.defaults.headers.common['Authorization'] = 'Bearer ' + $cookies.get('xtoken')

			login = $http.post('::login/verificar').then((r)->

				$rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
				d.resolve r.data

			, (r2)->
				console.log 'No se pudo loguear con token. ', r2
				d.reject 'Error en login con token.'
				$rootScope.$broadcast AUTH_EVENTS.loginFailed
			)
		
		else
			d.resolve Perfil.User()

		return d.promise


	authService.logout = (credentials)->
		#Restangular.one('logout').get();
		$rootScope.lastState = null
		$rootScope.lastStateParam = null
		authService.borrarToken()
		Perfil.deleteUser()
		$state.transitionTo 'login'

	authService.borrarToken = ()->
		$cookies.remove('xtoken')
		delete $http.defaults.headers.common['Authorization']

	authService.isAuthenticated = ()->
		return !!Perfil.User().id;


	authService.isAuthorized = (needed_roles)->

		user = Perfil.User()
		if user.is_superuser
			return true


		if (!angular.isArray(needed_roles))
			needed_roles = [needed_roles]

		if needed_roles.length == 0
			return true; # No se requiere ningún permiso

		newArr = []
		_.each(needed_roles, (elem)->
			if (user.tipo == elem)
				newArr.push elem
		)
		return (authService.isAuthenticated() and (newArr.length > 0))


	authService.hasRole = (needed_roles)->
		user = Perfil.User()

		if user.is_superuser
			return true

		newArr = []
		_.each(needed_roles, (elem)->
			if (user.tipo == elem)
				newArr.push elem
		)
		return (authService.isAuthenticated() and (newArr.length > 0))



	return authService;
])

