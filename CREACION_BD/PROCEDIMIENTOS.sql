---------------------------- PROCEDIMIENTOS ------------------------------

-- Procedimiento 1: Registrar visualización
CREATE PROCEDURE sp_RegistrarVisualizacion
  @IDUsuario INT,
  @IDContenido INT,
  @Dispositivo NVARCHAR(50),
  @Completado BIT
AS
BEGIN
  INSERT INTO Visualizaciones (IDUsuario, IDContenido, FechaVisualizacion, Dispositivo, Completado)
  VALUES (@IDUsuario, @IDContenido, GETDATE(), @Dispositivo, @Completado);
END;

GO

-- Procedimiento 2: Registrar reseña
CREATE PROCEDURE sp_RegistrarReseña
  @IDUsuario INT,
  @IDContenido INT,
  @Puntuacion INT,
  @Comentario NVARCHAR(500)
AS
BEGIN
  IF EXISTS (
    SELECT 1 FROM Visualizaciones
    WHERE IDUsuario = @IDUsuario AND IDContenido = @IDContenido
  )
  BEGIN
    INSERT INTO Reseñas (IDUsuario, IDContenido, Puntuacion, Comentario, FechaReseña)
    VALUES (@IDUsuario, @IDContenido, @Puntuacion, @Comentario, GETDATE());
  END
  ELSE
  BEGIN
    RAISERROR('El usuario no ha visualizado este contenido.', 16, 1);
  END
END;

GO

-- Procedimiento 3: Crear reporte de total de minutos y horas de consumo por usuario utilizando funcion
CREATE PROCEDURE sp_ReporteConsumoUsuario
    @IDUsuario INT
AS
BEGIN
    DECLARE @TotalMinutos INT;
    DECLARE @NombreCompleto NVARCHAR(100);
    DECLARE @TotalHoras DECIMAL(10,2);
    
    SELECT @NombreCompleto = Nombre + ' ' + Apellido 
    FROM Usuarios 
    WHERE IDUsuario = @IDUsuario;
    
    SET @TotalMinutos = dbo.fn_totalMinutosVistosPorUsuario(@IDUsuario);
    
    
    SET @TotalHoras = ROUND(@TotalMinutos * 1.0 / 60, 2);
    
    SELECT 
        @IDUsuario AS IDUsuario,
        @NombreCompleto AS Usuario,
        @TotalMinutos AS TotalMinutosVistos,
        @TotalHoras AS TotalHorasVistas;
END;