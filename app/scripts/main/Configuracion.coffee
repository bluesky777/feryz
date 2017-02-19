angular.module('feryzApp')


# Configuración principal de nuestra aplicación.
.config(['$cookiesProvider', '$stateProvider', '$urlRouterProvider', '$httpProvider', '$locationProvider', 'App', 'PERMISSIONS', '$intervalProvider', '$rootScopeProvider', 'USER_ROLES', 'toastrConfig', 'uiSelectConfig', ($cookies, $state, $urlRouter, $httpProvider, $locationProvider, App, PERMISSIONS, $intervalProvider, $rootScopeProvider, USER_ROLES, toastrConfig, uiSelectConfig)->

	#Restangular.setBaseUrl App.Server # Url a la que se harán todas las llamadas.

	###
	$httpProvider.defaults.headers.post['X-CSRFToken'] = $cookies.csrftoken;
	$httpProvider.defaults.headers.put['X-CSRFToken'] = $cookies.csrftoken;

	$httpProvider.defaults.useXDomain = true
	$httpProvider.defaults.xsrfCookieName = 'csrftoken';
	$httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken';
	delete $httpProvider.defaults.headers.common['X-Requested-With'];
	###
	$httpProvider.defaults.useXDomain = true;
	#$httpProvider.defaults.withCredentials = true;
	delete $httpProvider.defaults.headers.common["X-Requested-With"];
	$httpProvider.defaults.headers.common["Accept"] = "application/json";
	$httpProvider.defaults.headers.common["Content-Type"] = "application/json";
	
	$httpProvider.interceptors.push(($q)->
		{
			'request': (config)->
				explotado = config.url.split('::')
				if explotado.length > 1
					config.url = App.Server + explotado[1]
				else
					explotado = config.url.split('==')
					if explotado.length > 1
						config.url = App.views + explotado[1]


				config
		}
	)


	uiSelectConfig.theme = 'select2'
	uiSelectConfig.resetSearchInput = true


	#- Definimos los estados
	$urlRouter.otherwise('/login')

	$state
	.state('main', { #- Estado raiz que no necesita autenticación.
		url: '/'
		views: 
			'principal':
				templateUrl: App.views+'main/main.tpl.html'
				controller: 'MainCtrl'
		data: 
			pageTitle: 'En Construcción'
	})

	.state('landing', { #- Estado raiz que no necesita autenticación.
		url: '/landing'
		views: 
			'principal':
				templateUrl: App.views+'main/landing.tpl.html'
				controller: 'LandingCtrl' # El controlador está en 'main.coffee'
		data: 
			pageTitle: 'Inicio Feryz'
	})

	.state('login', { 
		url: '/login'
		views:
			'principal':
				templateUrl: "#{App.views}login/login.tpl.html"
				controller: 'LoginCtrl'
		data: 
			pageTitle: 'Ingresar a Feryz'

	})
	.state('logout', { 
		url: '/logout'
		views:
			'principal':
				templateUrl: "#{App.views}login/logout.tpl.html"
				controller: 'LogoutCtrl'
		data: 
			icon_fa: 'fa fa-user'

	})
	

	#$locationProvider.html5Mode true

	$rootScopeProvider.bigLoader = true




	# Agrego la función findByValues a loDash.
	_.mixin 
		'findByValues': (collection, property, values)->
			filtrado = _.filter collection, (item)->
				_.contains values, item[property]
			if filtrado.length == 0 then return false else filtrado[0]

	angular.extend(toastrConfig, {
		allowHtml: true,
		closeButton: true,
		extendedTimeOut: 1000,
		preventOpenDuplicates: false,
		maxOpened: 3,
		tapToDismiss: true,
		target: 'body',
		timeOut: 4000,
	})

	@
])

# Filtro para frases en Camellcase
.filter('capitalize', ()->
	(input, all)->
		return if !!input then input.replace(/([^\W_]+[^\s-]*) */g, (txt)-> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()) else ''
)




