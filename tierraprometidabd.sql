--****************LENGUAJE DE DEFINICION DE DATOS******************
--****************CREACION DE TABLAS******************
-- Tabla OFICINAS
CREATE TABLE OFICINAS (
    CodigoOficina INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    DireccionCalle VARCHAR(50) NOT NULL,
    DireccionNumero VARCHAR(10) NOT NULL,
    DireccionCiudad VARCHAR(50) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    NumFax VARCHAR(15) NOT NULL
);
-- Tabla EMPLEADOS
CREATE TABLE EMPLEADOS (
    CodigoEmpleado INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
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
    Cargo VARCHAR(50) NOT NULL CHECK (
        Cargo IN (
            'Supervisor',
            'Administrador',
            'Director',
            'Otro'
        )
    ),
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
    ADD CONSTRAINT fk_CodigoSupervisor FOREIGN KEY (CodigoSupervisor) REFERENCES SUPERVISORES (CodigoEmpleado) DEFERRABLE INITIALLY DEFERRED;
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
    CodigoPropietario INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Direccion VARCHAR(70) NOT NULL,
    NumTelefono VARCHAR(15) NOT NULL,
    TipoPropietario VARCHAR(20) NOT NULL CHECK (TipoPropietario IN ('Particular', 'Empresa')),
    TipoEmpresa VARCHAR(50),
    NombrePersonaContacto VARCHAR(50),
    CONSTRAINT check_tipo_propietario CHECK (
        (
            TipoPropietario = 'Particular'
            AND TipoEmpresa IS NULL
            AND NombrePersonaContacto IS NULL
        )
        OR (TipoPropietario <> 'Particular')
    )
);
-- Tabla INMUEBLES
CREATE TABLE INMUEBLES (
    CodigoInmueble INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
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
    Codigo INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    FechaEliminacion DATE NOT NULL,
    CodigoInmueble INTEGER NOT NULL,
    DireccionCalle VARCHAR(50) NOT NULL,
    DireccionNumero VARCHAR(10) NOT NULL,
    DireccionCiudad VARCHAR(50) NOT NULL,
    TipoInmueble VARCHAR(50) NOT NULL,
    NumHabitaciones INTEGER NOT NULL CHECK (NumHabitaciones > 0),
    -- Restricción de número de habitaciones
    Descripcion VARCHAR(120) NOT NULL,
    PrecioAlquilerEuros DECIMAL(10, 2) CHECK (PrecioAlquilerEuros > 0),
    -- Restricción de alquiler si existe
    PrecioVenta DECIMAL(10, 2) NOT NULL CHECK (PrecioVenta > 0),
    -- Restricción de venta
    CodigoPropietario INTEGER NOT NULL,
    CodigoEmpleado INTEGER NOT NULL
);
-- Tabla CLIENTES
CREATE TABLE CLIENTES (
    CodigoCliente INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
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
    NumeroContrato INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    EstadoDeposito BOOLEAN NOT NULL,
    ImporteMensual DECIMAL(10, 2) CHECK(ImporteMensual > 0) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFinalizacion DATE CHECK(FechaFinalizacion > FechaInicio) NOT NULL,
    DuracionMeses INT CHECK(
        DuracionMeses BETWEEN 3 AND 12
    ) NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    ImporteDeposito DECIMAL(10, 2) CHECK(ImporteDeposito > 0),
    TipoContrato VARCHAR(20) CHECK(TipoContrato IN ('Alquiler', 'Venta')) NOT NULL,
    CodigoCliente INT NOT NULL,
    CodigoEmpleado INT NOT NULL,
    FOREIGN KEY (CodigoCliente) REFERENCES CLIENTES(CodigoCliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoEmpleado) REFERENCES EMPLEADOS(CodigoEmpleado) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE FACTURAS (
    NumeroFactura INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    EstadoDeposito BOOLEAN NOT NULL,
    ImporteMensual DECIMAL(10, 2) CHECK(ImporteMensual > 0) NOT NULL,
    PlazoPagoDias INT CHECK(PlazoPagoDias > 0) NOT NULL,
    Observaciones VARCHAR(100) NOT NULL,
    ImporteTotal DECIMAL(10, 2) CHECK(ImporteTotal > 0) NOT NULL,
    CodigoCliente INT NOT NULL,
    FOREIGN KEY (CodigoCliente) REFERENCES CLIENTES(CodigoCliente) ON UPDATE CASCADE ON DELETE RESTRICT
);
-- Tabla RECIBOS
CREATE TABLE RECIBOS (
    NumeroRecibo INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Importe DECIMAL(10, 2) NOT NULL CHECK(Importe > 0),
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
    PRIMARY KEY (
        NombrePeriodico,
        CodigoInmueble,
        FechaPublicacion
    ),
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
    FOREIGN KEY (NumeroFactura) REFERENCES FACTURAS(NumeroFactura) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CodigoInmueble) REFERENCES INMUEBLES(CodigoInmueble) ON UPDATE CASCADE ON DELETE CASCADE
);
--****************TRIGGERS******************
--cada oficina solo tiene un director.
CREATE OR REPLACE FUNCTION validar_director_unico() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (
        SELECT 1
        FROM DIRECTORES d
            JOIN EMPLEADOS e ON d.CodigoEmpleado = e.CodigoEmpleado
        WHERE e.CodigoOficina = (
                SELECT CodigoOficina
                FROM EMPLEADOS
                WHERE CodigoEmpleado = NEW.CodigoEmpleado
            )
            AND d.FechaInicio = NEW.FechaInicio
    ) THEN RAISE EXCEPTION 'Ya existe un director con esa fecha de inicio en la misma oficina';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_director_unico BEFORE
