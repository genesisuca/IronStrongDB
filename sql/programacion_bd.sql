IF DB_ID('IronStrongFitness') IS NOT NULL
    DROP DATABASE IronStrongFitness;
GO

CREATE DATABASE IronStrongFitness;
GO

USE IronStrongFitness;
GO
--TABLA MIEMBROS
CREATE TABLE Miembros (
    IdMiembro INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL,
    FechaNacimiento DATE,
    Email VARCHAR(150) UNIQUE,
    Estado VARCHAR(10) NOT NULL
        CONSTRAINT CK_Miembros_Estado CHECK (Estado IN ('Activo','Inactivo')),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO
--TABLA MEMBRESIAS 
CREATE TABLE Membresias (
    IdMembresia INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Costo DECIMAL(10,2) NOT NULL,
    DuracionDias INT NOT NULL
);
GO

-- TABLA CONTRATOS
CREATE TABLE Contratos (
    IdContrato INT IDENTITY(1,1) PRIMARY KEY,
    IdMiembro INT NOT NULL,
    IdMembresia INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    FOREIGN KEY (IdMiembro) REFERENCES Miembros(IdMiembro),
    FOREIGN KEY (IdMembresia) REFERENCES Membresias(IdMembresia)
);
GO


--TABLA ENTRENADORES
CREATE TABLE Entrenadores (
    IdEntrenador INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL,
    Especialidad VARCHAR(100),
    Email VARCHAR(150)
);
GO

-- TABLA CLASES
CREATE TABLE Clases (
    IdClase INT IDENTITY(1,1) PRIMARY KEY,
    NombreClase VARCHAR(120) NOT NULL,
    IdEntrenador INT,
    Horario TIME,
    CupoMaximo INT NOT NULL DEFAULT 20,
    FOREIGN KEY (IdEntrenador) REFERENCES Entrenadores(IdEntrenador)
);
GO

--TABLA ASISTENCIAS
CREATE TABLE Asistencias (
    IdAsistencia INT IDENTITY(1,1) PRIMARY KEY,
    IdClase INT NOT NULL,
    IdMiembro INT NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdClase) REFERENCES Clases(IdClase),
    FOREIGN KEY (IdMiembro) REFERENCES Miembros(IdMiembro)
);
GO

-- TABLA PAGOS 
CREATE TABLE Pagos (
    IdPago INT IDENTITY(1,1) PRIMARY KEY,
    IdContrato INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaPago DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdContrato) REFERENCES Contratos(IdContrato)
);
GO

