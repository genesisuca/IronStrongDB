USE IronStrongFitness;

-- =========================================================
--  FUNCTION: fn_EstadoMembresia
--  Devuelve "VIGENTE" o "VENCIDA"
-- =========================================================
DELIMITER $$
CREATE FUNCTION fn_EstadoMembresia(p_FechaFin DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_FechaFin >= CURDATE() THEN
        RETURN 'VIGENTE';
    ELSE
        RETURN 'VENCIDA';
    END IF;
END $$
DELIMITER ;



-- =========================================================
--  PROCEDURE: sp_InscribirClase
--  Verifica:
--    1) Cupo de la clase
--    2) Membresía vigente
-- =========================================================
DELIMITER $$

CREATE PROCEDURE sp_InscribirClase(
    IN p_IdMiembro INT,
    IN p_IdClase INT
)
BEGIN
    DECLARE v_cupoMax INT;
    DECLARE v_actual INT;
    DECLARE v_fechaFin DATE;

    -- Verificar cupo
    SELECT CupoMaximo INTO v_cupoMax
    FROM Clases
    WHERE IdClase = p_IdClase;

    SELECT COUNT(*) INTO v_actual
    FROM Asistencias
    WHERE IdClase = p_IdClase;

    IF v_actual >= v_cupoMax THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cupo lleno. No se puede inscribir.';
    END IF;

    -- Verificar membresía vigente
    SELECT FechaFin INTO v_fechaFin
    FROM Contratos
    WHERE IdMiembro = p_IdMiembro
    ORDER BY FechaFin DESC
    LIMIT 1;

    IF v_fechaFin IS NULL OR v_fechaFin < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El miembro no tiene membresía vigente.';
    END IF;

    -- Registrar asistencia
    INSERT INTO Asistencias(IdClase, IdMiembro)
    VALUES (p_IdClase, p_IdMiembro);
END $$

DELIMITER ;



-- =========================================================
--  PROCEDURE: sp_RenovarMembresia
--  Realiza transacción ACID:
--    1) Verifica pago >= costo
--    2) Inserta pago
--    3) Actualiza fecha fin
-- =========================================================
DELIMITER $$

CREATE PROCEDURE sp_RenovarMembresia(
    IN p_IdContrato INT,
    IN p_Monto DECIMAL(10,2)
)
BEGIN
    DECLARE v_costo DECIMAL(10,2);
    DECLARE v_duracion INT;

    START TRANSACTION;

    -- Obtener costo de membresía y duración
    SELECT m.Costo, m.DuracionDias INTO v_costo, v_duracion
    FROM Contratos c
    JOIN Membresias m ON m.IdMembresia = c.IdMembresia
    WHERE c.IdContrato = p_IdContrato;

    -- Validar monto
    IF p_Monto < v_costo THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El pago es insuficiente para renovar.';
    END IF;

    -- Registrar pago
    INSERT INTO Pagos(IdContrato, Monto)
    VALUES(p_IdContrato, p_Monto);

    -- Extender contrato
    UPDATE Contratos
    SET FechaFin = DATE_ADD(FechaFin, INTERVAL v_duracion DAY)
    WHERE IdContrato = p_IdContrato;

    COMMIT;
END $$

DELIMITER ;



-- =========================================================
--  TRIGGER: trg_after_delete_pago
--  Guarda pagos eliminados en tabla LogPagosEliminados
-- =========================================================
DELIMITER $$

CREATE TRIGGER trg_after_delete_pago
AFTER DELETE ON Pagos
FOR EACH ROW
BEGIN
    INSERT INTO LogPagosEliminados(
        IdPagoOriginal,
        IdContrato,
        Monto,
        FechaPago,
        UsuarioElim
    )
    VALUES (
        OLD.IdPago,
        OLD.IdContrato,
        OLD.Monto,
        OLD.FechaPago,
        USER()
    );
END $$

DELIMITER ;



-- =========================================================
--  TRIGGER: trg_before_insert_asistencia
--  Evita registrar asistencia con membresía vencida
-- =========================================================
DELIMITER $$

CREATE TRIGGER trg_before_insert_asistencia
BEFORE INSERT ON Asistencias
FOR EACH ROW
BEGIN
    DECLARE v_fechaFin DATE;

    SELECT FechaFin INTO v_fechaFin
    FROM Contratos
    WHERE IdMiembro = NEW.IdMiembro
    ORDER BY FechaFin DESC
    LIMIT 1;

    IF v_fechaFin < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Membresía expirada. No puede registrar asistencia.';
    END IF;
END $$

DELIMITER ;



-- =========================================================
--  VIEW: vw_OcupacionGimnasio
--  Clases con cantidad de inscritos
-- =========================================================
CREATE OR REPLACE VIEW vw_OcupacionGimnasio AS
SELECT 
    c.IdClase,
    c.NombreClase,
    e.Nombre AS Entrenador,
    c.CupoMaximo,
    COUNT(a.IdAsistencia) AS Inscritos
FROM Clases c
LEFT JOIN Entrenadores e ON e.IdEntrenador = c.IdEntrenador
LEFT JOIN Asistencias a  ON a.IdClase = c.IdClase
GROUP BY c.IdClase, c.NombreClase, e.Nombre, c.CupoMaximo;



-- =========================================================
--  VIEW: vw_Deudores
--  Miembros con contratos vencidos y sin pagos recientes
-- =========================================================
CREATE OR REPLACE VIEW vw_Deudores AS
SELECT 
    m.IdMiembro,
    m.Nombre,
    c.IdContrato,
    c.FechaFin
FROM Miembros m
JOIN Contratos c ON c.IdMiembro = m.IdMiembro
LEFT JOIN Pagos p 
    ON p.IdContrato = c.IdContrato
    AND p.FechaPago > c.FechaFin
WHERE c.FechaFin < CURDATE()
  AND p.IdPago IS NULL;



-- =========================================================
--  CTE: Top 3 clases más populares
--  (Ejecutar como consulta: no queda guardada)
-- =========================================================
-- Ejemplo de uso:
-- WITH TopClases AS (
--     SELECT IdClase, COUNT(*) AS total
--     FROM Asistencias
--     GROUP BY IdClase
--     ORDER BY total DESC
--     LIMIT 3
-- )
-- SELECT t.IdClase, c.NombreClase, t.total
-- FROM TopClases t
-- JOIN Clases c ON c.IdClase = t.IdClase;