INSERT ON DIRECTORES FOR EACH ROW EXECUTE FUNCTION validar_director_unico();
--Si se borra un inmueble del sistema, se debe mantener su información 
CREATE OR REPLACE FUNCTION auditar_inmueble_eliminado() RETURNS TRIGGER AS $$ BEGIN -- Insertamos los datos del inmueble eliminado en la tabla INMUEBLESAUDITABLE
INSERT INTO INMUEBLESAUDITABLE (
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
    ) -- Seleccionamos los valores del inmueble que va a ser eliminado
SELECT CURRENT_DATE,
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
AFTER DELETE ON INMUEBLES FOR EACH ROW EXECUTE FUNCTION auditar_inmueble_eliminado();
--No se puede alquilar un inmueble que ya esta alquilado
CREATE OR REPLACE FUNCTION validar_fecha_contrato_alquiler() RETURNS TRIGGER AS $$
DECLARE fecha_inicio DATE;
fecha_finalizacion DATE;
BEGIN -- Si es alquiler, obtenemos la fecha de inicio
SELECT FechaInicio INTO fecha_inicio
FROM CONTRATOS
WHERE NumeroContrato = NEW.NumeroContrato;
-- Buscar en CONTIENEN el último contrato para el inmueble
SELECT a.FechaFinalizacion INTO fecha_finalizacion
FROM CONTIENEN c
    JOIN CONTRATOS a ON c.NumeroContrato = a.NumeroContrato
WHERE c.CodigoInmueble = NEW.CodigoInmueble
ORDER BY c.NumeroContrato DESC
LIMIT 1;
-- Comprobar si la fecha de finalización existe y si la fecha de inicio es válida
IF fecha_finalizacion IS NOT NULL
AND fecha_finalizacion > fecha_inicio THEN RAISE EXCEPTION 'No se puede alquilar un inmueble que ya está alquilado. Fecha de finalización: %',
fecha_finalizacion;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_fecha_contrato_alquiler BEFORE
INSERT ON CONTIENEN FOR EACH ROW EXECUTE FUNCTION validar_fecha_contrato_alquiler();
--Después de la venta de un inmueble, el cliente pasa a ser el propietario. 
CREATE OR REPLACE FUNCTION actualizar_propietario_despues_de_venta() RETURNS TRIGGER AS $$
DECLARE codigo_cliente INTEGER;
nuevo_nombre VARCHAR(50);
nueva_direccion VARCHAR(70);
nuevo_num_telefono VARCHAR(15);
nuevo_tipo_propietario VARCHAR(20) := 'Particular';
-- Cambia a 'Particular'
nuevo_tipo_empresa VARCHAR(50) := NULL;
-- Asegúrate de que sea NULL
nuevo_nombre_persona_contacto VARCHAR(50);
BEGIN -- Obtener el Código del Cliente de la factura asociada
SELECT CodigoCliente INTO codigo_cliente
FROM FACTURAS
WHERE NumeroFactura = NEW.NumeroFactura;
-- Obtener los atributos del nuevo propietario desde la tabla CLIENTES
SELECT Nombre,
    Direccion,
    NumTelefono INTO nuevo_nombre,
    nueva_direccion,
    nuevo_num_telefono
