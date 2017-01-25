/*
Autor: Dominik Piliszek-Slowinski
*/
DROP TABLE Klienci CASCADE CONSTRAINTS; 
DROP TRIGGER Klienci_trigger;
DROP SEQUENCE Klienci_seq;
DROP TABLE Obsluga_prawna CASCADE CONSTRAINTS;
DROP SEQUENCE Obsluga_prawna_seq;
DROP TABLE Transakcje CASCADE CONSTRAINTS;
DROP SEQUENCE Transakcje_seq;
DROP TABLE Oferty CASCADE CONSTRAINTS;
/*DROP SEQUENCE Oferty_seq;*/
DROP TABLE Nieruchomosci CASCADE CONSTRAINTS;
/*DROP SEQUENCE Nieruchomosci_seq;*/
DROP TABLE Reklamy CASCADE CONSTRAINTS;
/*DROP SEQUENCE Reklamy_seq;*/
DROP TABLE Pracownicy CASCADE CONSTRAINTS;
/*DROP SEQUENCE Pracownicy_seq;*/
DROP TABLE Reklamacje CASCADE CONSTRAINTS;
/*DROP SEQUENCE Reklamacje_seq;*/
DROP TABLE Skutecznosc_reklam CASCADE CONSTRAINTS;
/*DROP SEQUENCE Skutecznosc_reklam_seq;*/

ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';

CREATE TABLE Klienci(
	ID_Klienta		INTEGER,
	Imie_Nazwisko	varchar2(80) NOT NULL,
	PESEL			varchar2(11) NOT NULL,	/*zamienic na number*/
	Numer_tel		varchar2(9) NOT NULL,	/*zamienic nie number*/
	Adres			varchar2(40),
	Kod_pocztowy	varchar2(6)
);

/* sekwencja i trigger inkrementujacy klucz glowny*/
CREATE SEQUENCE Klienci_seq;
CREATE OR REPLACE TRIGGER Klienci_trigger
BEFORE INSERT ON Klienci
FOR EACH ROW
BEGIN
	:NEW.ID_Klienta := klienci_seq.NEXTVAL;
END;

ALTER TABLE Klienci ADD CONSTRAINT klienci_pk PRIMARY KEY(ID_Klienta);


/**/
CREATE OR REPLACE PROCEDURE Klienci_gen AS
	Ilosc NUMBER(10);
	TYPE TABSTR IS TABLE OF varchar2(80); /*dodac typ number dla pesel i numer tel*/
	Imie_Nazwisko TABSTR;
	/*PESEL TABSTR;*/
	/*Numer_tel TABSTR;*/
	Adres TABSTR;
	Kod_pocztowy TABSTR;
	Telefon NUMBER(9);
	PESEL NUMBER(11);
	Ilosc_imion NUMBER(10);
	/*Ilosc_PESELI NUMBER(10);*/
	/*Ilosc_tel NUMBER(10);*/
	Ilosc_adresow NUMBER(10);
	Ilosc_kodow NUMBER(10);
	Losowe_imie NUMBER(10);
	/*Losowy_PESEL NUMBER(10);*/
	/*Losowy_tel NUMBER(10);*/
	Losowy_adres NUMBER(10);
	Losowy_kod NUMBER(10);
BEGIN
	Ilosc:= 1000;
	Imie_Nazwisko := TABSTR('Andrzej Nowak', 'Jan Kowalski', 'Andzelika Nowak', 'Janina Kowalska', 'Jakub Adamczyk', 'Marek Marecki', 'Maciej Maciejewski', 
	'Andrzej Andrzejewski', 'Agnieszka Kowalska', 'Barbara Bak', 'Czeslawa Milosz', 'Nikola Kopernik', 'Maria Sklodowska', 'Britney Spears');
	Ilosc_imion := 14;
	Adres := TABSTR('Mordor 1', 'Bananowa 123', 'Anielska 666', 'al. Cudow 2', 'Cebulowa 44', 'Golebia 55', 'Zalesie 167', 'Chmielna 33', 'Pszczyna Avenue 22');
	Ilosc_adresow :=9;
	Kod_pocztowy := TABSTR('00-001', '66-666', '22-123', '01-234', '02-654', '87-987', '55-654', '45-321', '00-333');
	Ilosc_kodow :=9;
	
	FOR i IN 1..Ilosc LOOP
			Losowe_imie := dbms_random.VALUE(1,Ilosc_imion);
			Losowy_adres := dbms_random.VALUE(1,Ilosc_adresow);
			Losowy_kod := dbms_random.VALUE(1,Ilosc_kodow);
			Telefon := dbms_random.VALUE(100000000, 999999999);
			PESEL := dbms_random.VALUE(1000000000, 9999999999);
			INSERT INTO Klienci VALUES (NULL, Imie_Nazwisko(Losowe_imie), to_char(PESEL),  /*to_ char potencjalnie problematyczne*/
			to_char(Telefon), Adres(Losowy_adres), Kod_pocztowy(Losowy_kod));
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano klientow!');
END Klienci_gen;

