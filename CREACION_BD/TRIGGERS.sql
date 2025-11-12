
---------------------------------- TRIGGERS ----------------------------------------

-- Trigger 1: Validar puntuación de reseña
CREATE TRIGGER trg_ValidarPuntuacionReseña
ON Reseñas
FOR INSERT
AS
BEGIN
  IF EXISTS (
    SELECT * FROM inserted WHERE Puntuacion < 1 OR Puntuacion > 5
  )
  BEGIN
    RAISERROR('La puntuación debe estar entre 1 y 5.', 16, 1);
    ROLLBACK;
  END
END;

GO

-- Trigger 2: Actualizar estado de suscripción
CREATE TRIGGER trg_ActualizarEstadoSuscripcion
ON Suscripciones
AFTER INSERT, UPDATE
AS
BEGIN
  UPDATE S
  SET Estado = 'Vencida'
  FROM Suscripciones S
  WHERE S.FechaFin < GETDATE() AND S.Estado <> 'Vencida';
END;

GO

-- Trigger 3: Bloquear reseñas duplicadas
CREATE TRIGGER trg_BloquearReseñasDuplicadas
ON Reseñas
INSTEAD OF INSERT
AS
BEGIN
  IF EXISTS (
    SELECT 1
    FROM Reseñas R
    JOIN inserted I ON R.IDUsuario = I.IDUsuario AND R.IDContenido = I.IDContenido
  )
  BEGIN
    RAISERROR('Ya existe una reseña para este contenido por este usuario.', 16, 1);
    RETURN;
  END

  INSERT INTO Reseñas (IDUsuario, IDContenido, Puntuacion, Comentario, FechaReseña)
  SELECT IDUsuario, IDContenido, Puntuacion, Comentario, FechaReseña
  FROM inserted;
END;

GO

-- Trigger 4: Evita eliminacion de usuarios con suscripción activa
CREATE TRIGGER trg_BloquearEliminacionUsuarioConSuscripcion
ON Usuarios
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted D
        JOIN Suscripciones S ON D.IDUsuario = S.IDUsuario
        WHERE S.Estado = 'Activa'
    )
    BEGIN
        RAISERROR('No se puede eliminar un usuario con una suscripción activa.', 16, 1);
        RETURN;
    END

    DELETE FROM Usuarios
    WHERE IDUsuario IN (SELECT IDUsuario FROM deleted);
END;
