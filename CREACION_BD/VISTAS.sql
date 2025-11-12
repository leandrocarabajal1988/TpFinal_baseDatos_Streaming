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