FROM CLIENTES
WHERE CodigoCliente = codigo_cliente;
-- Actualizar el propietario del inmueble que está incluido en la factura
UPDATE PROPIETARIOS
SET Nombre = nuevo_nombre,
    Direccion = nueva_direccion,
    NumTelefono = nuevo_num_telefono,
    TipoPropietario = nuevo_tipo_propietario,
    TipoEmpresa = nuevo_tipo_empresa,
    NombrePersonaContacto = nuevo_nombre_persona_contacto
WHERE CodigoPropietario IN (
        SELECT CodigoPropietario
        FROM INMUEBLES
        WHERE CodigoInmueble = NEW.CodigoInmueble -- Se usa el inmueble que está en la tabla INCLUYEN
    );
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_actualizar_propietario
AFTER
INSERT ON INCLUYEN -- Se ejecuta después de insertar en INCLUYEN
    FOR EACH ROW EXECUTE FUNCTION actualizar_propietario_despues_de_venta();
-- Cada miembro de la plantilla puede tener asignados hasta veinte inmuebles para alquilar.
CREATE OR REPLACE FUNCTION validar_inmuebles_empleado() RETURNS TRIGGER AS $$ BEGIN IF (
        SELECT COUNT(*)
        FROM INMUEBLES
        WHERE CodigoEmpleado = NEW.CodigoEmpleado
    ) > 20 THEN RAISE EXCEPTION 'Este empleado ya tiene 20 inmuebles asignados para alquilar';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_inmuebles_empleado BEFORE
INSERT ON INMUEBLES FOR EACH ROW EXECUTE FUNCTION validar_inmuebles_empleado();
--Cada supervisor del trabajo diario de un grupo de entre cinco y diez empleados
CREATE OR REPLACE FUNCTION validar_empleados_por_supervisor() RETURNS TRIGGER AS $$ BEGIN IF (
        SELECT COUNT(*)
        FROM EMPLEADOS
        WHERE CodigoSupervisor = NEW.CodigoSupervisor
    ) > 10 THEN RAISE EXCEPTION 'Cada supervisor debe tener entre 5 y 10 empleados asignados';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_empleados_supervisor BEFORE
