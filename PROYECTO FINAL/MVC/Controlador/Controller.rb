
require_relative './SolicitanteFactory' 
require_relative '../Vista/vistaEntrada'
require_relative '../Vista/vistaSalida'
require_relative '../Modelo/Universidad'

class Controller

	def initialize(vistaEntrada, vistaSalida, programa)
		@vistaEntrada = vistaEntrada
		@vistaSalida = vistaSalida
		@programa = programa
	end
	def registrarSolicitante(tipo)
		if tipo == "Administrativo"
			datos = @vistaEntrada.mostrarFormularioSolicitanteAdministrativo()
		elsif tipo == "ProfesorTCompleto"
			datos = @vistaEntrada.mostrarFormularioSolicitanteProfesorTCompleto()
		end
		@solicitante = SolicitanteFactory.crear(tipo, datos)
		@programa.registrarSolicitante(solicitante)
	end
	def listarSolicitantes()
		@solicitantes = @universidad.obtenerSolicitantes()
		for @solicitante in @solicitantes
			if @solicitante.is_a? Administrativo
				datos = @solicitante.obtenerDatos()
				@vistaSalida.mostrarDatosSolicitanteAdministrativo(datos)
			elsif @solicitante.is_a? ProfesorTCompleto
				datos = solicitante.obtenerDatos()
				@vistaSalida.mostrarDatosSolicitanteProfesorTCompleto(datos)
			end
			
		end
	end
end