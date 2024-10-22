--****************LENGUAJE DE DEFINICION DE DATOS******************
--****************CREACION DE TABLAS******************
-- Tabla OFICINAS
CREATE TABLE OFICINAS (
    CodigoOficina SERIAL PRIMARY KEY,
    DireccionCalle VARCHAR(50) NOT NULL,
    DireccionNumero VARCHAR(10) NOT NULL,
    DireccionCiudad VARCHAR(50) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    NumFax VARCHAR(15) NOT NULL
);

-- Tabla EMPLEADOS
CREATE TABLE EMPLEADOS (
    CodigoEmpleado SERIAL PRIMARY KEY,
    DNI VARCHAR(15) NOT NULL,
    Nombre VARCHAR(70) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    ParienteNombre VARCHAR(70) NOT NULL,
    ParienteRelacion VARCHAR(50) NOT NULL,
    ParienteDireccion VARCHAR(100) NOT NULL,
    ParienteNumTelefono VARCHAR(15) NOT NULL,
    SalarioAnual DECIMAL(10, 2) NOT NULL CHECK (SalarioAnual > 0),
    FechaIngreso DATE NOT NULL,
    Cargo VARCHAR(50) NOT NULL CHECK (Cargo IN ('Supervisor', 'Administrador', 'Director', 'Otro')),
    CodigoOficina INTEGER NOT NULL,
    FOREIGN KEY (CodigoOficina) REFERENCES OFICINAS (CodigoOficina) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla SUPERVISORES
CREATE TABLE SUPERVISORES (
    CodigoEmpleado INTEGER PRIMARY KEY,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS (CodigoEmpleado) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 3. Modificar la tabla EMPLEADOS para agregar la clave foránea a SUPERVISORES
ALTER TABLE EMPLEADOS
ADD COLUMN CodigoSupervisor INTEGER NULL,
ADD CONSTRAINT fk_CodigoSupervisor
    FOREIGN KEY (CodigoSupervisor) REFERENCES SUPERVISORES (CodigoEmpleado)
    DEFERRABLE INITIALLY DEFERRED;

-- Tabla ADMINISTRADORES
CREATE TABLE ADMINISTRADORES (
    CodigoEmpleado INTEGER PRIMARY KEY,
    VelocidadEscritura INTEGER NOT NULL CHECK (VelocidadEscritura > 0),
    CodigoSupervisor INTEGER NOT NULL,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS (CodigoEmpleado) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CodigoSupervisor) REFERENCES SUPERVISORES (CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla DIRECTORES
CREATE TABLE DIRECTORES (
    CodigoEmpleado INTEGER PRIMARY KEY,
    FechaInicio DATE NOT NULL,
    MontoPagoAnual DECIMAL(10, 2) NOT NULL CHECK (MontoPagoAnual > 0),
    BonificacionAnual DECIMAL(10, 2) NOT NULL CHECK (BonificacionAnual > 0),
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS (CodigoEmpleado) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla PROPIETARIOS
CREATE TABLE PROPIETARIOS (
    CodigoPropietario SERIAL PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Direccion VARCHAR(70) NOT NULL,
    NumTelefono VARCHAR(8) NOT NULL,
    TipoPropietario VARCHAR(20) NOT NULL CHECK (TipoPropietario IN ('Particular', 'Empresa')),
    TipoEmpresa VARCHAR(50),
    NombrePersonaContacto VARCHAR(50),
    CONSTRAINT check_tipo_propietario CHECK (
        (TipoPropietario = 'Particular' AND TipoEmpresa IS NULL AND NombrePersonaContacto IS NULL) OR
        (TipoPropietario <> 'Particular')
    )
);

-- Tabla INMUEBLES
CREATE TABLE INMUEBLES (
    CodigoInmueble SERIAL PRIMARY KEY,
    DireccionCalle VARCHAR(50) NOT NULL,
    DireccionNumero VARCHAR(10) NOT NULL,
    DireccionCiudad VARCHAR(50) NOT NULL,
    TipoInmueble VARCHAR(50) NOT NULL,
    NumHabitaciones INTEGER NOT NULL CHECK (NumHabitaciones > 0),
    Descripcion VARCHAR(120) NOT NULL,
    PrecioAlquilerEuros DECIMAL(10, 2) CHECK (PrecioAlquilerEuros > 0),
    PrecioVenta DECIMAL(10, 2) NOT NULL CHECK (PrecioVenta > 0),
    CodigoPropietario INTEGER NOT NULL,
    CodigoEmpleado INTEGER NOT NULL,
    FOREIGN KEY (CodigoPropietario) REFERENCES PROPIETARIOS (CodigoPropietario) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS (CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE INMUEBLESAUDITABLE (
    Codigo SERIAL PRIMARY KEY, 
    FechaEliminacion DATE NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    DireccionCalle VARCHAR(50) NOT NULL,
    DireccionNumero VARCHAR(10) NOT NULL,
    DireccionCiudad VARCHAR(50) NOT NULL,
    TipoInmueble VARCHAR(50) NOT NULL,
    NumHabitaciones INTEGER NOT NULL CHECK (NumHabitaciones > 0),  -- Restricción de número de habitaciones
    Descripcion VARCHAR(120) NOT NULL,
    PrecioAlquilerEuros DECIMAL(10,2) CHECK (PrecioAlquilerEuros > 0),  -- Restricción de alquiler si existe
    PrecioVenta DECIMAL(10,2) NOT NULL CHECK (PrecioVenta > 0),  -- Restricción de venta
    CodigoPropietario INTEGER NOT NULL,
    CodigoEmpleado INTEGER NOT NULL
);

-- Tabla CLIENTES
CREATE TABLE CLIENTES (
    CodigoCliente SERIAL PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    TipoInmueble VARCHAR(50) NOT NULL,
    ImporteMax DECIMAL(10, 2) NOT NULL CHECK (ImporteMax > 0),
    CodigoEmpleado INTEGER NOT NULL,
    FechaEntrevistaInicial DATE NOT NULL,
    ComentariosEntrevista VARCHAR(100) NOT NULL,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS (CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla PERIODICOS
CREATE TABLE PERIODICOS (
    NombrePeriodico Varchar(70) PRIMARY KEY,
    Direccion VARCHAR(100) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    NombrePersonaContacto VARCHAR(50) NOT NULL,
    NumFax VARCHAR(25) NOT NULL
);

CREATE TABLE CONTRATOS (
    NumeroContrato SERIAL PRIMARY KEY,
    EstadoDeposito BOOLEAN NOT NULL,
    ImporteMensual DECIMAL(10,2) CHECK(ImporteMensual > 0) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFinalizacion DATE CHECK(FechaFinalizacion > FechaInicio) NOT NULL,
    DuracionMeses INT CHECK(DuracionMeses BETWEEN 3 AND 12) NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    ImporteDeposito DECIMAL(10,2) CHECK(ImporteDeposito > 0),
    TipoContrato VARCHAR(20) CHECK(TipoContrato IN ('Alquiler', 'Venta')) NOT NULL,
    CodigoCliente INT NOT NULL,
    CodigoEmpleado INT NOT NULL,
    FOREIGN KEY (CodigoCliente) REFERENCES CLIENTES(CodigoCliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS(CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE FACTURAS (
    NumeroFactura SERIAL PRIMARY KEY,
    EstadoDeposito BOOLEAN NOT NULL,
    ImporteMensual DECIMAL(10,2) CHECK(ImporteMensual > 0) NOT NULL,
    PlazoPagoDias INT CHECK(PlazoPagoDias > 0) NOT NULL,
    Observaciones VARCHAR(100) NOT NULL,
    ImporteTotal DECIMAL(10,2) CHECK(ImporteTotal > 0) NOT NULL,
    CodigoCliente INT NOT NULL,
    FOREIGN KEY (CodigoCliente) REFERENCES CLIENTES(CodigoCliente) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Tabla RECIBOS
CREATE TABLE RECIBOS (
    NumeroRecibo SERIAL PRIMARY KEY,
    Importe DECIMAL(10,2) NOT NULL CHECK(Importe > 0),
    FechaPago DATE NOT NULL,
    NumeroFactura INT NOT NULL,
    FOREIGN KEY (NumeroFactura) REFERENCES FACTURAS(NumeroFactura) ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Tabla CONTIENEN
CREATE TABLE CONTIENEN (
    NumeroContrato INTEGER NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    PRIMARY KEY (NumeroContrato, CodigoInmueble),
    FOREIGN KEY (NumeroContrato) REFERENCES CONTRATOS(NumeroContrato) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla ANUNCIAN
CREATE TABLE ANUNCIAN (
    NombrePeriodico VARCHAR(70) NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    FechaPublicacion DATE NOT NULL,
    Comentarios VARCHAR(100) NOT NULL,
    PRIMARY KEY (NombrePeriodico, CodigoInmueble, FechaPublicacion),
    FOREIGN KEY (NombrePeriodico) REFERENCES PERIODICOS(NombrePeriodico) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla VISITAN
CREATE TABLE VISITAN (
    CodigoCliente INTEGER NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    FechaVisita DATE NOT NULL,
    Comentarios VARCHAR(100) NOT NULL,
    PRIMARY KEY (CodigoCliente, CodigoInmueble, FechaVisita),
    FOREIGN KEY (CodigoCliente) REFERENCES CLIENTES(CodigoCliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla INSPECCIONAN
CREATE TABLE INSPECCIONAN (
    CodigoEmpleado INTEGER NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    FechaInspeccion DATE NOT NULL,
    Comentarios VARCHAR(100) NOT NULL,
    PRIMARY KEY (CodigoEmpleado, CodigoInmueble, FechaInspeccion),
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS(CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla GALERIAIMAGENESINMUEBLE
CREATE TABLE GALERIAIMAGENESINMUEBLE (
    CodigoInmueble INTEGER NOT NULL,
    Imagen VARCHAR(200) NOT NULL,
    PRIMARY KEY (CodigoInmueble, Imagen),
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE INCLUYEN (
    NumeroFactura INT NOT NULL,
    CodigoInmueble INT NOT NULL,
    PRIMARY KEY (NumeroFactura, CodigoInmueble),
    FOREIGN KEY (NumeroFactura) REFERENCES FACTURAS(NumeroFactura) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) 
    ON UPDATE CASCADE ON DELETE CASCADE
);

--****************TRIGGERS******************
--Jerarquia exclusiva contratos
CREATE OR REPLACE FUNCTION validar_insertar_alquiler()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el contrato es de tipo 'Alquiler'
    IF NOT EXISTS (
        SELECT 1 
        FROM CONTRATOS 
        WHERE NumeroContrato = NEW.CodigoContrato 
        AND TipoContrato = 'Alquiler'
    ) THEN
        RAISE EXCEPTION 'El contrato no es de tipo Alquiler. No se puede insertar en la tabla ALQUILERES.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_insertar_alquiler
BEFORE INSERT ON ALQUILERES
FOR EACH ROW
EXECUTE FUNCTION validar_insertar_alquiler();

--jerarquia exclusiva contratos
CREATE OR REPLACE FUNCTION validar_insertar_venta()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el contrato es de tipo 'Venta'
    IF NOT EXISTS (
        SELECT 1 
        FROM CONTRATOS 
        WHERE NumeroContrato = NEW.CodigoContrato 
        AND TipoContrato = 'Venta'
    ) THEN
        RAISE EXCEPTION 'El contrato no es de tipo Venta. No se puede insertar en la tabla VENTAS.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_insertar_venta
BEFORE INSERT ON VENTAS
FOR EACH ROW
EXECUTE FUNCTION validar_insertar_venta();

--cada oficina solo tiene un director.
CREATE OR REPLACE FUNCTION validar_director_unico()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DIRECTORES d
        JOIN EMPLEADOS e ON d.CodigoEmpleado = e.CodigoEmpleado
        WHERE e.CodigoOficina = (SELECT CodigoOficina FROM EMPLEADOS WHERE CodigoEmpleado = NEW.CodigoEmpleado) 
        AND d.FechaInicio = NEW.FechaInicio
    ) THEN
        RAISE EXCEPTION 'Ya existe un director con esa fecha de inicio en la misma oficina';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_director_unico
BEFORE INSERT ON DIRECTORES
FOR EACH ROW
EXECUTE FUNCTION validar_director_unico();



--Si se borra un inmueble del sistema, se debe mantener su información 
CREATE OR REPLACE FUNCTION auditar_inmueble_eliminado()
RETURNS TRIGGER AS $$
BEGIN
    -- Insertamos los datos del inmueble eliminado en la tabla INMUEBLESAUDITABLE
    INSERT INTO INMUEBLESAUDITABLE (
        Codigo, 
        FechaEliminacion, 
        CodigoInmueble, 
        DireccionCalle, 
        DireccionNumero, 
        DireccionCiudad, 
        TipoInmueble, 
        NumHabitaciones, 
        Descripcion, 
        PrecioAlquilerEuros, 
        PrecioVenta, 
        CodigoPropietario, 
        CodigoEmpleado
    )
    -- Seleccionamos los valores del inmueble que va a ser eliminado
    SELECT OLD.CodigoInmueble, 
           CURRENT_DATE, 
           OLD.CodigoInmueble, 
           OLD.DireccionCalle, 
           OLD.DireccionNumero, 
           OLD.DireccionCiudad, 
           OLD.TipoInmueble, 
           OLD.NumHabitaciones, 
           OLD.Descripcion, 
           OLD.PrecioAlquilerEuros, 
           OLD.PrecioVenta, 
           OLD.CodigoPropietario, 
           OLD.CodigoEmpleado;
           
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creamos el trigger que se ejecuta después de borrar un inmueble
CREATE TRIGGER trigger_auditar_inmueble
AFTER DELETE ON INMUEBLES
FOR EACH ROW
EXECUTE FUNCTION auditar_inmueble_eliminado();

--No se puede alquilar un inmueble que ya esta alquilado
CREATE OR REPLACE FUNCTION validar_fecha_contrato_alquiler()
RETURNS TRIGGER AS $$
DECLARE
    tipo_contrato VARCHAR(20);
    fecha_inicio DATE;
    fecha_finalizacion DATE;
BEGIN
    -- Obtener el tipo de contrato
    SELECT TipoContrato INTO tipo_contrato
    FROM CONTRATOS
    WHERE NumeroContrato = NEW.NumeroContrato;

    -- Si es venta, no hacemos nada
    IF tipo_contrato = 'Venta' THEN
        RETURN NEW;
    END IF;

    -- Si es alquiler, obtenemos la fecha de inicio
    SELECT FechaInicio INTO fecha_inicio
    FROM ALQUILERES
    WHERE CodigoContrato = NEW.NumeroContrato;

    -- Buscar en CONTIENEN el último contrato para el inmueble
    SELECT a.FechaFinalizacion INTO fecha_finalizacion
    FROM CONTIENEN c
    JOIN ALQUILERES a ON c.NumeroContrato = a.CodigoContrato
    WHERE c.CodigoInmueble = NEW.CodigoInmueble
    ORDER BY c.NumeroContrato DESC
    LIMIT 1;

    -- Comprobar si la fecha de finalización existe y si la fecha de inicio es válida
    IF fecha_finalizacion IS NOT NULL AND fecha_finalizacion > fecha_inicio THEN
        RAISE EXCEPTION 'No se puede alquilar un inmueble que ya está alquilado. Fecha de finalización: %', fecha_finalizacion;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_fecha_contrato_alquiler
BEFORE INSERT ON CONTIENEN
FOR EACH ROW
EXECUTE FUNCTION validar_fecha_contrato_alquiler();

--Después de la venta de un inmueble, el cliente pasa a ser el propietario. 
CREATE OR REPLACE FUNCTION actualizar_propietario_despues_de_venta()
RETURNS TRIGGER AS $$
DECLARE
    codigo_cliente INTEGER;
    nuevo_nombre VARCHAR(50);
    nueva_direccion VARCHAR(70);
    nuevo_num_telefono VARCHAR(8);
    nuevo_tipo_propietario VARCHAR(20) := 'Particular'; -- Cambia a 'Particular'
    nuevo_tipo_empresa VARCHAR(50) := NULL; -- Asegúrate de que sea NULL
    nuevo_nombre_persona_contacto VARCHAR(50);
BEGIN
    -- Obtener el Código del Cliente del contrato
    SELECT CodigoCliente
    INTO codigo_cliente
    FROM CONTRATOS
    WHERE NumeroContrato = NEW.NumeroContrato; -- Cambia a NEW.NumeroContrato

    -- Obtener los atributos del nuevo propietario desde la tabla CLIENTES
    SELECT Nombre, Direccion, NumTelefono
    INTO nuevo_nombre, nueva_direccion, nuevo_num_telefono
    FROM CLIENTES
    WHERE CodigoCliente = codigo_cliente;

    -- Iterar sobre cada inmueble asociado al contrato y actualizar el propietario
    UPDATE PROPIETARIOS
    SET 
        Nombre = nuevo_nombre,
        Direccion = nueva_direccion,
        NumTelefono = nuevo_num_telefono,
        TipoPropietario = nuevo_tipo_propietario,
        TipoEmpresa = nuevo_tipo_empresa,
        NombrePersonaContacto = nuevo_nombre_persona_contacto
    WHERE CodigoPropietario IN (
        SELECT CodigoPropietario 
        FROM INMUEBLES 
        WHERE CodigoInmueble IN (
            SELECT CodigoInmueble 
            FROM CONTIENEN 
            WHERE NumeroContrato = NEW.NumeroContrato -- Cambia a NEW.NumeroContrato
        )
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_propietario
AFTER INSERT ON CONTIENEN -- Cambia el evento a CONTIENEN
FOR EACH ROW
EXECUTE FUNCTION actualizar_propietario_despues_de_venta();


-- Cada miembro de la plantilla puede tener asignados hasta veinte inmuebles para alquilar.
CREATE OR REPLACE FUNCTION validar_inmuebles_empleado()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM INMUEBLES WHERE CodigoEmpleado = NEW.CodigoEmpleado) > 20 THEN
        RAISE EXCEPTION 'Este empleado ya tiene 20 inmuebles asignados para alquilar';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_inmuebles_empleado
BEFORE INSERT ON INMUEBLES
FOR EACH ROW
EXECUTE FUNCTION validar_inmuebles_empleado();

--Cada supervisor del trabajo diario de un grupo de entre cinco y diez empleados
CREATE OR REPLACE FUNCTION validar_empleados_por_supervisor()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM EMPLEADOS WHERE CodigoSupervisor = NEW.CodigoSupervisor) >10 THEN
        RAISE EXCEPTION 'Cada supervisor debe tener entre 5 y 10 empleados asignados';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validar_empleados_supervisor
BEFORE INSERT ON EMPLEADOS
FOR EACH ROW
EXECUTE FUNCTION validar_empleados_por_supervisor();

--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_administrador()
RETURNS TRIGGER AS $$
DECLARE
    tipo_empleado VARCHAR(50);
BEGIN
    -- Verificar si el empleado existe y obtener su tipo
    SELECT Cargo INTO tipo_empleado
    FROM EMPLEADOS
    WHERE CodigoEmpleado = NEW.CodigoEmpleado;

    -- Si no existe, lanzar excepción
    IF tipo_empleado IS NULL THEN
        RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla ADMINISTRADORES.';
    END IF;

    -- Verificar si el tipo de empleado es 'Administrador'
    IF tipo_empleado <> 'Administrador' THEN
        RAISE EXCEPTION 'El empleado no es un Administrador. No se puede insertar en la tabla ADMINISTRADORES.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_insertar_administrador
BEFORE INSERT ON ADMINISTRADORES
FOR EACH ROW
EXECUTE FUNCTION validar_insertar_administrador();

--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_director()
RETURNS TRIGGER AS $$
DECLARE
    tipo_empleado VARCHAR(50);
BEGIN
    -- Verificar si el empleado existe y obtener su tipo
    SELECT Cargo INTO tipo_empleado
    FROM EMPLEADOS
    WHERE CodigoEmpleado = NEW.CodigoEmpleado;

    -- Si no existe, lanzar excepción
    IF tipo_empleado IS NULL THEN
        RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla DIRECTORES.';
    END IF;

    -- Verificar si el tipo de empleado es 'Director'
    IF tipo_empleado <> 'Director' THEN
        RAISE EXCEPTION 'El empleado no es un Director. No se puede insertar en la tabla DIRECTORES.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_insertar_director
BEFORE INSERT ON DIRECTORES
FOR EACH ROW
EXECUTE FUNCTION validar_insertar_director();

--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_supervisor()
RETURNS TRIGGER AS $$
DECLARE
    tipo_empleado VARCHAR(50);
BEGIN
    -- Verificar si el empleado existe y obtener su tipo
    SELECT Cargo INTO tipo_empleado
    FROM EMPLEADOS
    WHERE CodigoEmpleado = NEW.CodigoEmpleado;

    -- Si no existe, lanzar excepción
    IF tipo_empleado IS NULL THEN
        RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla SUPERVISORES.';
    END IF;

    -- Verificar si el tipo de empleado es 'Supervisor'
    IF tipo_empleado <> 'Supervisor' THEN
        RAISE EXCEPTION 'El empleado no es un Supervisor. No se puede insertar en la tabla SUPERVISORES.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_insertar_supervisor
BEFORE INSERT ON SUPERVISORES
FOR EACH ROW
EXECUTE FUNCTION validar_insertar_supervisor();
