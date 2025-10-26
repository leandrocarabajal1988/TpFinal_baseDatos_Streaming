CREATE DATABASE BaseDatosStreaming;
GO
USE BaseDatosStreaming;

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
    Contrase�a NVARCHAR(100) NOT NULL,
    FechaRegistro DATE NOT NULL DEFAULT GETDATE(),
    IDRol INT NOT NULL,
    FOREIGN KEY (IDRol) REFERENCES Roles(IDRol)
);

-- Tabla G�neros
CREATE TABLE Generos (
    IDGenero INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL
);

-- Tabla Contenidos
CREATE TABLE Contenidos (
    IDContenido INT PRIMARY KEY IDENTITY(1,1),
    Titulo NVARCHAR(100) NOT NULL,
    Sinopsis NVARCHAR(MAX),
    A�oLanzamiento INT NOT NULL,
    DuracionMinutos INT NOT NULL,
    TipoContenido NVARCHAR(20) NOT NULL, -- 'Pel�cula' o 'Serie'
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

-- Tabla Rese�as
CREATE TABLE Rese�as (
    IDRese�a INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    IDContenido INT NOT NULL,
    Puntuacion INT CHECK (Puntuacion BETWEEN 1 AND 5),
    Comentario NVARCHAR(500),
    FechaRese�a DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido)
);

-- Tabla Suscripciones
CREATE TABLE Suscripciones (
    IDSuscripcion INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT NOT NULL,
    TipoSuscripcion NVARCHAR(20) NOT NULL, -- 'Gratuita', 'Est�ndar', 'Premium'
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

-- Relaci�n N:N entre Contenidos y Actores
CREATE TABLE ContenidoActor (
    IDContenido INT NOT NULL,
    IDActor INT NOT NULL,
    PRIMARY KEY (IDContenido, IDActor),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido),
    FOREIGN KEY (IDActor) REFERENCES Actores(IDActor)
);

-- Relaci�n N:N entre Contenidos y Directores
CREATE TABLE ContenidoDirector (
    IDContenido INT NOT NULL,
    IDDirector INT NOT NULL,
    PRIMARY KEY (IDContenido, IDDirector),
    FOREIGN KEY (IDContenido) REFERENCES Contenidos(IDContenido),
    FOREIGN KEY (IDDirector) REFERENCES Directores(IDDirector)
);