INSERT ON EMPLEADOS FOR EACH ROW EXECUTE FUNCTION validar_empleados_por_supervisor();
--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_administrador() RETURNS TRIGGER AS $$
DECLARE tipo_empleado VARCHAR(50);
BEGIN -- Verificar si el empleado existe y obtener su tipo
SELECT Cargo INTO tipo_empleado
FROM EMPLEADOS
WHERE CodigoEmpleado = NEW.CodigoEmpleado;
-- Si no existe, lanzar excepción
IF tipo_empleado IS NULL THEN RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla ADMINISTRADORES.';
END IF;
-- Verificar si el tipo de empleado es 'Administrador'
IF tipo_empleado <> 'Administrador' THEN RAISE EXCEPTION 'El empleado no es un Administrador. No se puede insertar en la tabla ADMINISTRADORES.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_insertar_administrador BEFORE
INSERT ON ADMINISTRADORES FOR EACH ROW EXECUTE FUNCTION validar_insertar_administrador();
--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_director() RETURNS TRIGGER AS $$
DECLARE tipo_empleado VARCHAR(50);
BEGIN -- Verificar si el empleado existe y obtener su tipo
SELECT Cargo INTO tipo_empleado
FROM EMPLEADOS
WHERE CodigoEmpleado = NEW.CodigoEmpleado;
-- Si no existe, lanzar excepción
IF tipo_empleado IS NULL THEN RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla DIRECTORES.';
END IF;
-- Verificar si el tipo de empleado es 'Director'
IF tipo_empleado <> 'Director' THEN RAISE EXCEPTION 'El empleado no es un Director. No se puede insertar en la tabla DIRECTORES.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_insertar_director BEFORE
INSERT ON DIRECTORES FOR EACH ROW EXECUTE FUNCTION validar_insertar_director();
--Jerarquia exclusiva empleados
CREATE OR REPLACE FUNCTION validar_insertar_supervisor() RETURNS TRIGGER AS $$
DECLARE tipo_empleado VARCHAR(50);
BEGIN -- Verificar si el empleado existe y obtener su tipo
SELECT Cargo INTO tipo_empleado
FROM EMPLEADOS
WHERE CodigoEmpleado = NEW.CodigoEmpleado;
-- Si no existe, lanzar excepción
IF tipo_empleado IS NULL THEN RAISE EXCEPTION 'El empleado no existe o el Cargo es nulo. No se puede insertar en la tabla SUPERVISORES.';
END IF;
-- Verificar si el tipo de empleado es 'Supervisor'
IF tipo_empleado <> 'Supervisor' THEN RAISE EXCEPTION 'El empleado no es un Supervisor. No se puede insertar en la tabla SUPERVISORES.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_insertar_supervisor BEFORE
INSERT ON SUPERVISORES FOR EACH ROW EXECUTE FUNCTION validar_insertar_supervisor();
--*****************Lenguaje de Manipulacion de datos************************
-- 1Crear y mantener las fichas con los datos de los empleados y su familiar más próximo (director).
-- Insertar tres oficinas en Venezuela
INSERT INTO OFICINAS (
        DireccionCalle,
        DireccionNumero,
        DireccionCiudad,
        NumTelefono,
        NumFax
    )
VALUES (
        'Av. Francisco de Miranda',
        '125',
        'Caracas',
        '0212-5554321',
        '0212-5554322'
    ),
    (
        'Calle 72',
        '10B',
        'Maracaibo',
        '0261-7891234',
        '0261-7891235'
    ),
    (
        'Av. Los Leones',
        '47',
        'Barquisimeto',
        '0251-4567890',
        '0251-4567891'
    );
-- Insertar un empleado en la oficina de Caracas (la primera oficina insertada)
INSERT INTO EMPLEADOS (
        DNI,
        Nombre,
        Direccion,
        NumTelefono,
        FechaNacimiento,
        ParienteNombre,
        ParienteRelacion,
        ParienteDireccion,
        ParienteNumTelefono,
        SalarioAnual,
        FechaIngreso,
        Cargo,
        CodigoOficina
    )
VALUES (
        'V-12345678',
        'Luis Fernández',
        'Calle La Candelaria, Edif. 32',
        '0414-1234567',
        '1985-03-22',
        'Ana Fernández',
        'Esposa',
        'Calle Los Jardines, Casa 5',
        '0424-8765432',
        60000.00,
        '2015-09-10',
        'Director',
        1
    );
-- Insertar al director en la tabla DIRECTORES
INSERT INTO DIRECTORES (
        CodigoEmpleado,
        FechaInicio,
        MontoPagoAnual,
        BonificacionAnual
    )
VALUES (1, '2015-09-10', 60000.00, 5000.00);
-- Insertar 4 supervisores
INSERT INTO EMPLEADOS (
        DNI,
        Nombre,
        Direccion,
        NumTelefono,
        FechaNacimiento,
        ParienteNombre,
        ParienteRelacion,
        ParienteDireccion,
        ParienteNumTelefono,
        SalarioAnual,
        FechaIngreso,
        Cargo,
        CodigoOficina
    )
