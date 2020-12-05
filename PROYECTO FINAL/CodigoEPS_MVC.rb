require 'Singleton'
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

	def obtenerDatos
		return "CODIGO DE SOLICITUD: #{generarCodigoAfiliacion}"+"\nNombre Completo: #{nombre}  |  DNI: #{dni}  |  Edad: #{edad}       |  Mes Afiliacion: #{mesAfiliacion}  |  Plan EPS: #{tipoPlanEPS}\nCodigo de Usuario: #{codigoColaborador}      |  COD Sede: #{codigoSede}   |  Campus: #{descripcionSede}  |  Contrato: #{tipoContrato}       |  N° de Dependientes: #{numeroDependientes}"
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
		if seguroInvalidez == "si"
			valor =  0.013
		else seguroInvalidez == "no"
			valor = 0
		end
		return valor
	end
end

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
		resultado = super
		resultado = resultado +"\nINGRESOS"+
		"\nSueldo Basico: #{sueldoBasico}    Bono Edad: #{calcularBonoEdad}		Gratifiacion: #{calcularGratificacion}"+
		"\nDEDUCCIONES"+
		"\nSeguro Invalidez: #{calcularSeguroInvalidez}   Monto EPS: #{calcularTarifaEPS}  Fondo Pensiones: #{calcularFondoPension}  |  5TA Categoria: #{calcularQuintaCategoria}" +
		"\nSUELDO NETO: #{calcularSueldoFinal}"
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
		resultado = super
		resultado = resultado +"\nINGRESOS"+
		"\nSueldo Basico: #{sueldoBase}    Bono Antiguedad: #{calcularBonoAntiguedad}	Gratifiacion: #{calcularGratificacion}"+
		"\nDEDUCCIONES"+
		"\nSeguro Invalidez: #{calcularSeguroInvalidez}   Monto EPS: #{calcularTarifaEPS}  Fondo Pensiones: #{calcularFondoPension}  |  5TA Categoria: #{calcularQuintaCategoria}" +
		"\nSUELDO NETO: #{calcularSueldoFinal}"
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

class Universidad ##MODELO
	include Singleton
	attr_reader :arregloSolicitantes

	def initialize
		@arregloSolicitantes = []
	end
	def registrarSolicitante(solicitante)
		arregloSolicitantes.push(solicitante)
	end
	def listarSolicitante
		for solicitante in arregloSolicitantes
			puts solicitante.obtenerDatos
		end
		system('pause')
	end

	def evaluarRegistro
		for solicitante in arregloSolicitantes
			if solicitante.solicitudDeAfiliacion == "si" && solicitante.tipoContrato == "FullTime"
						valor = puts"La solicitud de #{solicitante.nombre} con codigo #{solicitante.generarCodigoAfiliacion} fue APROBADA"
			else solicitante.solicitudDeAfiliacion == "no" 
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

class SolicitanteFactory
	def self.crear(tipo, *arg)
		if tipo == "Administrativo"
			return Administrativo.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14])
		else tipo == "ProfesorTCompleto"
			return	ProfesorTCompleto.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9], arg[10], arg[11], arg[12], arg[13], arg[14])
		end
	end
end