DELETE FROM Klienci;
Execute Klienci_gen();

/*SELECT * FROM Klienci;  //sprawdzenie czy wszystko si?odalo */

CREATE TABLE Obsluga_prawna(
	ID_Osoby			INTEGER,
	Imie_Nazwisko		varchar2(80) NOT NULL,
	Zawod				varchar2(40) NOT NULL,
	Wynagrodzenie_stale	NUMBER(10,2),
	Prowizja_proc		varchar2(3)
);

CREATE SEQUENCE Obsluga_prawna_seq;
CREATE OR REPLACE TRIGGER Obsluga_prawna_trigger
BEFORE INSERT ON Obsluga_prawna
FOR EACH ROW
BEGIN
	:NEW.ID_Osoby := Obsluga_prawna_seq.NEXTVAL;
END;

ALTER TABLE Obsluga_prawna ADD CONSTRAINT obsluga_prawna_pk PRIMARY KEY(ID_Osoby);

CREATE OR REPLACE PROCEDURE Obsluga_prawna_gen AS
	Ilosc NUMBER(10);
	TYPE TABSTR IS TABLE OF varchar2(80); 
	Imie_Nazwisko TABSTR;
	Zawod TABSTR;
	Wynagrodzenie_stale NUMBER(10,2);
	Prowizja_proc NUMBER(3);
	Ilosc_imion NUMBER(10);
	Ilosc_zawodow NUMBER(10);
	Losowe_imie NUMBER(10);
	Losowy_zawod NUMBER(10);
BEGIN
	Ilosc:= 50;
	Imie_Nazwisko := TABSTR('Andrzej Nowak', 'Jan Kowalski', 'Andzelika Nowak', 'Janina Kowalska', 'Jakub Adamczyk', 'Marek Marecki', 'Maciej Maciejewski', 
	'Andrzej Andrzejewski', 'Agnieszka Kowalska', 'Barbara Bak', 'Czeslawa Milosz', 'Nikola Kopernik', 'Maria Sklodowska', 'Britney Spears');
	Ilosc_imion := 14;
	Zawod := TABSTR('Prawnik', 'Radca prawny', 'Asesor', 'Adwokat', 'Emerytowany prokurator', 'Komornik', 'Osilek wykonujacy eksmisje na bruk');
	Ilosc_zawodow :=  7;
	
	FOR i IN 1..Ilosc LOOP
			Losowe_imie := dbms_random.VALUE(1,Ilosc_imion);
			Losowy_zawod := dbms_random.VALUE(1,Ilosc_zawodow);
			Wynagrodzenie_stale := dbms_random.VALUE(3000, 150000);
			Prowizja_proc := dbms_random.VALUE(1, 5);
			/*PESEL := dbms_random.VALUE(10000000000, 99999999999);*/
			INSERT INTO Obsluga_prawna VALUES (NULL, Imie_Nazwisko(Losowe_imie), Zawod(Losowy_zawod), 
			Wynagrodzenie_stale, Prowizja_proc);
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano Obsluge prawna!');
END Obsluga_prawna_gen;

DELETE FROM Obsluga_prawna;
Execute Obsluga_prawna_gen();

/*SELECT * FROM Obsluga_prawna;  //sprawdzenie czy wszystko si?odalo */


