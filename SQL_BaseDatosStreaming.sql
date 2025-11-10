CREATE DATABASE BaseDatosStreaming;
GO
USE BaseDatosStreaming;

GO

-- Tabla Roles
CREATE TABLE Roles (
    IDRol INT PRIMARY KEY IDENTITY(1,1),
    Descripcion NVARCHAR(100) NOT NULL
);

-- Tabla Usuarios
CREATE TABLE Usuarios (
    IDUsuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Contraseña NVARCHAR(100) NOT NULL,
    FechaRegistro DATE NOT NULL DEFAULT GETDATE(),
    IDRol INT NOT NULL,
    FOREIGN KEY (IDRol) REFERENCES Roles(IDRol)
);

-- Tabla RolUsuarios
CREATE TABLE RolUsuario (
    IDUsuarioRol INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    IDRol INT NOT NULL,
    RolActivo BIT NOT NULL,
    FechaAsignacion DATETIME NOT NULL,
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario),
    FOREIGN KEY (IDRol) REFERENCES Roles(IDRol)
);


-- Tabla Géneros
CREATE TABLE Generos (
    IDGenero INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL
);

-- Tabla Contenidos
CREATE TABLE Contenidos (
    IDContenido INT PRIMARY KEY IDENTITY(1,1),
    Titulo NVARCHAR(100) NOT NULL,
    Sinopsis NVARCHAR(MAX),
    AñoLanzamiento INT NOT NULL,
    DuracionMinutos INT NOT NULL,
    TipoContenido NVARCHAR(20) NOT NULL, -- 'Película' o 'Serie'
    IDGenero INT NOT NULL,
    FOREIGN KEY (IDGenero) REFERENCES Generos(IDGenero)
);

-- Tabla Visualizaciones
CREATE TABLE Visualizaciones (
    IDVisualizacion INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    IDContenido INT NOT NULL,
    FechaVisualizacion DATETIME NOT NULL DEFAULT GETDATE(),
    Dispositivo NVARCHAR(50),
    Completado BIT NOT NULL,
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido)
);

-- Tabla Reseñas
CREATE TABLE Reseñas (
    IDReseña INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    IDContenido INT NOT NULL,
    Puntuacion INT CHECK (Puntuacion BETWEEN 1 AND 5),
    Comentario NVARCHAR(500),
    FechaReseña DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido)
);

-- Tabla Suscripciones
CREATE TABLE Suscripciones (
    IDSuscripcion INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    TipoSuscripcion NVARCHAR(20) NOT NULL, -- 'Gratuita', 'Estándar', 'Premium'
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    Estado NVARCHAR(20) NOT NULL, -- 'Activa', 'Vencida'
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
);

-- Tabla Actores
CREATE TABLE Actores (
    IDActor INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE
);

-- Tabla Directores
CREATE TABLE Directores (
    IDDirector INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE
);

-- Relación N:N entre Contenidos y Actores
CREATE TABLE ContenidoActor (
    IDContenido INT NOT NULL,
    IDActor INT NOT NULL,
    PRIMARY KEY (IDContenido, IDActor),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido),
    FOREIGN KEY (IDActor) REFERENCES Actores(IDActor)
);

-- Relación N:N entre Contenidos y Directores
CREATE TABLE ContenidoDirector (
    IDContenido INT NOT NULL,
    IDDirector INT NOT NULL,
    PRIMARY KEY (IDContenido, IDDirector),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido),
    FOREIGN KEY (IDDirector) REFERENCES Directores(IDDirector)
);

-- Tabla Listas
CREATE TABLE Listas (
    IDLista INT IDENTITY(1,1) PRIMARY KEY,  
    IDUsuario INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
);

-- Relación N:N entre Listas y Contenidos
CREATE TABLE ListaContenido (
    IDLista INT NOT NULL,
    IDContenido INT NOT NULL,
    PRIMARY KEY (IDLista, IDContenido),
    FOREIGN KEY (IDLista) REFERENCES Listas(IDLista),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido)
);

GO

------------------ para el 10/11 Agregados----------------------

------------------------- VISTAS --------------------------------
-- Vista 1: Contenidos más vistos
CREATE VIEW V_ContenidosMasVistos AS
SELECT C.IDContenido, C.Titulo, COUNT(V.IDVisualizacion) AS TotalVisualizaciones
FROM Contenidos C
JOIN Visualizaciones V ON C.IDContenido = V.IDContenido
GROUP BY C.IDContenido, C.Titulo;


GO

-- Vista 2: Contenidos mejor puntuados
CREATE VIEW vw_ContenidosMejorPuntuados AS
SELECT C.IDContenido, C.Titulo, AVG(R.Puntuacion) AS PromedioPuntuacion
FROM Contenidos C
JOIN Reseñas R ON C.IDContenido = R.IDContenido
GROUP BY C.IDContenido, C.Titulo

GO

-- Vista 3: Usuarios más activos
CREATE VIEW vw_UsuariosMasActivos AS
SELECT U.IDUsuario, U.Nombre, U.Apellido, COUNT(V.IDVisualizacion) AS TotalVisualizaciones
FROM Usuarios U
JOIN Visualizaciones V ON U.IDUsuario = V.IDUsuario
GROUP BY U.IDUsuario, U.Nombre, U.Apellido

GO

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

---------------------------------- TIGGERS ----------------------------------------

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

------------------------------------- FUNCIONES -------------------------------------

-- Función: Total de minutos vistos por usuario
CREATE FUNCTION fn_totalMinutosVistosPorUsuario (@IDUsuario INT)
RETURNS INT
AS
BEGIN
  DECLARE @Total INT;
  SELECT @Total = SUM(C.DuracionMinutos)
  FROM Visualizaciones V
  JOIN Contenidos C ON V.IDContenido = C.IDContenido
  WHERE V.IDUsuario = @IDUsuario;
  RETURN ISNULL(@Total, 0);
END;

GO

--------------------------- Proxima Revision 17/11 ---------------------------
--------------------- carga de daltos para pruebas INSERS --------------------