class Vista
	def mostrar(mensaje)
		puts mensaje
	end
	def mostrarExcepcion(mensaje)
		puts mensaje
	end
	def mostrarListado(arreglo)
		puts "----------------------------------------------------- LISTA DE SOLICITANTES --------------------------------------------"
		for solicitante in arreglo
			puts "CODIGO DE SOLICITUD: #{solicitante.generarCodigoAfiliacion}"+"\nNombre Completo: #{solicitante.nombre}  |  DNI: #{solicitante.dni}  |  Edad: #{solicitante.edad}        |  Mes Afiliacion: #{solicitante.mesAfiliacion}  |  Plan EPS: #{solicitante.tipoPlanEPS}\nCodigo de Usuario: #{solicitante.codigoColaborador}      |  COD Sede: #{solicitante.codigoSede}   |  Campus: #{solicitante.descripcionSede}  |  Contrato: #{solicitante.tipoContrato}       |  N° de Dependientes: #{solicitante.numeroDependientes}"+"\nGratifiacion: #{solicitante.calcularGratificacion} Tarifa EPS: #{solicitante.calcularTarifaEPS}"
		puts "--------------------------------------------------------------------------- --------------------------------------------"
		end


	end
	def mostrarEvaluacion(arreglo)
		puts "----------------------------------------------------- REPORTE DE REGISTRO --------------------------------------------"
		for solicitante in arreglo
			if solicitante.solicitudDeAfiliacion == "si" && solicitante.tipoContrato == "FullTime"
						valor = puts"La solicitud de #{solicitante.nombre} con codigo #{solicitante.generarCodigoAfiliacion} fue APROBADA"
			puts "---------------------------------------------------------------------------------------------------------------------------"
			else solicitante.solicitudDeAfiliacion == "no" 
						valor = puts "La solicitud de #{solicitante.nombre} con codigo #{solicitante.generarCodigoAfiliacion} no fue aprobada, debido a que no cumple con los requisitos."
			puts "---------------------------------------------------------------------------------------------------------------------------"
			end
		end
		return valor
	end
	def mostrarAfiliadosDependientes(arreglo)
		puts "----------------------------------------------------- SOLICITANTES CON DEPENDIENTES --------------------------------------------"
		for solicitante in arreglo
			if solicitante.numeroDependientes > 0
				puts solicitante.obtenerDatos
				puts "---------------------------------------------------------------------------------------------------------------------------"
			else
				return nil
			end
		end
	end
	def mostrarListadoAfiliados(arreglo)
		puts
		return puts "La cantidad de afiliados son = #{arreglo.count}"
	end
	def mostrarImporteTotalEPS(arreglo)
		puts "---------------------------------------------- SUMA DE IMPORTES EPS ---------------------------------------------"
		sumaTotal = 0
		for solicitante in arreglo
			sumaTotal = sumaTotal + solicitante.calcularTarifaEPS
		end
			return puts "La suma total del importe de EPS de los colaboradores es: #{sumaTotal}"
	end
	def mostrarAfiliado(solicitante)
		puts "----------------------------------------------------- BUSCAR -----------------------------------------------------"
		if solicitante != nil
			puts "CODIGO DE SOLICITUD: #{solicitante.generarCodigoAfiliacion}"+"\nNombre Completo: #{solicitante.nombre}  |  DNI: #{solicitante.dni}  |  Edad: #{solicitante.edad}        |  Mes Afiliacion: #{solicitante.mesAfiliacion}  |  Plan EPS: #{solicitante.tipoPlanEPS}\nCodigo de Usuario: #{solicitante.codigoColaborador}      |  COD Sede: #{solicitante.codigoSede}   |  Campus: #{solicitante.descripcionSede}  |  Contrato: #{solicitante.tipoContrato}       |  N° de Dependientes: #{solicitante.numeroDependientes}"+"\nGratifiacion: #{solicitante.calcularGratificacion} Tarifa EPS: #{solicitante.calcularTarifaEPS}"
		else
			puts  "Afiliado no encontrado"
		end
	end
	def mostrarSolicitanteMayorSueldo(arreglo)
		puts
		puts "--------------------------- Solicitante Mayor Sueldo ------------------------------"
		mayorSueldo = 0
		solicitanteMayorSuel = nil
		for solicitante in arreglo
			if solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El postulante de Mayor calificacion es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end
	def mostrarSolicitanteMenor(arreglo)
		puts
		puts "--------------------------- Solicitante Menor Sueldo ------------------------------"
		menorSueldo = 999999
		solicitanteMenorSuel = nil

		for solicitante in arreglo
			if solicitante.calcularSueldoFinal < menorSueldo
				menorSueldo = solicitante.calcularSueldoFinal
				solicitanteMenorSuel = solicitante
			end
		end
		return puts "El Solicitante de menor calificacion es: \n#{solicitanteMenorSuel.obtenerDatos}"
	end
	def mostrarAdministrativoMayor(arreglo)
		puts
		puts "--------------------------- Administrativo Mayor Sueldo ------------------------------"
		mayorSueldo = 0
		solicitanteMayorSuel = nil

		for solicitante in arreglo
			if (solicitante.is_a? Administrativo) && solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El Administrativo de Mayor Sueldo es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end
	def mostrarProfesorMayor(arreglo)
		puts
		puts "--------------------------- Profesor Mayor Sueldo ------------------------------"
		mayorSueldo = 0
		solicitanteMayorSuel = nil
		for solicitante in arreglo
			if (solicitante.is_a? ProfesorTCompleto) && solicitante.calcularSueldoFinal > mayorSueldo
				mayorSueldo = solicitante.calcularSueldoFinal
				solicitanteMayorSuel = solicitante
			end
		end
		return puts "El Profesor de Mayor Sueldo es: \n#{solicitanteMayorSuel.obtenerDatos}"
	end
end

