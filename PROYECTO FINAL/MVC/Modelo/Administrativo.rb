
require_relative './Solicitante'

class Administrativo < Solicitante
	attr_reader :cargo, :sueldoBasico
	def initialize(solicitudDeAfiliacion, mesAfiliacion ,tipoPlanEPS, dni, codigoColaborador, nombre, edad, numeroDependientes, codigoSede, descripcionSede, 
				tipoContrato, tipoFondoPension, seguroInvalidez, cargo, sueldoBasico)
		super(solicitudDeAfiliacion, mesAfiliacion ,tipoPlanEPS, dni, codigoColaborador, nombre, edad, numeroDependientes, codigoSede, descripcionSede, 
				tipoContrato, tipoFondoPension, seguroInvalidez)
		@cargo = cargo
		@sueldoBasico = sueldoBasico
	end
	def obtenerDatos
		return super() + [@cargo, @sueldoBasico, generarCodigoAfiliacion(), calcularGratificacion(), calcularPorcentajeFondoPension(), calcularTarifaEPS(), calcularPorcentajeSeguroInvalidez()]
	end
  	def calcularGratificacion
  		resultado = super
  		resultado = resultado * sueldoBasico
  	end
	def calcularBonoEdad
		if edad <= 34
			bono = 0
		elsif edad >= 35 && edad <= 54
			bono = sueldoBasico * 0.15
		else edad >= 55
			bono = sueldoBasico * 0.25
		end
		return bono
	end 
	def calcularFondoPension
		return calcularPorcentajeFondoPension  * sueldoBasico
	end
	def calcularSeguroInvalidez
		return calcularPorcentajeSeguroInvalidez * sueldoBasico
	end
	def calcularQuintaCategoria
		uit = 4300
		if sueldoBasico >= 2100
			proyeccionAnual = sueldoBasico * 14
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
		return (sueldoBasico + calcularBonoEdad + calcularGratificacion) - calcularDeduccion
	end
end