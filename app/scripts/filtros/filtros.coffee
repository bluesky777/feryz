angular.module('feryzApp')

.filter('porIdioma', [ ->
	(input, idioma) ->

		if input
			
			resultado = []

			idioma = parseFloat(idioma)

			for elemento in input

				idioma_id = parseFloat(elemento.idioma_id)
				
				if idioma == idioma_id
					resultado.push elemento

			return resultado
		else
			return false
])








