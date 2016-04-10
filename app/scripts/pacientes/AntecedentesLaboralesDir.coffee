angular.module('feryzApp')

.directive('antecedentesLaboralesDir',['toastr', '$http', (toastr, $http)-> 

	restrict: 'AE'
	transclude: true,
	templateUrl: "==pacientes/antecedentesLaborales.tpl.html"
	#scope: 
	#	ngModel: "="
	#require: 'ngModel'

	link: (scope, iElem, iAttrs)->
		

		$http.get('::antecedentes-laborales/all').then((r)->
			scope.antecedentesLaborales = r.data
		, (r2)->
			console.log 'No se pudo traer los antecedentes', r2
		)


		scope.creandoAntecLabor = false
		scope.editandoAntecLabor = false
		scope.AntecLaborNuevo = {}


		scope.editarAntecLabor = (antec)->
			scope.editandoAntecLabor = true
			scope.AntecLaborActual = antec


		scope.guardarAntecedenteLaboral = ()->
			scope.AntecLaborNuevo.paciente_id = 1 # pacienteEdit.id
			
			$http.post('::antecedentes-laborales/guardar', scope.AntecLaborNuevo).then((r)->
				scope.antecedentesLaborales.push r.data
				scope.creandoAntecLabor = false
				scope.AntecLaborNuevo = {}
			, (r2)->
				console.log 'No se pudo agregar antecedente', r2
			)


])