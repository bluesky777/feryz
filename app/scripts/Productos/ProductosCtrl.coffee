angular.module('feryzApp')

.controller('ProductosCtrl', ['$scope', 'Restangular', '$filter', 'toastr', ($scope, Restangular, $filter, toastr) ->

	$scope.creando = false
	$scope.productoNuevo = {}
	$scope.editando = false
	$scope.productoEdit = {}
	$scope.productos = []

	$scope.crearProducto = ()->
		$scope.creando = true

	$scope.guardarProducto = ()->

		Restangular.one('productos/guardar').customPOST($scope.productoNuevo).then( (r)->
			$scope.productos.push r
			toastr.success 'Creado correctamente: ' + r.nombre
			$scope.creando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)
		

	$scope.eliminarProducto = (prod)->
		
		Restangular.one('productos/destroy').customDELETE(prod.id).then( (r)->
			$scope.productos = $filter('filter')($scope.productos, {id: '!'+prod.id})
		, (r2)->
			console.log 'No se pudo eliminar producto', r2

		)

	$scope.actualizarProducto = (prod)->
		Restangular.one('productos/actualizar').customPUT($scope.productoEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Producto', r2
		)

	$scope.editarProducto = (prod)->
		$scope.editando = true
		$scope.productoEdit = prod
		


	$scope.traerProductos = ()->

		Restangular.one('productos').customGET('all').then( (r)->
			$scope.productos = r
		, (r2)->
			console.log 'No se pudo traer productos', r2

		)
	$scope.traerProductos()

])

