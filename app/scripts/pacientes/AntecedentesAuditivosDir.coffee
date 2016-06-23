angular.module('feryzApp')

.directive('antecedentesAuditivosDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/antecedentesAuditivosDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'AntecedentesAuditivosCtrl'
])

.controller('AntecedentesAuditivosCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', '$uibModal', ($scope, $http, App, $filter, toastr, $modal) ->	


	$scope.modificarAntAudit = ()->

		$http.put('::pacientes/actualizar', $scope.pacienteEdit).then( (r)->
			toastr.success 'Actualizado correctamente: ' + r.nombre
			$scope.editando = false
		, (r2)->
			toastr.error 'No se pudo crear', 'Error'
		)


	$scope.clickeando0 = (numero)->
		$scope.pacienteEdit.audiometria.int0 = numero

	$scope.clickeando10 = (numero)->
		$scope.pacienteEdit.audiometria.int10 = numero

	$scope.clickeando20 = (numero)->
		$scope.pacienteEdit.audiometria.int20 = numero

	$scope.clickeando30 = (numero)->
		$scope.pacienteEdit.audiometria.int30 = numero

	$scope.clickeando40 = (numero)->
		$scope.pacienteEdit.audiometria.int40 = numero

	$scope.clickeando50 = (numero)->
		$scope.pacienteEdit.audiometria.int50 = numero

	$scope.clickeando60 = (numero)->
		$scope.pacienteEdit.audiometria.int60 = numero

	$scope.clickeando70 = (numero)->
		$scope.pacienteEdit.audiometria.int70 = numero

	$scope.clickeando80 = (numero)->
		$scope.pacienteEdit.audiometria.int80 = numero

	$scope.clickeando90 = (numero)->
		$scope.pacienteEdit.audiometria.int90 = numero

	$scope.clickeando100 = (numero)->
		$scope.pacienteEdit.audiometria.int100 = numero

	$scope.clickeando110 = (numero)->
		$scope.pacienteEdit.audiometria.int110 = numero

	$scope.clickeando120 = (numero)->
		$scope.pacienteEdit.audiometria.int120 = numero


])



