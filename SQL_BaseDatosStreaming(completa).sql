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
GO

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
--------------------- carga de datos para pruebas INSERTS --------------------
-- Roles
INSERT INTO Roles (Descripcion)
VALUES ('Administrador'), ('Usuario');

--  Usuarios
INSERT INTO Usuarios (Nombre, Apellido, Email, Contraseña, IDRol)
VALUES 
('Juan', 'Pérez', 'juan.perez@mail.com', '1234', 2),
('Ana', 'Gómez', 'ana.gomez@mail.com', 'abcd', 2),
('Carlos', 'Ramírez', 'carlos.ramirez@mail.com', 'pass123', 2),
('Lucía', 'Fernández', 'lucia.fernandez@mail.com', 'lucia2024', 2),
('María', 'López', 'maria.lopez@mail.com', 'admin', 1);

-- RolUsuario
INSERT INTO RolUsuario (IDUsuario, IDRol, RolActivo, FechaAsignacion)
VALUES
(1, 2, 1, GETDATE()),
(2, 2, 1, GETDATE()),
(3, 2, 1, GETDATE()),
(4, 2, 1, GETDATE()),
(5, 1, 1, GETDATE());

--  Géneros
INSERT INTO Generos (Nombre)
VALUES ('Acción'), ('Drama'), ('Comedia'), ('Sci-Fi'), ('Terror');

--  Contenidos 
INSERT INTO Contenidos (Titulo, Sinopsis, AñoLanzamiento, DuracionMinutos, TipoContenido, IDGenero)
VALUES 
('Inception', 'Un ladrón roba secretos infiltrándose en los sueños.', 2010, 148, 'Película', 4),
('Titanic', 'Una historia de amor en el fatídico viaje del Titanic.', 1997, 195, 'Película', 2),
('The Dark Knight', 'Batman enfrenta al Joker en una guerra por el alma de Gotham.', 2008, 152, 'Película', 1),
('Breaking Bad', 'Un profesor fabrica metanfetamina para asegurar el futuro de su familia.', 2008, 50, 'Serie', 2),
('Stranger Things', 'Un grupo de niños enfrenta fuerzas sobrenaturales en su ciudad.', 2016, 55, 'Serie', 4),
('Forrest Gump', 'Un hombre con un gran corazón vive momentos clave de la historia.', 1994, 142, 'Película', 2),
('The Godfather', 'La historia de la familia Corleone en el crimen organizado.', 1972, 175, 'Película', 1),
('The Office', 'La vida cotidiana de empleados en una oficina.', 2005, 25, 'Serie', 3),
('It', 'Un grupo de amigos enfrenta a una entidad maligna que adopta la forma de un payaso.', 2017, 135, 'Película', 5),
('Interstellar', 'Exploradores viajan por un agujero de gusano en busca de un nuevo hogar.', 2014, 169, 'Película', 4);

-- Directores
INSERT INTO Directores (Nombre, FechaNacimiento)
VALUES 
('Christopher Nolan', '1970-07-30'),
('James Cameron', '1954-08-16'),
('Francis Ford Coppola', '1939-04-07'),
('Vince Gilligan', '1967-02-10'),
('Robert Zemeckis', '1951-05-14'),
('Greg Daniels', '1963-06-13'),
('Andy Muschietti', '1973-08-26'),
('The Duffer Brothers', '1984-02-15');

-- Actores
INSERT INTO Actores (Nombre, FechaNacimiento)
VALUES 
('Leonardo DiCaprio', '1974-11-11'),
('Christian Bale', '1974-01-30'),
('Bryan Cranston', '1956-03-07'),
('Millie Bobby Brown', '2004-02-19'),
('Tom Hanks', '1956-07-09'),
('Marlon Brando', '1924-04-03'),
('Steve Carell', '1962-08-16'),
('Bill Skarsgård', '1990-08-09'),
('Matthew McConaughey', '1969-11-04'),
('Winona Ryder', '1971-10-29');

-- ContenidoDirector
INSERT INTO ContenidoDirector (IDContenido, IDDirector)
VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 4),
(5, 8),
(6, 5),
(7, 3),
(8, 6),
(9, 7),
(10, 1);

--  ContenidoActor
INSERT INTO ContenidoActor (IDContenido, IDActor)
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(5, 10),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9);

--  Suscripciones
INSERT INTO Suscripciones (IDUsuario, TipoSuscripcion, FechaInicio, FechaFin, Estado)
VALUES
(1, 'Premium', '2025-01-01', '2025-12-31', 'Activa'),
(2, 'Estándar', '2025-03-01', '2025-09-01', 'Vencida'),
(3, 'Gratuita', '2025-06-01', '2025-07-01', 'Vencida'),
(4, 'Premium', '2025-05-01', '2025-11-01', 'Activa'),
(5, 'Estándar', '2025-02-01', '2025-08-01', 'Vencida');

--  Visualizaciones
INSERT INTO Visualizaciones (IDUsuario, IDContenido, Dispositivo, Completado)
VALUES
(1, 1, 'Smart TV', 1),
(1, 2, 'Laptop', 1),
(2, 5, 'Tablet', 0),
(3, 3, 'Celular', 1),
(4, 10, 'Smart TV', 1),
(5, 6, 'Laptop', 1),
(2, 7, 'PC', 0),
(3, 8, 'Tablet', 1),
(4, 9, 'Celular', 0),
(1, 4, 'Smart TV', 1);

-- Reseñas
INSERT INTO Reseñas (IDUsuario, IDContenido, Puntuacion, Comentario)
VALUES
(1, 1, 5, 'Excelente película, muy original.'),
(2, 2, 4, 'Emotiva e impresionante.'),
(3, 3, 5, 'El mejor Batman.'),
(4, 5, 4, 'Gran historia y ambientación.'),
(5, 10, 5, 'Visualmente increíble.');

--  Listas
INSERT INTO Listas (IDUsuario, Nombre)
VALUES
(1, 'Favoritos de Juan'),
(2, 'Para ver después'),
(3, 'Mis dramas'),
(4, 'Ciencia ficción'),
(5, 'Clásicos imperdibles');

--  ListaContenido
INSERT INTO ListaContenido (IDLista, IDContenido)
VALUES
(1, 1),
(1, 3),
(2, 5),
(3, 2),
(3, 6),
(4, 10),
(5, 7),
(5, 9);


