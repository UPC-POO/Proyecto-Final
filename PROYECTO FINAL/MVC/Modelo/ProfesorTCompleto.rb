
require_relative './Solicitante'

class ProfesorTCompleto < Solicitante
	attr_reader :sueldoBase, :cantidadAnosAntiguedad
		def initialize(solicitudDeAfiliacion, mesAfiliacion ,tipoPlanEPS, dni, codigoColaborador, nombre, edad, numeroDependientes, codigoSede, descripcionSede, 
				tipoContrato, tipoFondoPension, seguroInvalidez, sueldoBase, cantidadAnosAntiguedad)
			super(solicitudDeAfiliacion, mesAfiliacion ,tipoPlanEPS, dni, codigoColaborador, nombre, edad, numeroDependientes, codigoSede, descripcionSede, 
				tipoContrato, tipoFondoPension, seguroInvalidez)
			@sueldoBase = sueldoBase
			@cantidadAnosAntiguedad = cantidadAnosAntiguedad
		end
	def obtenerDatos
		return super() + [@sueldoBase, @cantidadAnosAntiguedad, generarCodigoAfiliacion(), calcularGratificacion(), calcularPorcentajeFondoPension(), calcularTarifaEPS(), calcularPorcentajeSeguroInvalidez()]
	end
	def calcularGratificacion
  		resultado = super
  		resultado = resultado * sueldoBase
  	end
	def calcularBonoAntiguedad
		if cantidadAnosAntiguedad <= 4
			valor = 0
		elsif cantidadAnosAntiguedad >= 5 && cantidadAnosAntiguedad <= 9
			valor = 1500
		elsif cantidadAnosAntiguedad >= 10 && cantidadAnosAntiguedad <= 14
			valor = 2500
		elsif cantidadAnosAntiguedad >= 15 && cantidadAnosAntiguedad <= 19
			valor = 3500
		else cantidadAnosAntiguedad >= 20
			valor = 4000
		end
		return valor
	end
	def calcularFondoPension
		return calcularPorcentajeFondoPension  * sueldoBase
	end
	def calcularSeguroInvalidez
		return calcularPorcentajeSeguroInvalidez * sueldoBase
	end
	def calcularQuintaCategoria
		uit = 4300
		if sueldoBase >= 2100
			proyeccionAnual = sueldoBase * 14
			rentaNeta = proyeccionAnual - uit*7
			if rentaNeta <=21500
				msg = rentaNeta*0.08
			elsif rentaNeta > 21500 && rentaNeta <= 86000
				cost1 = 21500
				cost2 = rentaNeta - 21500
				resultado1 = cost2*0.14
				resultado2 = 1720
				msg = resultado1 + resultado2
			elsif rentaNeta > 86500 && rentaNeta <= 150000
				cost1 = 21500
				cost2 = rentaNeta - 86000
				resultado1 = 9030
				resultado2 = 1720
				resultado3 = cost2*0.17
				msg = resultado1 + resultado2 + resultado3
			elsif rentaNeta > 150000 && rentaNeta <= 193000
				cost1 = 21500
				cost2 = rentaNeta - 150500
				resultado1 = 9030
				resultado2 = 1720
				resultado3 = 10965
				resultado4 = cost2*0.20
				msg = resultado1 + resultado2 + resultado3 + resultado4
			elsif rentaNeta > 193000
				cost1 = 21500
				cost2 = rentaNeta - 193500
				resultado1 = 9030
				resultado2 = 1720
				resultado3 = 10965
				resultado4 = 8600
				resultado5 = cost2*0.30
				msg = resultado1 + resultado2 + resultado3 + resultado4 + resultado5
			end
		else
			return 0
		end
			return (msg / 12).round(2)
		end
	def calcularDeduccion
 		return (calcularTarifaEPS + calcularSeguroInvalidez + calcularQuintaCategoria + calcularFondoPension).round(2)
	end
	def calcularSueldoFinal
		return (sueldoBase + calcularBonoAntiguedad + calcularGratificacion) - calcularDeduccion
	end
end