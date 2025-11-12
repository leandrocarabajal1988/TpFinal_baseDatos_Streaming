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
