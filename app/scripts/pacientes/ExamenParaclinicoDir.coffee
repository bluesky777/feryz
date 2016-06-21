angular.module('feryzApp')

.directive('examenParaclinicoDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/examenParaclinicoDir.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'
	controller: 'ExamenParaclinicoCtrl'
])

.controller('ExamenParaclinicoCtrl', ['$scope', '$http', 'App', '$filter', 'toastr', '$uibModal', ($scope, $http, App, $filter, toastr, $modal) ->	

		$scope.exaDatos = {}
		$scope.creandoExam = false

		$scope.examenes_opcionales = [
			{examen: 'Audiometría'}
			{examen: 'Visiometría'}
			{examen: 'Expirometría'}
		]

		$scope.eliminarExam = (exam)->
			
			modalInstance = $modal.open({
				templateUrl: '==pacientes/removeExamParaclinico.tpl.html'
				controller: 'RemoveExamenParaclinicoCtrl'
				resolve: 
					exam: ()->
						exam
			})
			modalInstance.result.then( (exam)->
				$scope.pacienteEdit.examenes_paraclinicos = $filter('filter')($scope.pacienteEdit.examenes_paraclinicos, {id: '!'+exam.id})
			)



		$scope.guardarExam = (exam)->
			$scope.creandoExam = true
			$scope.datosEnv = {}
			$scope.datosEnv.paciente_id = $scope.pacienteEdit.id

			$scope.datosEnv.examen = $scope.exaDatos.examen_nuevo.examen
			
			$http.post('::paraclinicos/guardar', $scope.datosEnv).then((r)->
				$scope.pacienteEdit.examenes_paraclinicos.push r.data
				$scope.creandoExam = false
				toastr.success 'Cambios guardados.'
			, (r2)->
				toastr.error 'No se pudo agregar examen paraclínico.'
				$scope.creandoExam = false
			)

		$scope.modificarExam = (exam)->

			$http.put('::paraclinicos/actualizar', exam).then((r)->
				toastr.success 'Modificado'
			, (r2)->
				toastr.error 'No se pudo modificar'
			)


])


.controller('RemoveExamenParaclinicoCtrl', ['$scope', '$uibModalInstance', 'exam', '$http', 'toastr', ($scope, $modalInstance, exam, $http, toastr)->
	$scope.exam = exam

	$scope.ok = ()->

		$http.delete('::paraclinicos/destroy/'+exam.id).then((r)->
			toastr.success 'Examen: '+exam.examen+' eliminado.', 'Eliminado'
		, (r2)->
			toastr.warning 'Problema', 'No se pudo eliminar examen.'
		)
		$modalInstance.close(exam)

	$scope.cancel = ()->
		$modalInstance.dismiss('cancel')

])

