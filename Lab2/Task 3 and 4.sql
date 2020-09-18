USE universitatea;

CREATE TABLE discipline (
	Id_Disciplina INT NOT NULL IDENTITY(100, 1),
	Disciplina NVARCHAR(200) NOT NULL,
	Nr_ore_plan_disciplina INT NOT NULL,
	CONSTRAINT PK_discipline
		PRIMARY KEY(Id_Disciplina)
);

GO

CREATE TABLE grupe (
	Id_Grupa INT NOT NULL IDENTITY(1, 1),
	Cod_Grupa NVARCHAR(200) NOT NULL,
	Specialitate NVARCHAR(200) NOT NULL,
	Nume_Facultate NVARCHAR(200) NOT NULL,
	CONSTRAINT PK_grupe
		PRIMARY KEY(Id_Grupa)
);

GO

INSERT INTO dbo.discipline VALUES
	('Sisteme de operare', 60),
	('Programarea calculatoarelor', 60),
	('Informatica aplicata', 46),
	('Sisteme de calcul', 46),
	('Asablare si depanare PC', 60),
	('Cercetari operationale', 76),
	('Programarea WEB', 46),
	('Baze de date', 60),
	('Structuri de date si algoritmi', 76),
	('Retele informatice', 46),
	('Matematica discreta', 60),
	('Modelarea sistemelor', 46),
	('Limbaje evaluate de programare', 76),
	('Programarea aplicatiilor Windows', 60),
	('Tehnologii de procesare a informatiei', 46),
	('Programarea declarativa', 46),
	('Proectarea sistemelor informatice', 60),
	('Practica de licenta', 80),
	('Practica de productie', 80),
	('Integrare informationala europeana', 20),
	('Programe aplicative', 46);

GO

SELECT * FROM dbo.discipline;

GO


INSERT INTO dbo.grupe VALUES
	('CIB171', 'Cibernetica', 'Informatica si Cibernetica'),
	('INF171', 'Informatica', 'Informatica si Cibernetica'),
	('TI171', 'Tehnologii Informationale', 'Informatica si Cibernetica');

GO

SELECT * FROM dbo.grupe

GO

EXEC sp_rename 'discipline', 'disc'

GO