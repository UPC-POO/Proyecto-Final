require 'Singleton'

class VistaSalida
	include Singleton

	def mostrarDatosSolicitanteAdministrativo(datos)
		puts "Solic. de Afiliac.: #{datos[0]}"
		puts "Mes Afiliac.: #{datos[1]}"
		puts "Tipo Plan EPS: #{datos[2]}"
		puts "DNI: #{datos[3]}"
		puts "Codigo Colab.: #{datos[4]}"
		puts "Nombre: #{datos[5]}"
		puts "Edad: #{datos[6]}"
		puts "Numero Depend.: #{datos[7]}"
		puts "Codig Sede: #{datos[8]}"
		puts "Descripcion Sede: #{datos[9]}"
		puts "Tipo Contrato: #{datos[10]}"
		puts "Tipo pensión: #{datos[11]}"
		puts "Seguro invalidez: #{datos[12]}"
		puts "Cargo: #{datos [13]}"
		puts "Sueldo Básico: #{datos[14]}"
		puts "Cod. Afiliacion: #{datos[15]}"
		puts "Gratificacion: #{datos[16]}"
		puts "Porcentaje Fondo Pension: #{datos[17]}"
		puts "Tarifa EPS: #{datos[18]}"
		puts "Porcentaje Seguro Invalidez: #{datos[19]}"
	end
	def mostrarDatosSolicitanteProfesorTCompleto(datos)
		puts "Solic. de Afiliac.: #{datos[0]}"
		puts "Mes Afiliac.: #{datos[1]}"
		puts "Tipo Plan EPS: #{datos[2]}"
		puts "DNI: #{datos[3]}"
		puts "Codigo Colab.: #{datos[4]}"
		puts "Nombre: #{datos[5]}"
		puts "Edad: #{datos[6]}"
		puts "Numero Depend.: #{datos[7]}"
		puts "Codig Sede: #{datos[8]}"
		puts "Descripcion Sede: #{datos[9]}"
		puts "Tipo Contrato: #{datos[10]}"
		puts "Tipo pensión: #{datos[11]}"
		puts "Seguro invalidez: #{datos[12]}"
		puts "Sueldo Base: #{datos[13]}"
		puts "Cantidad Antiguedad: #{datos[14]}"
		puts "Cod. Afiliacion: #{datos[15]}"
		puts "Gratificacion: #{datos[16]}"
		puts "Porcentaje Fondo Pension: #{datos[17]}"
		puts "Tarifa EPS: #{datos[18]}"
		puts "Porcentaje Seguro Invalidez: #{datos[19]}"
	end
end