CREATE TABLE Pracownicy(
	ID_Pracownika	INTEGER,
	Imie_Nazwisko	varchar2(80) NOT NULL,
	Stanowisko		varchar2(40) NOT NULL,
	Wynagrodzenie	NUMBER(10,2)
);

/*sekwencja z triggerem dodajaca id do kazdego rekordu*/
CREATE SEQUENCE Pracownicy_seq;
CREATE OR REPLACE TRIGGER Pracownicy_trigger
BEFORE INSERT ON Pracownicy
FOR EACH ROW
BEGIN
	:NEW.ID_Pracownika := Pracownicy_seq.NEXTVAL;
END;

ALTER TABLE Pracownicy ADD CONSTRAINT pracownicy_pk PRIMARY KEY(ID_Pracownika);

CREATE OR REPLACE PROCEDURE Pracownicy_gen AS
	Ilosc NUMBER(10);
	TYPE TABSTR IS TABLE OF varchar2(80); 
	Imie_Nazwisko TABSTR;
	Zawod TABSTR;
	Wynagrodzenie_stale NUMBER(10,2);
	Ilosc_imion NUMBER(10);
	Ilosc_zawodow NUMBER(10);
	Losowe_imie NUMBER(10);
	Losowy_zawod NUMBER(10);
BEGIN
	Ilosc:= 50;
	Imie_Nazwisko := TABSTR('Boguslaw Linda', 'Jan Kowalski', 'Kamil Stoch', 'Janina Kowalska', 'Adam Malysz', 'Marek Marecki', 'Maciej Maciejewski', 
	'Michal Pazdan', 'Agnieszka Kowalska', 'Anita Wlodarczyk', 'Czeslawa Milosz', 'Nikola Kopernik', 'Maria Sklodowska', 'Robert Lewandowski');
	Ilosc_imion := 14;
	Zawod := TABSTR('Pracownik biurowy', 'Sprzatanie', 'Prawnik', 'Adwokat', 'Licencjonowany agent', 'Student na stazu', 'Public Relations');
	Ilosc_zawodow :=  7;
	
	FOR i IN 1..Ilosc LOOP
			Losowe_imie := dbms_random.VALUE(1,Ilosc_imion);
			Losowy_zawod := dbms_random.VALUE(1,Ilosc_zawodow);
			Wynagrodzenie_stale := dbms_random.VALUE(3000, 15000);
			INSERT INTO Pracownicy VALUES (NULL, Imie_Nazwisko(Losowe_imie), Zawod(Losowy_zawod), 
			Wynagrodzenie_stale);
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano rekordy do tabeli Pracownicy!');
END Pracownicy_gen;

DELETE FROM Pracownicy;
Execute Pracownicy_gen();


CREATE TABLE Nieruchomosci(
	ID_Nieruchomosci	INTEGER,
	Miasto				varchar2(40),
	Adres				varchar2(40),
	Kod_pocztowy		varchar2(6),
	Metraz				NUMBER(6),
	Wyposazenie			varchar2(300)
);

CREATE SEQUENCE Nieruchomosci_seq;
CREATE OR REPLACE TRIGGER Nieruchomosci_trigger
BEFORE INSERT ON Nieruchomosci
FOR EACH ROW
BEGIN
	:NEW.ID_Nieruchomosci := Nieruchomosci_seq.NEXTVAL;
END;

ALTER TABLE Nieruchomosci ADD CONSTRAINT nieruchomosci_pk PRIMARY KEY(ID_Nieruchomosci);

CREATE OR REPLACE PROCEDURE Nieruchomosci_gen AS
	Ilosc NUMBER(10);
	TYPE TABSTR IS TABLE OF varchar2(80); /*dodac typ number dla pesel i numer tel*/
	Adres TABSTR;
	Kod_pocztowy TABSTR;
  Miasto TABSTR;
	Metraz NUMBER(6);
	Wyposazenie TABSTR;
	Ilosc_wyposazen NUMBER(10);
	Ilosc_miast NUMBER(10);
	Ilosc_adresow NUMBER(10);
	Ilosc_kodow NUMBER(10);
	Losowe_miasto NUMBER(10);
	Losowy_adres NUMBER(10);
	Losowy_kod NUMBER(10);
  Losowe_wyposazenie NUMBER(10);
