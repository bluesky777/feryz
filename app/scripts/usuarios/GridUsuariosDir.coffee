angular.module('feryzApp')

.directive('gridUsuarios',['App', (App)-> 

	restrict: 'E'
	templateUrl: "#{App.views}usuarios/gridUsuariosDir.tpl.html"

	scope: 
		usuarios: "="
		categoriasking: "="
		currentusers: "="
		nivelesking: "="
		idioma: "="

	link: (scope, iElem, iAttrs)->
		# Debo agregar la clase .loading-inactive para que desaparezca el loader de la pantalla.
		# y eso lo puedo hacer con el ng-if

	controller: 'GridUsuariosCtrl'
		

])
