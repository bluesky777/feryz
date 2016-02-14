angular.module('feryzApp')

.controller('EmpleadosCtrl', ['$scope', 'Restangular', ($scope, Restangular) ->

	$scope.titulo = 'Hoola empleadossss'

	$scope.crearEmpleado = ()->
		alert 'Voy a crearr'

	eliminarEmpleado = ()->
		alert 'Voy a eliminar'

	$scope.traerEmpleados = ()->

		$scope.empleados = [
			{nombre: 'Miguel', Apellidos: 'Llanes', Telefono: 321899192 }
			{nombre: 'Andrés', Apellidos: 'Guerrero', Telefono: 4564564 }
			{nombre: 'Sofia', Apellidos: 'Piña', Telefono: 35645645 }
			{nombre: 'Pulida', Apellidos: 'Papa', Telefono: 7899 }
		]

		Restangular.one('empleados').customGET().then( (r)->
			$scope.empleados = r
		, (r2)->
			console.log 'No se pudo empleados, vamos a crear unos de mentira', r2

		)


])

