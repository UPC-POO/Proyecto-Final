class Solicitante
	attr_reader :solicitudDeAfiliacion, :mesAfiliacion ,:tipoPlanEPS, :dni, :codigoColaborador, :nombre, :edad, :numeroDependientes, :codigoSede, :descripcionSede, 
				:tipoContrato, :tipoFondoPension, :seguroInvalidez

	def initialize(solicitudDeAfiliacion, mesAfiliacion ,tipoPlanEPS, dni, codigoColaborador, nombre, edad, numeroDependientes, codigoSede, descripcionSede, 
				tipoContrato, tipoFondoPension, seguroInvalidez)

		@solicitudDeAfiliacion = solicitudDeAfiliacion
		@mesAfiliacion = mesAfiliacion
		@tipoPlanEPS = tipoPlanEPS
		@dni	= dni	
		@codigoColaborador = codigoColaborador
		@nombre = nombre
		@edad = edad
		@numeroDependientes = numeroDependientes
		@codigoSede = codigoSede
		@descripcionSede = descripcionSede
		@tipoContrato = tipoContrato
		@tipoFondoPension = tipoFondoPension
		@seguroInvalidez = seguroInvalidez
	end

	def obtenerDatos()
		return [@solicitudDeAfiliacion, @mesAfiliacion, @tipoPlanEPS, @dni, @codigoColaborador, @nombre, @edad, @numeroDependientes, @codigoSede, @descripcionSede, @tipoContrato, @tipoFondoPension, @seguroInvalidez]
	end

	def generarCodigoAfiliacion
		return "SOL#{dni}#{codigoSede}"
	end


	def calcularGratificacion #mesAfiliacion
		if mesAfiliacion == "Julio" or mesAfiliacion == "Diciembre"
			return 1
		else
			return 0
		end

	end
	# DEDUCCIONES
	def calcularPorcentajeFondoPension
		if tipoFondoPension == "AFP"
			valor = 0.10
		else tipoFondoPension == "ONP"
			valor = 0.13
		end

		return valor
	end
	def calcularTarifaEPS
		if tipoPlanEPS == "Plan Base"
			if numeroDependientes == 0
				valor = 31
			elsif numeroDependientes == 1
				valor = 62
			elsif numeroDependientes == 2
				valor = 93
			elsif numeroDependientes >= 3
				valor = 124
			end
		elsif tipoPlanEPS == "Adicional 1"
			if numeroDependientes == 0
				valor = 51
			elsif numeroDependientes == 1
				valor = 102
			elsif numeroDependientes == 2
				valor = 153
			elsif numeroDependientes >= 3
				valor = 204
			end
		else tipoPlanEPS == "Adicional 2"
			if numeroDependientes == 0
				valor = 71
			elsif numeroDependientes == 1
				valor = 142
			elsif numeroDependientes == 2
				valor = 213
			elsif numeroDependientes >= 3
				valor = 284
			end
		end
		return valor*1.0
	end
	def calcularPorcentajeSeguroInvalidez
		if seguroInvalidez == true
			valor =  0.013
		else seguroInvalidez == false
			valor = 0
		end
		return valor
	end
end