VALUES (
        'V-23456789',
        'María Pérez',
        'Calle 13, Edif. 45',
        '0416-7654321',
        '1990-05-10',
        'Juan Pérez',
        'Hermano',
        'Calle 12, Casa 20',
        '0424-5678901',
        50000.00,
        '2020-01-15',
        'Supervisor',
        1
    ),
    (
        'V-34567890',
        'José López',
        'Calle El Mirador, Casa 78',
        '0416-1234567',
        '1988-11-22',
        'Laura López',
        'Esposa',
        'Calle Los Olivos, Casa 10',
        '0416-7654322',
        50000.00,
        '2020-02-20',
        'Supervisor',
        1
    ),
    (
        'V-45678901',
        'Ana González',
        'Av. Bolívar, Edif. 32',
        '0414-2345678',
        '1995-07-15',
        'Carlos González',
        'Padre',
        'Calle Las Flores, Casa 15',
        '0414-8765432',
        48000.00,
        '2021-03-05',
        'Supervisor',
        2
    ),
    (
        'V-56789012',
        'Luis Ramírez',
        'Calle 5, Casa 14',
        '0412-1234567',
        '1992-12-01',
        'Clara Ramírez',
        'Esposa',
        'Calle 7, Casa 10',
        '0412-7654321',
        48000.00,
        '2021-03-15',
        'Supervisor',
        3
    );
-- Insertar supervisores en la tabla SUPERVISORES
INSERT INTO SUPERVISORES (CodigoEmpleado)
VALUES (2),
    -- María Pérez (Oficina Caracas)
    (3),
    -- José López (Oficina Caracas)
    (4),
    -- Ana González (Oficina Maracaibo)
    (5);
-- Luis Ramírez (Oficina Barquisimeto)
-- Insertar 1 administrador para la oficina de Caracas
INSERT INTO EMPLEADOS (
        DNI,
        Nombre,
        Direccion,
        NumTelefono,
        FechaNacimiento,
        ParienteNombre,
        ParienteRelacion,
        ParienteDireccion,
        ParienteNumTelefono,
        SalarioAnual,
        FechaIngreso,
        Cargo,
        CodigoOficina
    )
VALUES (
        'V-67890123',
        'Carmen Torres',
        'Calle El Palmar, Edif. 2',
        '0414-2345679',
        '1990-08-20',
        'Pedro Torres',
        'Hijo',
        'Calle 9, Casa 8',
        '0414-8765433',
        55000.00,
        '2018-07-10',
        'Administrador',
        1
    );
-- Insertar administrador en la tabla ADMINISTRADORES
INSERT INTO ADMINISTRADORES (
        CodigoEmpleado,
        VelocidadEscritura,
        CodigoSupervisor
    )
VALUES (6, 85, 2);
-- Carmen Torres (supervisada por María Pérez)
-- Insertar 4 empleados (cargo 'Otro') para la oficina de Caracas
INSERT INTO EMPLEADOS (
        DNI,
        Nombre,
        Direccion,
        NumTelefono,
        FechaNacimiento,
        ParienteNombre,
        ParienteRelacion,
        ParienteDireccion,
        ParienteNumTelefono,
        SalarioAnual,
        FechaIngreso,
        Cargo,
        CodigoOficina,
        CodigoSupervisor
    )
VALUES (
        'V-78901234',
        'Rafael Díaz',
        'Calle 10, Casa 30',
        '0414-9876543',
        '1993-04-25',
        'Sofía Díaz',
        'Hija',
        'Calle 12, Casa 14',
        '0414-2345670',
        30000.00,
        '2022-09-01',
        'Otro',
        1,
        2
    ),
    (
        'V-89012345',
        'Natalia Castro',
        'Calle 11, Edif. 8',
        '0416-9876542',
        '1991-01-11',
        'Alfredo Castro',
        'Esposo',
        'Calle 14, Casa 22',
        '0416-8765435',
        30000.00,
        '2022-09-05',
        'Otro',
        1,
        2
    ),
    (
        'V-90123456',
        'Miguel Fernández',
        'Calle 12, Casa 5',
        '0412-3456789',
        '1995-03-19',
        'Rosa Fernández',
        'Madre',
        'Calle 5, Casa 10',
        '0412-2345678',
        30000.00,
        '2022-09-10',
        'Otro',
        1,
        2
    ),
    (
        'V-01234567',
        'Patricia Martínez',
        'Calle 13, Edif. 25',
        '0414-1234568',
        '1994-06-15',
        'Javier Martínez',
        'Esposo',
        'Calle 10, Casa 9',
        '0414-5678902',
        30000.00,
        '2022-09-15',
        'Otro',
        1,
        2
    );
