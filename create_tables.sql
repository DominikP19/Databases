DROP TABLE Klienci CASCADE CONSTRAINTS; 
DROP TABLE Obsluga_prawna CASCADE CONSTRAINTS;
DROP TABLE Transakcje CASCADE CONSTRAINTS;
DROP TABLE Oferty CASCADE CONSTRAINTS;
DROP TABLE Nieruchomosci CASCADE CONSTRAINTS;
DROP TABLE Reklamy CASCADE CONSTRAINTS;
DROP TABLE Pracownicy CASCADE CONSTRAINTS;
DROP TABLE Reklamacje CASCADE CONSTRAINTS;
DROP TABLE Skutecznosc_reklam CASCADE CONSTRAINTS;


ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';

CREATE TABLE Klienci(
	ID_Klienta		INTEGER,
	Imie_Nazwisko	varchar2(80) NOT NULL,
	PESEL			number(11) NOT NULL,	/*zamienic na number*/
	Numer_tel		number(9) NOT NULL,	/*zamienic nie number*/
	Adres			varchar2(40),
	Kod_pocztowy	varchar2(6)
);
ALTER TABLE Klienci ADD CONSTRAINT klienci_pk PRIMARY KEY(ID_Klienta);

CREATE TABLE Obsluga_prawna(
	ID_Osoby			INTEGER,
	Imie_Nazwisko		varchar2(80) NOT NULL,
	Zawod				varchar2(40) NOT NULL,
	Wynagrodzenie_stale	NUMBER(10,2),
	Prowizja_proc		varchar2(3)
);
ALTER TABLE Obsluga_prawna ADD CONSTRAINT obsluga_prawna_pk PRIMARY KEY(ID_Osoby);

CREATE TABLE Pracownicy(
	ID_Pracownika	INTEGER,
	Imie_Nazwisko	varchar2(80) NOT NULL,
	Stanowisko		varchar2(40) NOT NULL,
	Wynagrodzenie	NUMBER(10,2)
);
ALTER TABLE Pracownicy ADD CONSTRAINT pracownicy_pk PRIMARY KEY(ID_Pracownika);

CREATE TABLE Nieruchomosci(
	ID_Nieruchomosci	INTEGER,
	Miasto				varchar2(40),
	Adres				varchar2(40),
	Kod_pocztowy		varchar2(6),
	Metraz				NUMBER(6),
	Wyposazenie			varchar2(300)
);
ALTER TABLE Nieruchomosci ADD CONSTRAINT nieruchomosci_pk PRIMARY KEY(ID_Nieruchomosci);

CREATE TABLE Oferty(
	ID_Oferty		INTEGER,
	FK_Nieruchomosc	INTEGER,
	Cena_ofertowa	NUMBER(10,2)
);
ALTER TABLE Oferty ADD CONSTRAINT oferty_pk PRIMARY KEY(ID_Oferty);
ALTER TABLE Oferty ADD CONSTRAINT oferty_fk1 FOREIGN KEY(FK_Nieruchomosc) REFERENCES Nieruchomosci(ID_Nieruchomosci) ON DELETE CASCADE;

CREATE TABLE Reklamy(
	ID_Reklamy		INTEGER,
	Cena_reklamy	NUMBER(4,2),
	Tresc_reklamy	varchar2(500),
	Umiejscowienie	varchar2(60),
	FK_Pracownik	INTEGER	/*pracownik odpowiedzialny za obsluge reklamy*/
);
ALTER TABLE Reklamy ADD CONSTRAINT reklamy_pk PRIMARY KEY(ID_Reklamy);
ALTER TABLE Reklamy ADD CONSTRAINT reklamy_fk1 FOREIGN KEY(FK_Pracownik) REFERENCES Pracownicy(ID_Pracownika) ON DELETE CASCADE;

/*tabela odpowiedajaca za polaczenie okreslonej reklamy z konkretna oferta nieruchomosci - jedna nieruchomosc moze byc oferowana 
za pomoca wielu reklam w wielu miejscach*/
CREATE TABLE Skutecznosc_reklam(
	ID_1				INTEGER,
	FK_Reklama		INTEGER,
	FK_Oferta		INTEGER
);
ALTER TABLE Skutecznosc_reklam ADD CONSTRAINT skutecznosc_reklam_pk PRIMARY KEY(ID_1);
ALTER TABLE Skutecznosc_reklam ADD CONSTRAINT skutecznosc_reklam_fk1 FOREIGN KEY(FK_Reklama) REFERENCES Reklamy(ID_Reklamy) ON DELETE CASCADE;
ALTER TABLE Skutecznosc_reklam ADD CONSTRAINT skutecznosc_reklam_fk2 FOREIGN KEY(FK_Oferta) REFERENCES Oferty(ID_Oferty) ON DELETE CASCADE;

CREATE TABLE Transakcje(
	ID_Transakcji		INTEGER,
	FK_Obsluga_prawna	INTEGER,
	FK_Kupujacy			INTEGER,
	FK_Sprzedajacy		INTEGER,
	FK_Pracownik		INTEGER,
	FK_Oferta			INTEGER
);
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_pk PRIMARY KEY(ID_Transakcji); 
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_fk1 FOREIGN KEY(FK_Obsluga_prawna) REFERENCES Obsluga_prawna(ID_Osoby) ON DELETE CASCADE;
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_fk2 FOREIGN KEY(FK_Kupujacy) REFERENCES Klienci(ID_Klienta) ON DELETE CASCADE;
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_fk3 FOREIGN KEY(FK_Sprzedajacy) REFERENCES Klienci(ID_Klienta) ON DELETE CASCADE;
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_fk4 FOREIGN KEY(FK_Pracownik) REFERENCES Pracownicy(ID_Pracownika) ON DELETE CASCADE;
ALTER TABLE Transakcje ADD CONSTRAINT transakcje_fk5 FOREIGN KEY(FK_Oferta) REFERENCES Oferty(ID_Oferty) ON DELETE CASCADE;

CREATE TABLE Reklamacje(
	ID_Reklamacji		INTEGER,
	Tresc_reklamacji	varchar2(500),
	FK_Transakcja		INTEGER,
	FK_Obslugujacy		INTEGER,
	FK_Pracownik		INTEGER,
	Data_wplyniecia		DATE,
	Data_zakonczenia	DATE
);
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_pk PRIMARY KEY(ID_Reklamacji);
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk1 FOREIGN KEY(FK_Transakcja) REFERENCES Transakcje(ID_Transakcji) ON DELETE CASCADE;
/*ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk2 FOREIGN KEY(FK_Nieruchomosc) REFERENCES Nieruchomosci(ID_Nieruchomosci);*/
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk3 FOREIGN KEY(FK_Obslugujacy) REFERENCES Obsluga_prawna(ID_Osoby) ON DELETE CASCADE;
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk4 FOREIGN KEY(FK_Pracownik) REFERENCES Pracownicy(ID_Pracownika) ON DELETE CASCADE;

