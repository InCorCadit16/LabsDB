USE universitatea;

/* Task 1 */
BEGIN

UPDATE profesori 
SET Adresa_Postala_Profesor = 'mun. Chisinau' 
WHERE Adresa_Postala_Profesor IS NULL

SELECT * FROM profesori

END


/* Task 2 */
BEGIN

ALTER TABLE grupe
ALTER COLUMN Cod_Grupa VARCHAR(255) NOT NULL

ALTER TABLE grupe
ADD CONSTRAINT UQ_Cod_Grupa UNIQUE (Cod_Grupa)

ALTER TABLE grupe
ADD CONSTRAINT PK_grupe PRIMARY KEY (Id_Grupa)

SELECT * FROM  grupe

END


/* Task 3 */
BEGIN

ALTER TABLE grupe
ADD Sef_grupa INT

ALTER TABLE grupe
ADD CONSTRAINT UQ_Sef_Grupa UNIQUE (Sef_Grupa)

ALTER TABLE grupe
ADD Prof_Indrumator INT

UPDATE grupe 
SET Sef_grupa = (SELECT TOP(1) Id_Student, Id_Grupa FROM studenti_reusita
					WHERE studenti_reusita.Id_Grupa = grupe.Id_Grupa
					GROUP BY Id_Student
					ORDER BY SUM(Nota) DESC)

UPDATE grupe
SET Prof_Indrumator = (SELECT TOP(1) Id_Profesor FROM (SELECT TOP(1000) Id_Profesor FROM studenti_reusita
															WHERE studenti_reusita.Id_Grupa = grupe.Id_Grupa
															GROUP BY Id_Profesor, Id_Grupa
															ORDER BY COUNT(DISTINCT Id_Disciplina) DESC, Id_Profesor DESC) AS temp)


SELECT * FROM  grupe

END

/* Task 4 */
BEGIN

UPDATE studenti_reusita
SET Nota = Nota + 1
WHERE Nota < 10 AND Id_Student IN (SELECT Sef_grupa FROM grupe)

END


/* Task 5 */
GO

CREATE FUNCTION dbo.GetEnd (@STRING AS VARCHAR(255), @SEGMENT AS INT)
	RETURNS INT
	BEGIN
		DECLARE @END INT 
		
		IF @SEGMENT = 1
			BEGIN
				IF (CHARINDEX(', ', @STRING) != 0) 
					SET @END = CHARINDEX(', ', @STRING)
				ELSE 
					SET @END = LEN(@STRING) + 1
			END
		ELSE IF @SEGMENT = 2
			BEGIN
				IF (CHARINDEX(', ', @STRING) != 0) 
					SET @END = CHARINDEX(', ', @STRING, CHARINDEX(', ', @STRING) + 2) - CHARINDEX(', ', @STRING) - 2
				ELSE 
					SET @END = 0
			END
		ELSE IF @SEGMENT = 3
			BEGIN
				IF (CHARINDEX(', ', @STRING) != 0) 
					SET @END = LEN(@STRING) - CHARINDEX(', ', @STRING, CHARINDEX(', ', @STRING) + 2) - 1
				ELSE 
					SET @END = 0
			END

		RETURN @END;
	END
	
GO

CREATE FUNCTION dbo.GetStart (@STRING AS VARCHAR(255), @SEGMENT AS INT)
	RETURNS INT
	BEGIN
		DECLARE @START INT 
		
		IF @SEGMENT = 1
			SET @START = 0
		ELSE IF @SEGMENT = 2
			BEGIN
				IF (CHARINDEX(', ', @STRING) != 0) 
					SET @START = CHARINDEX(', ', @STRING) + 2
				ELSE 
					SET @START = 0
			END
		ELSE IF @SEGMENT = 3
			BEGIN
				IF (CHARINDEX(', ', @STRING) != 0) 
					SET @START = CHARINDEX(', ', @STRING, CHARINDEX(', ', @STRING) + 1) + 2
				ELSE 
					SET @START = 0
			END

		RETURN @START;
	END
	
GO
-- delete function  
DROP FUNCTION dbo.GetEnd;  
DROP FUNCTION dbo.GetStart; 
GO

BEGIN