--2. Realizar listados de los empleados de cada oficina (director).
SELECT *
FROM EMPLEADOS --3. Realizar listados del grupo de empleados de un supervisor (director y supervisor).
SELECT *
FROM EMPLEADOS
WHERE codigosupervisor = 2 --4. Realizar listados de los supervisores de cada oficina (director y supervisor).
SELECT *
FROM EMPLEADOS
WHERE Cargo = 'Supervisor' --5. Crear y mantener las fichas con los datos de los inmuebles para alquilar (y de sus propietarios) de cada oficina (supervisor).
    -- Insertar 5 propietarios
INSERT INTO PROPIETARIOS (
        Nombre,
        Direccion,
        NumTelefono,
        TipoPropietario,
        TipoEmpresa,
        NombrePersonaContacto
    )
VALUES (
        'Carlos Rivas',
        'Calle Libertador, Edif. 10',
        '0212123456',
        'Particular',
        NULL,
        NULL
    ),
    (
        'Inversiones Roca C.A.',
        'Av. Francisco Solano, Torre B',
        '0212765432',
        'Empresa',
        'Inmobiliaria',
        'Lucía Gómez'
    ),
    (
        'Ana López',
        'Calle 9, Casa 15',
        '0414123456',
        'Particular',
        NULL,
        NULL
    ),
    (
        'Comercial Las Brisas C.A.',
        'Av. Andrés Bello, Local 8',
        '0261123456',
        'Empresa',
        'Comercializadora',
        'Jorge Pérez'
    ),
    (
        'Corporación Mérida C.A.',
        'Av. Universidad, Torre C',
        '0274123456',
        'Empresa',
        'Constructora',
        'Marta Sánchez'
    );