BEGIN
	Ilosc:= 1000;
	Adres := TABSTR('Mordor 1', 'Bananowa 123', 'Anielska 666', 'al. Cudow 2', 'Cebulowa 44', 'Golebia 55', 'Zalesie 167', 'Chmielna 33', 'Pszczyna Avenue 22');
	Ilosc_adresow :=9;
	Kod_pocztowy := TABSTR('00-001', '66-666', '22-123', '01-234', '02-654', '87-987', '55-654', '45-321', '00-333');
	Ilosc_kodow :=9;
  Miasto := TABSTR('Warszawa', 'Krakow', 'Gdansk', 'Poznan', 'Lodz', 'Szczecin', 'Bialystok', 'Rzeszow', 'Bydgoszcz', 'Torun', 'Plock',
  'Radom', 'Gorzow Wielkopolski', 'Olsztyn', 'Lublin', 'Wroclaw', 'Katowice', 'Kielce', 'Czestochowa');
  Ilosc_miast := 19;
  Wyposazenie := TABSTR('Niski standard - mieszkanie socjlane', 'Niski standard - 50 letni dom do remontu', 'Sredni standard - mieszkanie w bloku z wielkiej plyty, odnowione',
  'Sredni standard - dom z poczatku lat 90', 'Sredni standard - niewielki domek z ogrodkiem niedaleko miasta', 'Wysoki standard - apartament w dobrej lokalizacji',
  'Wysoki standard - Willa pod miastem z duzym ogrodem', 'Wysoki standard - Dom letniskowy w pieknej scenerii, z dala od cywilizacji');
  Ilosc_wyposazen := 8;
	
	FOR i IN 1..Ilosc LOOP
			Losowe_miasto := dbms_random.VALUE(1,Ilosc_miast);
			Losowy_adres := dbms_random.VALUE(1,Ilosc_adresow);
			Losowy_kod := dbms_random.VALUE(1,Ilosc_kodow);
      Losowe_wyposazenie := dbms_random.VALUE(1,Ilosc_wyposazen);
			Metraz := dbms_random.VALUE(45, 450); /*zakres metrazy do losowania*/
			INSERT INTO Nieruchomosci VALUES (NULL, Miasto(Losowe_miasto), Adres(Losowy_adres),  /*to_ char potencjalnie problematyczne*/
			Kod_pocztowy(Losowy_kod), Metraz, Wyposazenie(Losowe_wyposazenie));
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano rekordy do tabeli Nieruchomosci!');
END Nieruchomosci_gen;

DELETE FROM Nieruchomosci;
Execute Nieruchomosci_gen();

CREATE TABLE Oferty(
	ID_Oferty		INTEGER,
	FK_Nieruchomosc	INTEGER,
	Cena_ofertowa	NUMBER(10,2)
);

CREATE SEQUENCE Oferty_seq;
CREATE OR REPLACE TRIGGER Oferty_trigger
BEFORE INSERT ON Oferty
FOR EACH ROW
BEGIN
	:NEW.ID_Oferty := Oferty_seq.NEXTVAL;
END;

ALTER TABLE Oferty ADD CONSTRAINT oferty_pk PRIMARY KEY(ID_Oferty);
ALTER TABLE Oferty ADD CONSTRAINT oferty_fk1 FOREIGN KEY(FK_Nieruchomosc) REFERENCES Nieruchomosci(ID_nieruchomosci) ON DELETE CASCADE;

CREATE OR REPLACE PROCEDURE Oferty_gen AS
	Ilosc NUMBER(10);
	FK_Nieruchomosc INTEGER;
  Cena_ofertowa NUMBER(10);
	Ilosc_nieruchomosci NUMBER;
BEGIN
	Ilosc:= 250;
  SELECT COUNT(*) INTO Ilosc_nieruchomosci FROM Nieruchomosci; /* zebranie ilosci nieruchomosci w tabeli*/
	
	FOR i IN 1..Ilosc LOOP
			FK_Nieruchomosc := dbms_random.VALUE(1, Ilosc_nieruchomosci); 
			Cena_ofertowa := dbms_random.VALUE(100000, 15000000);
			INSERT INTO Oferty VALUES (NULL, FK_Nieruchomosc, Cena_ofertowa);
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano reklamacje do bazy!');
END Oferty_gen;