CREATE TABLE profesori_new (
Id_Profesor INT,
Nume_Profesor VARCHAR,
Prenume_Profesor VARCHAR,
Localitate VARCHAR DEFAULT('Mun. Chisinau'),
Adresa_1 VARCHAR,
Adresa_2 VARCHAR,
)

CREATE CLUSTERED INDEX profesori_new_PK_index
ON profesori_new(Id_Profesor)


SELECT
	Id_Profesor,
	Nume_Profesor,
	Prenume_Profesor,
    SUBSTRING(Adresa_Postala_Profesor, dbo.GetStart(Adresa_Postala_Profesor, 1), dbo.GetEnd(Adresa_Postala_Profesor, 1)) as Localitate,
	SUBSTRING(Adresa_Postala_Profesor, dbo.GetStart(Adresa_Postala_Profesor, 2), dbo.GetEnd(Adresa_Postala_Profesor, 2)) as Adresa_1,
	SUBSTRING(Adresa_Postala_Profesor, dbo.GetStart(Adresa_Postala_Profesor, 3), dbo.GetEnd(Adresa_Postala_Profesor, 3)) as Adresa_2
	INTO profesori_new
	FROM profesori

select * from profesori_new

END

/* Task 6 */
GO
DROP TABLE IF EXISTS orarul;
CREATE TABLE orarul (
Id_Disciplina INT,
Id_Profesor INT,
Id_Grupa INT,
Zi VARCHAR(10),
Ora TIME,
Auditoriu INT,
Bloc VARCHAR)

GO

INSERT INTO orarul VALUES 
	(107, 101, 1, 'Luni', '08:00', 202, 'B'),
	(108, 101, 1, 'Luni', '11:30', 501, 'B'),
	(119, 117, 1, 'Luni', '13:00', 501, 'B')

SELECT * FROM orarul
GO

/* Task 7 */
INSERT INTO orarul 
	SELECT Id_Disciplina,
		(SELECT Id_Profesor FROM profesori WHERE Nume_Profesor = 'Bivol' AND Prenume_Profesor = 'Ion') AS Id_Profesor,
		(SELECT TOP(1) Id_Grupa FROM grupe WHERE Cod_Grupa = 'INF171')  AS Id_Grupa,
		'Luni' as Zi, '08:00' as Ora, 202 as Auditoriu, 'B' as Bloc 
		FROM discipline WHERE Disciplina = 'Structuri de date si algoritmi';

INSERT INTO orarul 
	SELECT Id_Disciplina,
		(SELECT Id_Profesor FROM profesori WHERE Nume_Profesor = 'Mircea' AND Prenume_Profesor = 'Sorin') AS Id_Profesor,
		(SELECT TOP(1) Id_Grupa FROM grupe WHERE Cod_Grupa = 'INF171')  AS Id_Grupa,
		'Luni' as Zi, '11:30' as Ora, 202 as Auditoriu, 'B' as Bloc 
		FROM discipline WHERE Disciplina = 'Programe aplicative';

INSERT INTO orarul 
	SELECT Id_Disciplina,
		(SELECT Id_Profesor FROM profesori WHERE Nume_Profesor = 'Micu' AND Prenume_Profesor = 'Elena') AS Id_Profesor,
		(SELECT TOP(1) Id_Grupa FROM grupe WHERE Cod_Grupa = 'INF171')  AS Id_Grupa,
		'Luni' as Zi, '13:00' as Ora, 202 as Auditoriu, 'B' as Bloc 
		FROM discipline WHERE Disciplina = 'Baze de date';

SELECT * FROM orarul

GO

/* Task 8 */
CREATE NONCLUSTERED COLUMNSTORE INDEX non_clust_discpline 
ON studenti(Id_Student, Nume_Student, Prenume_Student)
WITH (DATA_COMPRESSION=COLUMNSTORE) ON userdatafgroup01

CREATE NONCLUSTERED COLUMNSTORE INDEX non_clust_discpline 
ON studenti_reusita(Id_Student, Nota)
WITH (DATA_COMPRESSION=COLUMNSTORE) ON userdatafgroup01


SELECT Nume_Student, Prenume_Student, COUNT(Nota) AS Nr_de_Note FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
GROUP BY Nume_Student, Prenume_Student