-- Insertar 5 inmuebles
INSERT INTO INMUEBLES (
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
VALUES (
        'Av. Urdaneta',
        '56',
        'Caracas',
        'Apartamento',
        3,
        'Apartamento amplio en zona céntrica',
        500.00,
        60000.00,
        1,
        1
    ),
    (
        'Calle 5',
        '22',
        'Maracaibo',
        'Casa',
        4,
        'Casa con amplio jardín y garaje',
        800.00,
        120000.00,
        2,
        2
    ),
    (
        'Av. Libertador',
        '1001',
        'Barquisimeto',
        'Local Comercial',
        1,
        'Local con excelente ubicación comercial',
        300.00,
        50000.00,
        3,
        3
    ),
    (
        'Calle Los Jardines',
        '35',
        'Maracaibo',
        'Apartamento',
        2,
        'Apartamento cómodo, ideal para parejas',
        400.00,
        70000.00,
        4,
        4
    ),
    (
        'Av. Bolívar',
        '78',
        'Caracas',
        'Oficina',
        1,
        'Oficina moderna en edificio corporativo',
        350.00,
        90000.00,
        5,
        1
    );
--6. Realizar listados de los inmuebles para alquilar en cada oficina (toda la plantilla).
SELECT *
FROM INMUEBLES
WHERE PrecioAlquilerEuros IS NOT NULL --7. Realizar listados de los inmuebles para alquilar asignados a un determinado miembro de la plantilla (supervisor).
SELECT *
FROM INMUEBLES
WHERE CodigoEmpleado = 1 --8. Crear y mantener las fichas con los datos de los posibles inquilinos de cada oficina (supervisor).
    -- Insertar 5 clientes en la tabla CLIENTES
INSERT INTO CLIENTES (
        Nombre,
        Direccion,
        NumTelefono,
        TipoInmueble,
        ImporteMax,
        CodigoEmpleado,
        FechaEntrevistaInicial,
        ComentariosEntrevista
    )
VALUES (
        'Carlos Hernández',
        'Av. Sucre, Edif. Bolívar, Caracas',
        '0414-7654321',
        'Apartamento',
        40000.00,
        1,
        '2024-09-20',
        'Busca un apartamento cerca del centro'
    ),
    (
        'María López',
        'Calle 8, Urb. La Florida, Maracaibo',
        '0416-8765432',
        'Casa',
        60000.00,
        2,
        '2024-09-21',
        'Quiere una casa con jardín para su familia'
    ),
    (
        'José Rodríguez',
        'Calle 12, Urb. Las Mercedes, Barquisimeto',
        '0424-9876543',
        'Apartamento',
        45000.00,
        3,
        '2024-09-22',
        'Necesita un apartamento cerca de su trabajo'
    ),
    (
        'Ana Gómez',
        'Av. Libertador, Edif. Central, Caracas',
        '0412-3456789',
        'Casa',
        70000.00,
        4,
        '2024-09-23',
        'Busca una casa grande con garaje'
    ),
    (
        'Pedro Pérez',
        'Calle Los Jardines, Urb. El Paraíso, Maracaibo',
        '0414-1234567',
        'Apartamento',
        50000.00,
        5,
        '2024-09-24',
        'Interesado en un apartamento con vista al lago'
    );
--9. Realizar listados de los posibles inquilinos registrados en cada oficina (toda la plantilla).
SELECT *
FROM CLIENTES --10. Buscar inmuebles para alquilar que satisfacen las necesidades de un posible inquilino (toda la plantilla).
SELECT CodigoCliente,
    CodigoInmueble,
    DireccionCalle,
    DireccionNumero,
    DireccionCiudad,
    i.TipoInmueble,
    NumHabitaciones,
    Descripcion,
    PrecioAlquilerEuros,
    PrecioVenta,
    CodigoPropietario,
    i.CodigoEmpleado
FROM INMUEBLES i,
    CLIENTES cl
WHERE PrecioAlquilerEuros IS NOT NULL
    AND cl.TipoInmueble = i.TipoInmueble
    AND PrecioAlquilerEuros <= ImporteMax
    AND CodigoCliente = 1 --11. Crear y mantener las fichas de las visitas realizadas por los posibles inquilinos (toda la plantilla).
    -- Insertar 5 registros en la tabla VISITAN
INSERT INTO VISITAN (
        CodigoCliente,
        CodigoInmueble,
        FechaVisita,
        Comentarios
    )
VALUES (
        1,
        1,
        '2024-10-01',
        'Le gustó el apartamento pero el precio es alto'
    ),
    (
        1,
        2,
        '2024-10-02',
        'La casa necesita algunas reparaciones'
    ),
    (
        2,
        3,
        '2024-10-03',
        'Le pareció excelente ubicación, pero muy pequeño'
    ),
    (
        2,
        4,
        '2024-10-04',
        'Interesada, pero requiere más habitaciones'
    ),
    (
        3,
        5,
        '2024-10-05',
        'Quedó satisfecho con la vista del apartamento'
    );
--12. Realizar listados con los comentarios hechos por los posibles inquilinos respecto a un inmueble concreto (toda la plantilla).
SELECT Comentarios
FROM VISITAN
WHERE CodigoInmueble = 2 --13. Crear y mantener las fichas con los datos de los anuncios insertados en los periódicos (toda la plantilla).
    -- Insertar 2 periódicos en la tabla PERIODICOS
INSERT INTO PERIODICOS (
        NombrePeriodico,
        Direccion,
        NumTelefono,
        NombrePersonaContacto,
        NumFax
    )
VALUES (
        'El Nacional',
        'Av. Urdaneta, Torre El Chorro, Caracas',
        '0212-5555555',
        'Carlos García',
        '0212-5555556'
    ),
    (
        'El Universal',
        'Calle Vargas, Edif. Centro, Maracaibo',
        '0261-7654321',
        'María Rodríguez',
        '0261-7654322'
    );
-- Insertar 2 anuncios en cada periódico en la tabla ANUNCIAN
INSERT INTO ANUNCIAN (
        NombrePeriodico,
        CodigoInmueble,
        FechaPublicacion,
        Comentarios
    )
VALUES (
        'El Nacional',
        1,
        '2024-10-01',
        'Apartamento céntrico en venta.'
    ),
    (
        'El Nacional',
        2,
        '2024-10-02',
        'Casa con jardín, ideal para familia.'
    ),
    (
        'El Universal',
        3,
        '2024-10-03',
        'Apartamento en excelente zona residencial.'
    ),
    (
        'El Universal',
        4,
        '2024-10-04',
        'Casa con piscina y amplias áreas verdes.'
    );
--14. Realizar listados de todos los anuncios que se han hecho sobre un determinado inmueble (supervisor).
SELECT *
FROM ANUNCIAN
WHERE CodigoInmueble = 2 --15. Realizar listados de todos los anuncios realizados en un determinado periódico (supervisor).
SELECT *
FROM ANUNCIAN
WHERE NombrePeriodico = 'El Nacional' --16. Crear y mantener las fichas que contienen los datos sobre cada contrato de alquiler (director y supervisor).
    -- Insertar un contrato de alquiler de un inmueble
    ALTER SEQUENCE contratos_numerocontrato_seq RESTART WITH 1;
INSERT INTO CONTRATOS (
        MetodoPago,
        ImporteDeposito,
        CodigoCliente,
        CodigoEmpleado,
        EstadoDeposito,
        ImporteMensual,
        FechaInicio,
        FechaFinalizacion,
        DuracionMeses,
        TipoContrato
    )
VALUES (
        'Transferencia Bancaria',
        1200.00,
        1,
        1,
        TRUE,
        600.00,
        '2024-09-01',
        '2025-03-01',
        6,
        'Alquiler'
    ),
    (
        'Tarjeta de Crédito',
        2000.00,
        2,
        1,
        TRUE,
        900.00,
        '2024-10-01',
        '2025-04-01',
        6,
        'Alquiler'
    );
-- Asociar el inmueble al contrato de alquiler
INSERT INTO CONTIENEN (NumeroContrato, CodigoInmueble)
VALUES (1, 1),
    (2, 2),
    (2, 3);
--17. Realizar listados de los contratos de alquiler de un determinado inmueble (director y supervisor).
SELECT DISTINCT contra.NumeroContrato,
    conti.CodigoInmueble,
    contra.EstadoDeposito,
    contra.ImporteMensual,
    contra.FechaInicio,
    contra.FechaFinalizacion,
    contra.DuracionMeses,
    contra.MetodoPago,
    contra.ImporteDeposito,
    contra.TipoContrato,
    contra.CodigoCliente,
    contra.CodigoEmpleado
FROM CONTRATOS contra
    JOIN CONTIENEN conti ON contra.NumeroContrato = conti.NumeroContrato
WHERE conti.CodigoInmueble = 1;
--18. Crear y mantener las fichas con los datos de cada inspección realizada a los inmuebles en alquiler (toda la plantilla).
-- Inserción de tres inspecciones
INSERT INTO INSPECCIONAN (
        CodigoEmpleado,
        CodigoInmueble,
        FechaInspeccion,
        Comentarios
    )
VALUES (
        1,
        2,
        '2024-10-01',
        'Inspección inicial de la propiedad. Todo en orden.'
    ),
    (
        2,
        1,
        '2024-10-02',
        'Inspección realizada. Se recomienda limpieza.'
    ),
    (
        3,
        3,
        '2024-10-03',
        'Inspección finalizada. Requiere reparaciones menores.'
    );
--19. Realizar listados de todas las inspecciones realizadas a un determinado inmueble (supervisor).
SELECT *
FROM INSPECCIONAN
WHERE CodigoInmueble = 1