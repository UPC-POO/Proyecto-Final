
require_relative './Solicitante'
require_relative './Administrativo'
require_relative './ProfesorTCompleto'

class Universidad
	attr_reader :arregloSolicitantes
	def initialize
		@arregloSolicitantes = []
	end
	def registrarSolicitante(solicitante)
		arregloSolicitantes.push(solicitante)
	end
	#def listarSolicitante
		#for solicitante in arregloSolicitantes
		#	puts solicitante.obtenerDatos
		#end
	
	#end
	def obtenerSolicitantes()
		return arregloSolicitantes
	end

	def evaluarRegistro
		for solicitante in arregloSolicitantes
			if solicitante.solicitudDeAfiliacion == true && solicitante.tipoContrato == "FullTime"
						valor = puts"La solicitud de #{solicitante.nombre} con codigo #{solicitante.generarCodigoAfiliacion} fue APROBADA"
			else solicitante.solicitudDeAfiliacion == false 
						valor = puts "La solicitud de #{solicitante.nombre} con codigo #{solicitante.generarCodigoAfiliacion} no fue aprobada, debido a que no cumple con los requisitos."
			end
		end
		return valor
	end

	def listarAfiliadosconDependientes
		for solicitante in arregloSolicitantes
			if solicitante.numeroDependientes > 0
				puts solicitante.obtenerDatos
			else
				return nil
			end
		end
	end

	def listarCantidadAfiliados
		return puts "La cantidad de afiliados son= #{arregloSolicitantes.count}"
	end


	def calcularImporteTotalEPS
		sumaTotal = 0
		for solicitante in arregloSolicitantes
			sumaTotal = sumaTotal + solicitante.calcularTarifaEPS
		end
			return puts "La suma total del importe de EPS de los colaboradores es: #{sumaTotal}"
	end

	def buscarAfiliadoPorDNI(dni)
		for solicitante in arregloSolicitantes
			if solicitante.dni == dni
				return solicitante
			end
		end
		return   nil
	end

	def obtenerSolicitanteMayorSueldo
		mayorSueldo = 0
		solicitanteMayorSuel = nil
		for solicitante in arregloSolicitantes
			if solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El postulante de Mayor calificacion es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end

	def obtenerSolicitanteMenorSueldo
		menorSueldo = 999999
		solicitanteMenorSuel = nil
		for solicitante in arregloSolicitantes
			if solicitante.calcularSueldoFinal < menorSueldo
				menorSueldo = solicitante.calcularSueldoFinal
				solicitanteMenorSuel = solicitante
			end
		end
		return puts "El Solicitante de menor calificacion es: \n#{solicitanteMenorSuel.obtenerDatos}"
	end

	def obtenerAdministrativoMayorSueldo
		mayorSueldo = 0
		solicitanteMayorSuel = nil
		for solicitante in arregloSolicitantes
			if (solicitante.is_a? Administrativo) && solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El Administrativo de Mayor Sueldo es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end

	def obtenerProfesorMayorSueldo
		mayorSueldo = 0
		solicitanteMayorSuel = nil
		for solicitante in arregloSolicitantes
			if (solicitante.is_a? ProfesorTCompleto) && solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El Profesor de Mayor Sueldo es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end
end