DELETE FROM Oferty;
Execute Oferty_gen();

CREATE TABLE Reklamy(
	ID_Reklamy		INTEGER,
	Cena_reklamy	NUMBER(4,2),
	Tresc_reklamy	varchar2(500),
	Umiejscowienie	varchar2(60),
	FK_Pracownik	INTEGER	/*pracownik odpowiedzialny za obsluge reklamy*/
);

CREATE SEQUENCE Reklamy_seq;
CREATE OR REPLACE TRIGGER Reklamy_trigger
BEFORE INSERT ON Reklamy
FOR EACH ROW
BEGIN
	:NEW.ID_Reklamy := Reklamy_seq.NEXTVAL;
END;

ALTER TABLE Reklamy ADD CONSTRAINT reklamy_pk PRIMARY KEY(ID_Reklamy);
ALTER TABLE Reklamy ADD CONSTRAINT reklamy_fk1 FOREIGN KEY(FK_Pracownik) REFERENCES Pracownicy(ID_Pracownika) ON DELETE CASCADE;
/*ALTER TABLE Reklamy ADD CONSTRAINT reklamy_umiejscowenie_check
CHECK(Umiejscowienie IN ('Internet','Gazeta', 'Telegazeta', 'Social Media'));*/

CREATE OR REPLACE PROCEDURE Reklamy_gen AS
/* w przypadku tej procedury trzeba zawezic pracownikow*/
  Ilosc NUMBER(10);
  TYPE TABSTR IS TABLE OF varchar2(500);
	FK_Pracownik INTEGER;
  Cena_reklamy NUMBER(10,2);
	Tresc_reklamy TABSTR;
  Umiejscowienie TABSTR;
  Ilosc_tresci NUMBER(10);
  Ilosc_umiejscowien NUMBER(10);
  TYPE IDsTab IS TABLE OF Pracownicy.ID_Pracownika%TYPE;
  ids IDsTab;
  Losowa_tresc NUMBER(10);
  Losowe_umiejscowienie NUMBER(10);
  Ilosc_pracownikow NUMBER;
  
  CURSOR c1 IS /*stworzenie kursora z IDs proacownikow*/
    SELECT ID_Pracownika FROM Pracownicy
    WHERE Stanowisko = 'Public Relations'; /* zebranie indeksow pracownikow od reklam*/
    
BEGIN

  OPEN c1;
    FETCH c1 BULK COLLECT INTO ids;/*zebranie danych z kursora do tabeli*/
  CLOSE c1;
  SELECT COUNT(*) INTO Ilosc_pracownikow FROM Pracownicy
  WHERE Stanowisko = 'Public Relations'; /* wyciagniecie liczby pracownikow od reklam, kursora nie chcialo w ten sposob policzyc*/

	Ilosc:= 250;
  Tresc_reklamy := TABSTR('Kup juz teraz! ', 'Niesamowita okazja!', 'Wez kredyt i zamieszkaj na swoim', 'Klucze do Twojego mieszkania leza na ulicy, schyl sie i je podnies!',
  'Nie zwlekaj, zaraz ktos inny moze kupic twoje 4 katy!', 'Wspaniala nieruchomosc w wyjatkowej lokalizacji', 'U nas najtansze nieruchomosci');
  Ilosc_tresci := 7;
  Umiejscowienie := TABSTR('Internet', 'Gazeta', 'Social media', 'Telegazeta', 'Serwis specjalistyczny', 'Slupy ogloszeniowe', 'Nasza strona internetowa');
  Ilosc_umiejscowien := 7;
  
	
	FOR i IN 1..Ilosc LOOP
			FK_Pracownik := dbms_random.VALUE(1, Ilosc_pracownikow); 
			Cena_reklamy := dbms_random.VALUE(0, 100);
      Losowa_tresc := dbms_random.VALUE(1,Ilosc_tresci);
      Losowe_umiejscowienie := dbms_random.VALUE(1,Ilosc_umiejscowien);
			INSERT INTO Reklamy VALUES (NULL, Cena_reklamy, Tresc_reklamy(Losowa_tresc), Umiejscowienie(Losowe_umiejscowienie), ids(FK_Pracownik));
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano reklamy do bazy!');
END Reklamy_gen;