--Tabla de Auditoría de Pagos Eliminados
CREATE TABLE LogPagosEliminados (
    IdLog INT IDENTITY(1,1) PRIMARY KEY,
    IdPagoOriginal INT,
    IdContrato INT,
    Monto DECIMAL(10,2),
    FechaPago DATETIME,
    UsuarioElim NVARCHAR(200),
    FechaElim DATETIME DEFAULT GETDATE()
);
GO
--------------------------------------------------------------
-- INSERT MIEMBROS
--------------------------------------------------------------
INSERT INTO Miembros (Nombre, FechaNacimiento, Email, Estado) VALUES
('Ana López', '1997-05-12', 'ana@example.com', 'Activo'),
('Carlos Jiménez', '1994-03-20', 'carlos@example.com', 'Activo'),
('María Gómez', '1999-10-02', 'maria@example.com', 'Activo'),
('Luis Martínez', '1985-07-18', 'luis@example.com', 'Activo'),
('Sofía Rojas', '2000-12-11', 'sofia@example.com', 'Inactivo'),
('Daniel Navarro', '1992-02-14', 'daniel@example.com', 'Activo'),
('Elena Vargas', '1996-08-09', 'elena@example.com', 'Activo'),
('Andrés Castro', '1990-01-22', 'andres@example.com', 'Activo'),
('Gabriela Ruiz', '1998-04-03', 'gabriela@example.com', 'Activo'),
('Jorge Rivera', '1993-11-30', 'jorge@example.com', 'Activo'),
('Patricia León', '1991-09-17', 'patricia@example.com', 'Activo'),
('Roberto Mora', '1995-07-25', 'roberto@example.com', 'Activo'),
('Laura Vega', '1997-06-14', 'laura@example.com', 'Activo'),
('Kevin Blanco', '2001-05-06', 'kevin@example.com', 'Activo'),
('Valeria Soto', '1998-03-19', 'valeria@example.com', 'Activo'),
('Mario Castro', '1989-10-28', 'mario@example.com', 'Activo'),
('Sara Salazar', '1996-07-02', 'sara@example.com', 'Activo'),
('Diego Araya', '1994-12-21', 'diego@example.com', 'Activo'),
('Paola Quesada', '1998-11-30', 'paola@example.com', 'Inactivo'),
('Ricardo Vargas', '1993-08-16', 'ricardo@example.com', 'Activo');
GO
--------------------------------------------------------------
-- INSERT MEMBRESIAS
--------------------------------------------------------------
INSERT INTO Membresias (Nombre, Costo, DuracionDias) VALUES
('Mensual', 25000, 30),
('Trimestral', 65000, 90),
('Semestral', 110000, 180),
('Anual', 200000, 365),
('VIP', 300000, 365);
GO
--------------------------------------------------------------
-- INSERT ENTRENADORES
--------------------------------------------------------------
INSERT INTO Entrenadores (Nombre, Especialidad, Email) VALUES
('Juan Pérez', 'Crossfit', 'jperez@iron.com'),
('Daniel Salas', 'Spinning', 'dsalas@iron.com'),
('Mariela Torres', 'Yoga', 'mtorres@iron.com'),
('Miguel Mora', 'Pesas', 'mmora@iron.com'),
('Andrea López', 'Pilates', 'alopez@iron.com'),
('Héctor Rojas', 'Boxeo', 'hrojas@iron.com'),
('Carolina Ruiz', 'Zumba', 'cruiz@iron.com'),
('José Vargas', 'Funcional', 'jvargas@iron.com'),
('Patricia Mora', 'Stretching', 'pmora@iron.com'),
('Erick Blanco', 'Cardio HIIT', 'eblanco@iron.com');
GO
--------------------------------------------------------------
-- INSERT CLASES
--------------------------------------------------------------
INSERT INTO Clases (NombreClase, IdEntrenador, Horario, CupoMaximo) VALUES
('Crossfit Avanzado', 1, '07:00', 20),
('Spinning Intermedio', 2, '18:00', 25),
('Yoga Principiantes', 3, '09:00', 20),
('Pesas Nivel 1', 4, '16:00', 20),
('Pilates Suave', 5, '10:00', 15),
('Boxeo Funcional', 6, '17:00', 20),
('Zumba Dance', 7, '19:00', 30),
('Entrenamiento Funcional', 8, '06:00', 20),
('Stretching Suave', 9, '08:00', 15),
('Cardio HIIT', 10, '17:30', 20),
('Crossfit Básico', 1, '12:00', 20),
('Yoga Avanzado', 3, '14:00', 20),
('Spinning Pro', 2, '20:00', 25),
('Pilates Intermedio', 5, '15:00', 15),
('Boxeo Avanzado', 6, '19:30', 20);
GO
--------------------------------------------------------------
-- INSERT CONTRATOS
--------------------------------------------------------------
INSERT INTO Contratos (IdMiembro, IdMembresia, FechaInicio, FechaFin) VALUES
(1, 1, '2024-01-01', '2024-01-31'),
(2, 5, '2024-01-05', '2025-01-05'),
(3, 1, '2024-02-01', '2024-03-02'),
(4, 2, '2024-01-15', '2024-04-15'),
(5, 4, '2024-03-10', '2025-03-10'),
(6, 1, '2024-01-20', '2024-02-20'),
(7, 3, '2024-01-01', '2024-06-30'),
(8, 5, '2024-01-10', '2025-01-10'),
(9, 2, '2024-02-15', '2024-05-15'),
(10, 1, '2024-03-01', '2024-03-31');
GO
--------------------------------------------------------------
-- INSERT ASISTENCIAS
--------------------------------------------------------------
INSERT INTO Asistencias (IdClase, IdMiembro) VALUES
(1,1),(1,2),(1,3),(1,4),(1,6),
(2,3),(2,8),(2,10),(2,12),(2,14),
(3,5),(3,7),(3,9),(3,11),(3,13),
(4,2),(4,4),(4,6),(4,8),(4,10),
(5,1),(5,3),(5,5),(5,7),(5,9),
(6,15),(7,16),(8,17),(9,18),(10,19);
GO
--------------------------------------------------------------
-- INSERT PAGOS
--------------------------------------------------------------
INSERT INTO Pagos (IdContrato, Monto) VALUES
(1,25000),(2,300000),(3,25000),(4,65000),(5,200000),
(6,25000),(7,110000),(8,300000),(9,65000),(10,25000);
GO
--------------------------------------------------------------
-- fn_EstadoMembresia
--------------------------------------------------------------
CREATE FUNCTION fn_EstadoMembresia (@FechaFin DATE)
RETURNS VARCHAR(10)
AS
BEGIN
    IF (@FechaFin >= CAST(GETDATE() AS DATE))
        RETURN 'VIGENTE';
    RETURN 'VENCIDA';
