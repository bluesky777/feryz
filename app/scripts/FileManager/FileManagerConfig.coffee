'use strict'

angular.module('feryzApp')
	.config ['$stateProvider', ($state) ->

		$state
			.state 'panel.filemanager',
				url: '/filemanager'
				views: 
					'contenido_panel':
						templateUrl: "==fileManager/fileManager.tpl.html"
						controller: 'FileManagerCtrl'
				data: 
					pageTitle: 'Administrador de archivos'



]