class Controlador
	attr_reader :vista, :modelo
	def initialize(vista, modelo)
		@vista = vista
		@modelo = modelo
	end

	def registrar(tipo, *arg)
		solicitante = SolicitanteFactory.crear(tipo, *arg)
		begin
			modelo.registrarSolicitante(solicitante)
			vista.mostrar("La Solicitud de #{solicitante.nombre} con codigo de solicitud #{solicitante.generarCodigoAfiliacion} fue registrado con exito. ")
		rescue Exception => e
			vista.mostrarExcepcion(e.message)
		end
	end
	def listarSolicitante
		arreglo = modelo.arregloSolicitantes
		vista.mostrarListado(arreglo)
	end
	def evaluarRegistro
		solicitante = modelo.arregloSolicitantes
		vista.mostrarEvaluacion(solicitante)
	end
	def listarAfiliadosconDependientes
		solicitante = modelo.arregloSolicitantes
		vista.mostrarAfiliadosDependientes(solicitante)
	end
	def listarCantidadAfiliados
		solicitante = modelo.arregloSolicitantes
		vista.mostrarListadoAfiliados(solicitante)
	end
	def calcularImporteTotalEPS
		solicitante = modelo.arregloSolicitantes
		vista.mostrarImporteTotalEPS(solicitante)
	end
	def buscarAfiliado(dni)
		solicitante = modelo.buscarAfiliadoPorDNI(dni)
		vista.mostrarAfiliado(solicitante)
	end
	def obtenerSolicitanteMayor
		solicitante = modelo.arregloSolicitantes
		vista.mostrarSolicitanteMayorSueldo(solicitante)
	end
	def obtenerSolicitanteMenorSueldo
		solicitante = modelo.arregloSolicitantes
		vista.mostrarSolicitanteMenor(solicitante)
	end
	def obtenerAdministrativoMayorSueldo
		solicitante = modelo.arregloSolicitantes
		vista.mostrarAdministrativoMayor(solicitante)
	end
	def obtenerProfesorMayorSueldo
		solicitante = modelo.arregloSolicitantes
		vista.mostrarProfesorMayor(solicitante)
	end
end



vista = Vista.new
univ = Universidad.instance
controlador = Controlador.new(vista, univ)
controlador.registrar("Administrativo","no", "Febrero", "Plan Base", "74585490", "BMENDOZA", "Brayan Mendoza", 36, 3, "SM", "San Miguel", "FullTime","AFP", "si", "Analista", 2800)
controlador.registrar("Administrativo","si", "Febrero", "Plan Base", "98626526", "MSANTOS", "Mario Santos", 37, 1, "SM", "San Miguel", "FullTime","AFP", "no", "Supervisor", 3000)
controlador.registrar("Administrativo","si", "Agosto", "Plan Base", "74585490", "MCASTANEDA", "Martin Castaneda", 38, 2, "SM", "San Miguel", "FullTime","AFP", "si", "Gerente", 4000)
controlador.registrar("Administrativo","si", "Febrero", "Adicional 2", "75516814", "BMYERS", "Bryan Myers", 40, 3, "MO", "Monterrico", "FullTime","AFP", "si", "Supervisor", 3000)
controlador.registrar("Administrativo","si", "Diciembre", "Plan Base", "74895235", "ZLOPEZ", "Zara Lopez", 37, 1, "SM", "San Miguel", "FullTime","AFP", "si", "Director", 5000)
controlador.registrar("Administrativo","si", "Febrero", "Adicional 2", "98626525", "PVIDAL", "Paul Vidal", 35, 2, "SM", "San Miguel", "FullTime","AFP", "si", "Coordinador", 4000)
controlador.registrar("ProfesorTCompleto","si", "Julio", "Adicional 1","70936667", "FBELLO", "Francisco Bello", 23, 1, "MO", "Monterrico", "FullTime","ONP", "si", 3100, 5)
controlador.registrar("ProfesorTCompleto","si", "Julio", "Adicional 1","70936667", "JAGUIRRE", "Juan Aguirre", 24, 1, "MO", "Monterrico", "FullTime","ONP", "si", 3500, 7)
controlador.registrar("ProfesorTCompleto","si", "Diciembre", "Adicional 2","87481118", "JPEREZ", "Juan Perez", 26, 1, "MO", "Monterrico", "FullTime","AFP", "si", 3000, 15)
controlador.registrar("ProfesorTCompleto","si", "Febrero", "Adicional 2","86565605", "BZABALAGA", "Brandon Zavalaga", 28, 1, "SV", "Villa", "PartTime","ONP", "si", 4100, 5)
controlador.registrar("ProfesorTCompleto","si", "Agosto", "Adicional 3","715645254", "JJHONSON", "Jack Jhonson", 23, 2, "MO", "Monterrico", "FullTime","AFP", "si", 3300, 4)
controlador.registrar("ProfesorTCompleto","si", "Noviembre", "Adicional 1","68465355", "KPEREZ", "Katy Perez", 25, 3, "SV", "Villa", "PartTime","AFP", "si", 5200, 2)
controlador.listarSolicitante
controlador.evaluarRegistro
controlador.listarAfiliadosconDependientes
controlador.listarCantidadAfiliados
controlador.calcularImporteTotalEPS
controlador.buscarAfiliado("74585490")
controlador.obtenerSolicitanteMayor
controlador.obtenerSolicitanteMenorSueldo
controlador.obtenerAdministrativoMayorSueldo
controlador.obtenerProfesorMayorSueldo