END;
GO


--------------------------------------------------------------
-- fn_EdadPromedioClase
--------------------------------------------------------------
CREATE FUNCTION fn_EdadPromedioClase (@IdClase INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Prom DECIMAL(5,2);

    SELECT @Prom = AVG(DATEDIFF(YEAR, m.FechaNacimiento, GETDATE()))
    FROM Asistencias a
    JOIN Miembros m ON m.IdMiembro = a.IdMiembro
    WHERE a.IdClase = @IdClase;

    RETURN @Prom;
END;
GO
--------------------------------------------------------------
-- sp_InscribirClase
--------------------------------------------------------------
CREATE PROCEDURE sp_InscribirClase
    @IdMiembro INT,
    @IdClase INT
AS
BEGIN
    DECLARE @CupoMax INT, @Inscritos INT, @FechaFin DATE;

    SELECT @CupoMax = CupoMaximo FROM Clases WHERE IdClase = @IdClase;
    SELECT @Inscritos = COUNT(*) FROM Asistencias WHERE IdClase = @IdClase;

    IF (@Inscritos >= @CupoMax)
        THROW 50001, 'NO HAY CUPO DISPONIBLE', 1;

    SELECT TOP 1 @FechaFin = FechaFin
    FROM Contratos
    WHERE IdMiembro = @IdMiembro
    ORDER BY FechaFin DESC;

    IF (@FechaFin < CAST(GETDATE() AS DATE))
        THROW 50002, 'MEMBRESÍA NO VIGENTE', 1;

    INSERT INTO Asistencias (IdClase, IdMiembro) 
    VALUES (@IdClase, @IdMiembro);
END;
GO


--------------------------------------------------------------
-- sp_ReporteVentasEntrenador
--------------------------------------------------------------
CREATE PROCEDURE sp_ReporteVentasEntrenador
    @IdEntrenador INT
AS
BEGIN
    SELECT e.Nombre AS Entrenador,
           SUM(p.Monto) AS TotalGenerado
    FROM Entrenadores e
    JOIN Clases c ON c.IdEntrenador = e.IdEntrenador
    JOIN Asistencias a ON a.IdClase = c.IdClase
    JOIN Contratos ct ON ct.IdMiembro = a.IdMiembro
    JOIN Pagos p ON p.IdContrato = ct.IdContrato
    WHERE e.IdEntrenador = @IdEntrenador
    GROUP BY e.Nombre;
END;
GO
--------------------------------------------------------------
-- Auditoría de eliminación de pagos
--------------------------------------------------------------
CREATE TRIGGER trg_after_delete_pago
ON Pagos
AFTER DELETE
AS
BEGIN
    INSERT INTO LogPagosEliminados (
        IdPagoOriginal, IdContrato, Monto, FechaPago, UsuarioElim
    )
    SELECT 
        d.IdPago, d.IdContrato, d.Monto, d.FechaPago, SUSER_SNAME()
    FROM deleted d;
END;
GO


--------------------------------------------------------------
-- Validación de membresía al insertar asistencia
--------------------------------------------------------------
CREATE TRIGGER trg_before_insert_asistencia
ON Asistencias
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @IdMiembro INT, @IdClase INT, @FechaFin DATE;

    SELECT @IdMiembro = IdMiembro, @IdClase = IdClase FROM inserted;

    SELECT TOP 1 @FechaFin = FechaFin
    FROM Contratos
    WHERE IdMiembro = @IdMiembro
    ORDER BY FechaFin DESC;

    IF (@FechaFin < CAST(GETDATE() AS DATE))
        THROW 50003, 'NO SE PUEDE REGISTRAR ASISTENCIA: MEMBRESÍA VENCIDA', 1;

    INSERT INTO Asistencias (IdClase, IdMiembro)
    SELECT IdClase, IdMiembro FROM inserted;
END;
GO
--------------------------------------------------------------
-- vw_OcupacionGimnasio
--------------------------------------------------------------
CREATE VIEW vw_OcupacionGimnasio AS
SELECT 
    c.IdClase,
    c.NombreClase,
    e.Nombre AS Entrenador,
    c.CupoMaximo,
    COUNT(a.IdAsistencia) AS Inscritos
FROM Clases c
LEFT JOIN Entrenadores e ON e.IdEntrenador = c.IdEntrenador
LEFT JOIN Asistencias a ON a.IdClase = c.IdClase
GROUP BY c.IdClase, c.NombreClase, e.Nombre, c.CupoMaximo;
GO


--------------------------------------------------------------
-- vw_Deudores
--------------------------------------------------------------
CREATE VIEW vw_Deudores AS
SELECT 
    m.IdMiembro,
    m.Nombre,
    c.IdContrato,
    c.FechaFin
FROM Miembros m
JOIN Contratos c ON c.IdMiembro = m.IdMiembro
LEFT JOIN Pagos p ON p.IdContrato = c.IdContrato
    AND p.FechaPago > c.FechaFin
WHERE c.FechaFin < CAST(GETDATE() AS DATE)
  AND p.IdPago IS NULL;
GO
WITH TopClases AS (
    SELECT IdClase, COUNT(*) AS TotalAsistencias
    FROM Asistencias
    GROUP BY IdClase
)
SELECT TOP 3 t.IdClase, c.NombreClase, t.TotalAsistencias
FROM TopClases t
JOIN Clases c ON c.IdClase = t.IdClase
ORDER BY t.TotalAsistencias DESC;
GO
CREATE PROCEDURE sp_RenovarMembresia
    @IdContrato INT,
    @Monto DECIMAL(10,2)
AS
BEGIN
    DECLARE @Costo DECIMAL(10,2), @Duracion INT;

    BEGIN TRAN;

    SELECT @Costo = m.Costo, @Duracion = m.DuracionDias
    FROM Contratos c
    JOIN Membresias m ON m.IdMembresia = c.IdMembresia
    WHERE c.IdContrato = @IdContrato;

    IF (@Monto < @Costo)
    BEGIN
        ROLLBACK;
        THROW 50004, 'PAGO INSUFICIENTE', 1;
    END

    INSERT INTO Pagos (IdContrato, Monto) VALUES (@IdContrato, @Monto);

    UPDATE Contratos
    SET FechaFin = DATEADD(DAY, @Duracion, FechaFin)
    WHERE IdContrato = @IdContrato;

    COMMIT;
END;
GO
--Miembros con membresía "VIP"
SELECT 
    m.IdMiembro,
    m.Nombre,
    mb.Nombre AS Membresia,
    c.FechaFin
FROM Miembros m
JOIN Contratos c ON c.IdMiembro = m.IdMiembro
JOIN Membresias mb ON mb.IdMembresia = c.IdMembresia
WHERE mb.Nombre = 'VIP';
--Calendario de clases por horario + entrenador
SELECT
    c.NombreClase,
    e.Nombre AS Entrenador,
    c.Horario
FROM Clases c
LEFT JOIN Entrenadores e ON e.IdEntrenador = c.IdEntrenador
ORDER BY c.Horario, e.Nombre;
--Miembros que nunca han asistido a una clase
SELECT 
    m.IdMiembro,
    m.Nombre
FROM Miembros m
LEFT JOIN Asistencias a ON a.IdMiembro = m.IdMiembro
WHERE a.IdAsistencia IS NULL;
--Pagos realizados en el último mes
SELECT *
FROM Pagos
WHERE FechaPago >= DATEADD(MONTH, -1, GETDATE());
--UNION
SELECT Email FROM Miembros
UNION
SELECT Email FROM Entrenadores;
--INTERSECT
SELECT m.IdMiembro, m.Nombre
FROM Miembros m
WHERE m.IdMiembro IN (

    SELECT c.IdMiembro
    FROM Contratos c
    WHERE c.FechaFin >= CAST(GETDATE() AS DATE)

)
INTERSECT
SELECT a.IdMiembro, m.Nombre
FROM Asistencias a
JOIN Miembros m ON m.IdMiembro = a.IdMiembro
WHERE a.FechaRegistro >= DATEADD(DAY, -7, GETDATE());
--EXCEPT
SELECT IdEntrenador, Nombre
FROM Entrenadores

EXCEPT

SELECT e.IdEntrenador, e.Nombre
FROM Entrenadores e
JOIN Clases c ON c.IdEntrenador = e.IdEntrenador;


