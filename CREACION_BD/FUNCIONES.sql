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
