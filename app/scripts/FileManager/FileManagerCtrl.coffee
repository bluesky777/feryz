'use strict'

angular.module("feryzApp")

.controller('FileManagerCtrl', ['$scope', 'Upload', '$timeout', '$filter', 'App', '$http', 'Perfil', '$uibModal', 'resolved_user', 'toastr', 'AuthService', ($scope, $upload, $timeout, $filter, App, $http, Perfil, $modal, resolved_user, toastr, AuthService)->
	
	$scope.USER = resolved_user
	$scope.subir_intacta = {}
	$scope.hasRoleOrPerm = AuthService.hasRoleOrPerm

	fixDato = ()->
		$scope.dato = 
			imgUsuario:
				id:		$scope.USER.imagen_id
				nombre:	$scope.USER.imagen_nombre 

	fixDato()

	$scope.perfilPath = App.images + 'perfil/'
	$scope.imgFiles = []
	$scope.errorMsg = ''
	$scope.fileReaderSupported = window.FileReader != null && (window.FileAPI == null || FileAPI.html5 != false);
	$scope.dato.usuarioElegido = []

	$http.get('::imagenes/usuarios-and-pacientes').then((r)->
		r = r.data
		$scope.imagenes = r.imagenes
		$scope.usuarios = r.usuarios
		$scope.pacientes = r.pacientes
		$scope.dato.usuarioElegido = r[0]
		$scope.dato.imgParaUsuario = r.imagenes[0]
	, (r2)->
		toastr.error 'No se trajeron las imágenes y usuarios.'
	)




	$scope.upload =  (files)->
		$scope.imgFiles = files
		$scope.errorMsg = ''

		if files and files.length

			for i in [0...files.length]
				file = files[i]
				generateThumbAndUpload file


	generateThumbAndUpload = (file)->
		$scope.errorMsg = null
		uploadUsing$upload(file)
		$scope.generateThumb(file)

	$scope.generateThumb = (file)->
		if file != null
			if $scope.fileReaderSupported and file.type.indexOf('image') > -1
				$timeout ()->
					fileReader = new FileReader()
					fileReader.readAsDataURL(file)
					fileReader.onload = (e)->
						$timeout(()->
							file.dataUrl = e.target.result
						)
	
	uploadUsing$upload = (file)->

		intactaUrl = if $scope.subir_intacta.intacta then '-intacta' else ''

		if file.size > 10000000
			$scope.errorMsg = 'Archivo excede los 10MB permitidos.'
			return

		$upload.upload({
			url: App.Server + 'imagenes/store' + intactaUrl,
			#fields: {'username': $scope.username},
			file: file
		}).progress( (evt)->
			progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
			file.porcentaje = progressPercentage
			#console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name, evt.config)
		).success( (data, status, headers, config)->
			if $scope.subir_intacta.intacta
				$scope.imagenes_publicas.push data
			else
				$scope.imagenes_privadas.push data
		).error((r2)->
			console.log 'Falla uploading: ', r2
		).xhr((xhr)->
			#xhr.upload.addEventListener()
			#/* return $http promise then(). Note that this promise does NOT have progress/abort/xhr functions */
		)#.then((), error, progress)


	$scope.pedirCambioUsuario = (imgUsu)->
		$http.put('::imagenes/cambiarimagenperfil/'+$scope.USER.user_id, {imagen_id: imgUsu.id}).then((r)->
			r = r.data
			Perfil.setImagen(r.imagen_id, imgUsu.nombre)
			$scope.$emit 'cambianImgs', {image: r}
			toastr.success 'Imagen principal cambiada'
		, (r2)->
			toastr.error 'No se pudo cambiar imagen', 'Problema'
		)

	$scope.pedirCambioOficial = (imgOfi)->
		$http.put('::imagenes/cambiarimagenoficial/'+$scope.USER.user_id, {foto_id: imgOfi.id}).then((r)->
			r = r.data
			if r.asked_by_user_id
				toastr.info 'Pedido realizado, espera respuesta.'
			else if r == 'En espera'
				toastr.info 'Espera respuesta.'
			else
				Perfil.setOficial(r.foto_id, imgOfi.nombre)
				$scope.$emit 'cambianImgs', {foto: r}
				toastr.success 'Foto oficial cambiada'
		, (r2)->
			toastr.error 'No se pudo cambiar foto', 'Problema'
		)

	$scope.cambiarLogoColegio = (imgLogo)->
		$http.put('::imagenes/cambiarlogocolegio', {logo_id: imgLogo.id}).then((r)->
			toastr.success 'Logo del colegio cambiado'
		, (r2)->
			toastr.error 'No se pudo cambiar el logo', 'Problema'
		)

	$scope.imagenSelect = (item, model)->
		#console.log 'imagenSelect: ', item, model

	$scope.fotoSelect = (item, model)->
		#console.log 'imagenSelect: ', item, model

	$scope.grupoSelect = (item, model)->
		#console.log 'grupoSelect: ', item, model
		$http.get('::grupos/listado/'+item.id).then((r)->
			r = r.data
			$scope.alumnos = r
			$scope.dato.alumnoElegido = r[0]
		, (r2)->
			toastr.error 'No se pudo traer los usuarios'
		)

	$scope.rotarImagen = (imagen)->
		$http.put('::imagenes/rotarimagen/'+imagen.id).then((r)->
			imagen.nombre = ''
			toastr.success 'Imagen rotada'
			imagen.nombre = r + '?' + new Date().getTime()
		, (r2)->
			toastr.error 'Imagen no rotada'
		)




	$scope.borrarImagen = (imagen)->

		modalInstance = $modal.open({
			templateUrl: '==fileManager/removeImage.tpl.html'
			controller: 'RemoveImageCtrl'
			size: 'sm',
			resolve: 
				imagen: ()->
					imagen
				datos_imagen: ()->

					codigos = 
						imagen_id: imagen.id
						user_id: $scope.USER.id

					$http.get('::imagenes/datos-imagen', codigos).then((r)->
						return $scope.datos_imagen = r.data
					, (r2)->
						toastr.error 'Error al traer datos de imagen', 'Problema'
						return {}
					)

		})
		modalInstance.result.then( (imag)->
			if imag.publica
				$scope.imagenes_publicas = $filter('filter')($scope.imagenes_publicas, {id: '!'+imag.id})
			else
				$scope.imagenes_privadas = $filter('filter')($scope.imagenes_privadas, {id: '!'+imag.id})
		)



	$scope.usuarioSelect = (item, model)->
		$scope.dato.selectUsuarioModel = item


	$scope.cambiarFotoUnPaciente = (usuarioElegido, imgPaciente)->
		aEnviar = {
			imgPaciente: imgPaciente.id
		}
		$http.put('::perfiles/cambiar-img-paciente/'+usuarioElegido.id, aEnviar).then((r)->

			usuarSelect = $filter('filter')($scope.alumnos, {id: usuarioElegido.id})
			usuarSelect[0].foto_id = imgPaciente.id
			usuarSelect[0].foto_nombre = imgPaciente.nombre

			toastr.success 'Foto asignada con éxito'
		, (r2)->
			toastr.error 'Error al asignar foto al paciente', 'Problema'
		)

	

	$scope.cambiarFotoUnUsuario = (usuarioElegido, imgUsuario)->
		aEnviar = {
			imgUsuario: imgUsuario.id
		}
		$http.put('::perfiles/cambiar-img-usuario/'+usuarioElegido.id, aEnviar).then((r)->
			toastr.success 'Foto oficial asignada con éxito'
		, (r2)->
			toastr.error 'Error al asignar foto al usuario', 'Problema'
		)



	$scope.pedirCambioFirma = (usuarioElegido, imgFirma)->
		
		aEnviar = {
			imgFirma: imgFirma.id
		}
		$http.put('::perfiles/cambiar-firma/'+usuarioElegido.id, aEnviar).then((r)->
			toastr.success 'Firma asignada con éxito'
		, (r2)->
			toastr.error 'Error al asignar firma', 'Problema'
		)



	return
])

