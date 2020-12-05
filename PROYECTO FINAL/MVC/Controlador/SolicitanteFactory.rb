
require_relative '../Modelo/Administrativo'
require_relative '../Modelo/ProfesorTCompleto'

class SolicitanteFactory
	def self.crear(tipo, datos)
		if tipo == "Administrativo"
			return Administrativo.new(datos[0], datos[1], datos[2], datos[3], datos[4], datos[5], datos[6], datos[7], datos[8], datos[9], datos[10], datos[11], datos[12], datos[13], datos[14])
		else tipo == "ProfesorTCompleto"
			return	ProfesorTCompleto.new(datos[0], datos[1], datos[2], datos[3], datos[4], datos[5], datos[6], datos[7], datos[8], datos[9], datos[10], datos[11], datos[12], datos[13], datos[14])
		end
	end
end