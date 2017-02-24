angular.module('feryzApp')

.factory('Perfil', ['App', 'AUTH_EVENTS', '$http', (App, AUTH_EVENTS, $http) ->

	user = {}

	setUser: (usuario) ->
		user = usuario

	User: ->
		return user

	id: ->
		user.user_id
	idioma: ->
		user.idioma_main_id

	setImagen: (imagen_id, imagen_nombre)->
		user.imagen_id = imagen_id
		user.image_nombre = imagen_nombre

	deleteUser: ()->
		user = {}

])



.factory('removeAccents', ['App', (App) ->

	funciones = {}

	funciones.search = ''

	funciones.removeAccents = (value)->
		return value
			.replace(/á/g, 'a') 
			.replace(/â/g, 'a')
			.replace(/é/g, 'e')
			.replace(/è/g, 'e') 
			.replace(/ê/g, 'e')
			.replace(/í/g, 'i')
			.replace(/ï/g, 'i')
			.replace(/ì/g, 'i')
			.replace(/ó/g, 'o')
			.replace(/ô/g, 'o')
			.replace(/ú/g, 'u')
			.replace(/ü/g, 'u')
			.replace(/ç/g, 'c')
			.replace(/ß/g, 's')


	funciones.ignoreAccents = (item)->
		
		if (!funciones.search)
			return true
		text = funciones.removeAccents(item.nombre.toLowerCase())
		funciones.search = funciones.removeAccents(funciones.search.toLowerCase());
		return text.indexOf(funciones.search) > -1

	return funciones
	   
])
