--- Task 2
BEGIN
USE universitatea;
DECLARE @DATE TABLE(Nume_Student NVARCHAR(100), Prenume_Student NVARCHAR(100), Nota INT);

INSERT INTO @DATE SELECT DISTINCT Nume_Student, Prenume_Student, Nota FROM dbo.studenti
	INNER JOIN dbo.studenti_reusita ON studenti_reusita.Id_Student = studenti.Id_Student
	INNER JOIN dbo.discipline ON discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
	WHERE Disciplina = 'Baze de date' AND Tip_Evaluare = 'Testul 1'

DECLARE @COUNTER INT = 0;
DECLARE @LEN INT;
DECLARE @CURRENT_NOTA INT;	
DECLARE @CURRENT_ROW TABLE(Nume_Student NVARCHAR(100), Prenume_Student NVARCHAR(100), Nota INT);
DECLARE @RESULT TABLE(Nume_Student NVARCHAR(100), Prenume_Student NVARCHAR(100), Nota INT);

SELECT @LEN = COUNT(*) FROM @DATE;

WHILE @COUNTER < @LEN
	BEGIN
	INSERT INTO @CURRENT_ROW SELECT * FROM @DATE ORDER BY Nume_Student OFFSET @COUNTER ROWS FETCH NEXT 1 ROW ONLY;
	SELECT @CURRENT_NOTA = Nota FROM @CURRENT_ROW

	IF @CURRENT_NOTA != 6 AND @CURRENT_NOTA != 8
		INSERT INTO @RESULT SELECT * FROM @CURRENT_ROW

	SET @COUNTER = @COUNTER + 1;
	DELETE @CURRENT_ROW
	END

SELECT TOP(10) Nume_Student, Prenume_Student, Nota FROM @RESULT ORDER BY Nota DESC
END