angular.module('feryzApp')

.directive('updateTitle', ['$rootScope', '$timeout',
	($rootScope, $timeout)->
			link: (scope, element)->

				listener = (event, toState, toParams)->

					title = 'Feryz'
					if toState.data and toState.data.pageTitle
						title = toState.data.pageTitle

					if toParams
						if toParams.username
							title = toParams.username + ' - Feryz'

					$timeout(()->
						element.text(title)
					, 0, false)

				$rootScope.$on('$stateChangeSuccess', listener)
])
