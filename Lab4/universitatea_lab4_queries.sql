use universitatea;

/* 1 */
SELECT * FROM dbo.grupe;

GO

/* 2 */
SELECT Disciplina, Nr_ore_plan_disciplina FROM dbo.discipline
	ORDER BY Nr_ore_plan_disciplina DESC;

GO

/* 3 */
SELECT DISTINCT Disciplina, Nume_Profesor, Prenume_Profesor FROM dbo.discipline 
	INNER JOIN dbo.studenti_reusita ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
	INNER JOIN dbo.profesori ON dbo.studenti_reusita.Id_Profesor = dbo.profesori.Id_Profesor
	ORDER BY Nume_Profesor DESC, Prenume_Profesor DESC;

GO

/* 4 */
SELECT Disciplina FROM dbo.discipline
	WHERE LEN(Disciplina) > 20

GO

/* 5 */
SELECT Nume_Student FROM dbo.studenti
	WHERE Nume_Student LIKE '%u'

GO

/* 6 */
SELECT DISTINCT TOP (5) WITH TIES Nume_Student, Prenume_Student, Nota FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
									AND dbo.discipline.Disciplina = 'Baze de date'
WHERE dbo.studenti_reusita.Tip_Evaluare = 'Testul 2'
ORDER BY dbo.studenti_reusita.Nota DESC

GO

/* 7 */
SELECT DISTINCT Cod_Grupa, Adresa_Postala_Student FROM dbo.grupe
INNER JOIN dbo.studenti_reusita ON dbo.grupe.Id_Grupa = dbo.studenti_reusita.Id_Grupa
INNER JOIN dbo.studenti ON dbo.studenti_reusita.Id_Student = dbo.studenti.Id_Student
WHERE Adresa_Postala_Student LIKE '%31 August%'

GO

/* 8 */
SELECT DISTINCT dbo.studenti.Id_Student AS Id_student, Nume_Student, Prenume_Student FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
WHERE YEAR(Data_Evaluare) = 2018

GO

/* 9 */
SELECT DISTINCT Nume_Student, Adresa_Postala_Student, Id_Disciplina as Cod_disciplina FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
WHERE YEAR(Data_Evaluare) = 2018 AND Nota > 8 AND Tip_Evaluare = 'Reusita curenta'

GO

/* 10 */
SELECT DISTINCT Nume_Student, Prenume_Student, Nota FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
									AND dbo.discipline.Disciplina = 'Baze de date'
WHERE YEAR(Data_Evaluare) = 2018 AND Nota BETWEEN 4 AND 8

GO

/* 11 */
SELECT DISTINCT Nume_Profesor, Prenume_Profesor FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.discipline ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
									AND dbo.discipline.Disciplina = 'Baze de date'
WHERE Tip_Evaluare = 'Reusita curenta' AND Nota < 5

GO

/* 12 */
SELECT DISTINCT Nume_Student, Prenume_Student, Disciplina, Nota, YEAR(Data_Evaluare) as Anul FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
WHERE Tip_Evaluare = 'Reusita curenta' AND Prenume_Student = 'Alex'

GO


/* 13 */
SELECT DISTINCT Disciplina FROM dbo.discipline
INNER JOIN dbo.studenti_reusita ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
INNER JOIN dbo.studenti ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
WHERE Nume_Student = 'Florea' AND Prenume_Student = 'Ioan'

GO

/* 14 */
SELECT DISTINCT Nume_Student, Prenume_Student, Disciplina FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.studenti_reusita.Id_Disciplina = dbo.discipline.Id_Disciplina 
WHERE Tip_Evaluare = 'Examen' AND Nota > 8

GO

/* 15 */
SELECT Nume_Student, Prenume_Student FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.profesori ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
WHERE YEAR(Data_Evaluare) = 2017 AND Nota > 4
GROUP BY Nume_Student, Prenume_Student
HAVING STRING_AGG(Prenume_Profesor, ' ') LIKE '%Ion%' AND STRING_AGG(Prenume_Profesor, ' ') LIKE '%George%'

GO

/* 16 */
SELECT DISTINCT Nume_Student, Prenume_Student, Id_Profesor FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
WHERE Nr_ore_plan_disciplina < 60

GO

/* 17 */
SELECT DISTINCT Nume_Profesor, Prenume_Profesor FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.studenti ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
							AND dbo.studenti_reusita.Id_Student = 100

GO

/* 18 */
SELECT DISTINCT Nume_Profesor, Prenume_Profesor FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
GROUP BY Nume_Profesor, Prenume_Profesor
HAVING Nume_Profesor NOT IN (
	SELECT Nume_Profesor FROM dbo.profesori
	INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
	INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
	WHERE Nr_ore_plan_disciplina > 60
)

GO

SELECT DISTINCT Nume_Profesor, Prenume_Profesor, Disciplina FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina

/* 19 */
SELECT DISTINCT Nume_Profesor, Prenume_Profesor FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
INNER JOIN dbo.studenti ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
WHERE Nume_Student = 'Cosovanu' AND Disciplina IN (
	SELECT Disciplina FROM dbo.discipline
	INNER JOIN dbo.studenti_reusita ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
	INNER JOIN dbo.studenti ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
	WHERE Nume_Student = 'Cosovanu' AND Nota < 5
)

/* 20 */
SELECT DISTINCT Nume_Student, Prenume_Student FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
								AND dbo.discipline.Disciplina = 'Baze de date'
WHERE YEAR(Data_Evaluare) = 2018

GO

/* 21 */
SELECT Nume_Student, Prenume_Student, COUNT(Nota) AS Nr_de_Note FROM dbo.studenti
INNER JOIN dbo.studenti_reusita ON dbo.studenti.Id_Student = dbo.studenti_reusita.Id_Student
GROUP BY Nume_Student, Prenume_Student

GO

/* 22 */
SELECT Nume_Profesor, Prenume_Profesor, COUNT(DISTINCT Disciplina) as Nr_de_Discipline FROM dbo.profesori
INNER JOIN dbo.studenti_reusita ON dbo.profesori.Id_Profesor = dbo.studenti_reusita.Id_Profesor
INNER JOIN dbo.discipline ON dbo.discipline.Id_Disciplina = dbo.studenti_reusita.Id_Disciplina
GROUP BY dbo.profesori.Nume_Profesor, dbo.profesori.Prenume_Profesor