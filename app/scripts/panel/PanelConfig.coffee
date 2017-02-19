'use strict'

angular.module('feryzApp')
	.config ['$stateProvider', 'App', 'USER_ROLES', 'PERMISSIONS', '$translateProvider', ($state, App, USER_ROLES, PERMISSIONS, $translateProvider) ->

		$state
			.state('panel', { #- Estado admin.
				url: '/panel'
				views:
					'principal':
						templateUrl: "#{App.views}panel/panel.tpl.html"
						controller: 'PanelCtrl'
				resolve: { 
					resolved_user: ['AuthService', (AuthService)->
						AuthService.verificar()
					]
				
				}
				data: 
					pageTitle: 'Feryz - Bienvenido'
			})


		$translateProvider.preferredLanguage('ES');


		$translateProvider.translations('EN',
			INICIO_MENU: 'Home'
			USERS_MENU: 'Users'
			EVENTS_MENU: 'Events'
			ENTIDADES_MENU: 'Entities'
			CATEGS_MENU: 'Categories'
			PREGUNTAS_MENU: 'Questions'
			EVALUACIONES_MENU: 'Tests'
			IDIOMA_MENU: 'Language'
			INFORMES_MENU: 'Reports'
			SALIR: 'Sign out'

			ELIMINATORIAS: 'Playoffs'
			GRAN_FINAL: 'Great ultimate'
			INSCRITO_EN: 'You are signed in:'
			NO_ESTAS_INSCRITO: 'You are`t signed in any category.'
			EXAM_HECHOS: 'Done Exams'
		)
		.translations('ES',
			INICIO_MENU: 'Inicio'
			EVENTS_MENU: 'Eventos'
			ENTIDADES_MENU: 'Entidades'
			CATEGS_MENU: 'Categorías'
			PREGUNTAS_MENU: 'Preguntas'
			EVALUACIONES_MENU: 'Evaluaciones'
			USERS_MENU: 'Usuarios'
			IDIOMA_MENU: 'Idioma'
			INFORMES_MENU: 'Informes'
			SALIR: 'Salir'

			ELIMINATORIAS: 'Eliminatorias'
			GRAN_FINAL: 'Gran final'
			INSCRITO_EN: 'Estás inscrito en:'
			NO_ESTAS_INSCRITO: 'No estás inscrito en ninguna categoría.'
			EXAM_HECHOS: 'Exámenes hechos'

		)
		.translations('PT',
			INICIO_MENU: 'Iniciação'
			EVENTS_MENU: 'Eventos'
			ENTIDADES_MENU: 'Entidades'
			CATEGS_MENU: 'Categorias'
			PREGUNTAS_MENU: 'Interrogatório'
			EVALUACIONES_MENU: 'Evaluations'
			USERS_MENU: 'Usuários'
			IDIOMA_MENU: 'Língua'
			INFORMES_MENU: 'Informação'
			SALIR: 'Deixar'

			ELIMINATORIAS: 'Playoffs'
			GRAN_FINAL: 'Grande final'
			INSCRITO_EN: 'Você está matriculado:'
			NO_ESTAS_INSCRITO: 'Você não está registrado em qualquer categoria.'
			EXAM_HECHOS: 'Testes feitos'

		)


		return
	]