DELETE FROM Reklamy;
Execute Reklamy_gen();

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
/* sekwencja i trigger dla tabeli z reklamacjami */
CREATE SEQUENCE Reklamacje_seq;
CREATE OR REPLACE TRIGGER Reklamacje_trigger
BEFORE INSERT ON Reklamacje
FOR EACH ROW
BEGIN
	:NEW.ID_Reklamacji := Reklamacje_seq.NEXTVAL;
END;


ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_pk PRIMARY KEY(ID_Reklamacji);
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk1 FOREIGN KEY(FK_Transakcja) REFERENCES Transakcje(ID_Transakcji) ON DELETE CASCADE;
/*ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk2 FOREIGN KEY(FK_Nieruchomosc) REFERENCES Nieruchomosci(ID_Nieruchomosci);*/
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk3 FOREIGN KEY(FK_Obslugujacy) REFERENCES Obsluga_prawna(ID_Osoby) ON DELETE CASCADE;
ALTER TABLE Reklamacje ADD CONSTRAINT reklamacja_fk4 FOREIGN KEY(FK_Pracownik) REFERENCES Pracownicy(ID_Pracownika) ON DELETE CASCADE;

CREATE OR REPLACE PROCEDURE Reklamacje_gen AS
	Ilosc NUMBER(10);
	TYPE TABSTR IS TABLE OF varchar2(500); /*typy musza sie zgadzac z tym co w tabeli*/
	Tresc_reklamacji TABSTR;
	FK_Transakcja INTEGER;
	FK_Obslugujacy INTEGER;
	FK_Pracownik INTEGER;
	Data_wplyniecia DATE;
	Data_zakonczenia DATE;
	Ilosc_reklamacji NUMBER(10);
	Losowa_reklamacja NUMBER(10);
BEGIN
	Ilosc:= 250;
	Tresc_reklamacji := TABSTR('Bo zupa byla za slona', 'Nie podoba mi sie Pani obslugujaca transakcje ze strony agencji', 'Dzwonilem 124 razy i nikt nie odbieral.', 
	'Zniewazono mnie slowem i czynem', 'Nie zauwazylem wczesniej, ze na srodku salonu jest dziura. Chcialbym oddac dom i odzyskac gotowke.');
	Ilosc_reklamacji := 5;
	
	FOR i IN 1..Ilosc LOOP
			Losowa_reklamacja := dbms_random.VALUE(1,Ilosc_reklamacji);
			/* 
			wyniesc ilosc transakcji do zmiennej, najlepiej globalnej, ewentualnie opracowa?akie?prawdzanie ilosci zmiennych
			np za pomoca Select * count, ktory policzy ilosc rekordow w konkretnej tabeli
			*/
			FK_Transakcja := dbms_random.VALUE(1, 1000); 
			FK_Obslugujacy := dbms_random.VALUE(1, 50);
			FK_Pracownik := dbms_random.VALUE(1, 50);
			Data_wplyniecia := to_date(trunc(dbms_random.VALUE(2451545,5373484)),'J'); /* ten zakres integerow odpowiada 01-sty-2000 do 31-dec-9999 */
			Data_zakonczenia := Data_wplyniecia + 14; /*dodaj 2 tygodnie na zakonczenie sprawy*/
			INSERT INTO Reklamacje VALUES (NULL, Tresc_reklamacji(Losowa_reklamacja), FK_Transakcja, FK_Obslugujacy,
			FK_Pracownik, Data_wplyniecia, Data_zakonczenia);
	END LOOP;
	DBMS_OUTPUT.put_line('Pomyslnie dodano reklamacje do bazy!');
END Reklamacje_gen;

DELETE FROM Reklamacje;
Execute Reklamacje_gen();

/*SELECT * FROM Reklamacje;  //sprawdzenie czy wszystko si?odalo */

