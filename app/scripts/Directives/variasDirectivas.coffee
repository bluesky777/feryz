angular.module('feryzApp')


.directive('focusMe', ['$timeout', '$parse', ($timeout, $parse)->
	return {
		scope: { trigger: '=focusMe' },
		link: (scope, element, attrs)->
			scope.$watch('trigger', (value)->
				#console.log('trigger', value)
				if(value == true) 
					element[0].focus()
					scope.trigger = false
			
			)
	}
])

