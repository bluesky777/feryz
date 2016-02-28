angular.module('feryzApp')

.controller('EmpleadosCtrl', ['$scope', '$http', '$filter', 'toastr', ($scope, $http, $filter, toastr) ->
	
	$scope.creando = false
	$scope.empleadoNuevo = {}
	$scope.editando = false
	$scope.empleadoEdit = {}
	$scope.empleados = []

	$scope.crearEmpleado = ()->
		$scope.creando = true

	$scope.guardarEmpleado = ()->

		$http.one('empleados/guardar').customPOST($scope.empleadoNuevo).then( (r)->
			$scope.empleados.push r
			toastr.success 'Creado correctamente: ' + r.nombre
			$scope.creando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Empleado', r2
		)
		

	$scope.eliminarEmpleado = (emp)->
		
		$http.one('empleados/eliminar').customDELETE(emp.id).then( (r)->
			$scope.empleados = $filter('filter')($scope.empleados, {id: '!'+emp.id})
		, (r2)->
			console.log 'No se pudo eliminar empleado', r2

		)

	$scope.actualizarEmpleado = (usu)->
		$http.one('empleados/actualizar').customPUT($scope.empleadoEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
			console.log 'No se pudo guardar Empleado', r2
		)

	$scope.editarEmpleado = (usu)->
		$scope.editando = true
		$scope.empleadoEdit = prod
		

	
	$scope.traerEmpleados = ()->

		$http.one('empleados').customGET('all').then( (r)->
			$scope.empleados = r
		, (r2)->
			console.log 'No se pudo traer los empleados', r2

		)
	$scope.traerEmpleados()

])