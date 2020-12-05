require_relative './Modelo/Universidad'
require_relative './Vista/VistaEntrada'
require_relative './Vista/VistaSalida'
require_relative './Controlador/Controller'



vistaEntrada = VistaEntrada.new()
vistaSalida = VistaSalida.instance
universidad = Universidad.new()
controlador = Controller.new(vistaEntrada, vistaSalida, universidad)

controlador.registrarSolicitante("Administrativo")
controlador.registrarSolicitante("ProfesorTCompleto")


controlador.listarSolicitantes()
