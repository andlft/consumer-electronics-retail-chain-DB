--6
-- Creati o procedura care sa selecteze toate tranzactiile care au ziua
-- saptamanii la fel ca cea de-a doua zi de dinainte de sysdate,
-- sa se gaseasca angajatul/angajatii care au validat cele mai multe tranzactii
-- din acesta zi a saptamanii. Sa se afiseze maximul de tranzactii din aceasta
-- zi si angajatii care au maximul. Dupa afisarea acestora,
-- din tranzactiile mentionate, sa se afiseze doar cele ale
-- angajatilor respectivi.

/

CREATE OR REPLACE PROCEDURE ex6 IS
    TYPE tablou_indexat IS
        TABLE OF NUMBER INDEX BY PLS_INTEGER;
    tablou_salariati    tablou_indexat;
    TYPE tablou_indexat_varchar2 IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    lista_salariati_max tablou_indexat_varchar2;
    TYPE rand_tablou_imbricat IS
        RECORD (nr_tranzactie tranzactie.id_tranzactie%type, id_salariat salariat.id_salariat%type, data tranzactie.data_ora%type);
    TYPE tablou_imbricat IS
        TABLE OF rand_tablou_imbricat;
    tablou_tranzactii   tablou_imbricat := tablou_imbricat();
    i                   NUMBER;
    max_nr              NUMBER;
    aux                 VARCHAR2(50);
BEGIN
    SELECT
        id_tranzactie,
        id_salariat,
        data_ora BULK COLLECT INTO tablou_tranzactii
    FROM
        tranzactie
        JOIN salariat
        USING (id_salariat)
    WHERE
        to_char(sysdate-2, 'day') = to_char(data_ora, 'day');
    i := tablou_tranzactii.first;
    WHILE i <= tablou_tranzactii.last LOOP
        IF NOT tablou_salariati.EXISTS(tablou_tranzactii(i).id_salariat) THEN
            tablou_salariati(tablou_tranzactii(i).id_salariat) := 1;
        ELSE
            tablou_salariati(tablou_tranzactii(i).id_salariat) := tablou_salariati(tablou_tranzactii(i).id_salariat) + 1;
        END IF;
        i := tablou_tranzactii.next(i);
    END LOOP;
    i := tablou_salariati.first;
    max_nr := 0;
    WHILE i <= tablou_salariati.last LOOP
        IF max_nr < tablou_salariati(i) THEN
            max_nr := tablou_salariati(i);
            lista_salariati_max.DELETE;
            SELECT
                nume||' '||prenume INTO aux
            FROM
                salariat
            WHERE
                id_salariat = i;
            lista_salariati_max(i) := aux;
        ELSIF max_nr = tablou_salariati(i) THEN
            SELECT
                nume||' '||prenume INTO aux
            FROM
                salariat
            WHERE
                id_salariat = i;
            lista_salariati_max(i) := aux;
        END IF;
        i := tablou_salariati.next(i);
    END LOOP;
    dbms_output.put_line('maximul de tranzactii care au avut loc '
        ||trim(to_char((sysdate-2), 'day'))
        ||' pentru un angajat este '
        ||max_nr);
    dbms_output.put_line('Salariatii cu maximul sunt:');
    i := lista_salariati_max.first;
    WHILE i <= lista_salariati_max.last LOOP
        dbms_output.put_line(i
            ||' -> '
            ||lista_salariati_max(i));
        i := lista_salariati_max.next(i);
    END LOOP;
    dbms_output.put_line('Tranzactiile sunt:');
    i := tablou_tranzactii.first;
    WHILE i <= tablou_tranzactii.last LOOP
        IF tablou_salariati(tablou_tranzactii(i).id_salariat) = max_nr THEN
            dbms_output.put_line(tablou_tranzactii(i).nr_tranzactie);
        END IF;
        i := tablou_tranzactii.next(i);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line(' Mesajul erorii: '
            || sqlerrm);

END ex6;
/

BEGIN
    ex6();
END;
/

--7
--Sa se afiseze toate magazinele dintr-un oras al carui nume este dat ca parametru. Dupa
--fiecare magazin, sa se afiseze angajatii magazinului respectiv.

CREATE OR REPLACE PROCEDURE ex7 (
    nume_oras locatie.oras%type
) IS
    CURSOR c1 (param_cursor locatie.oras%type) IS
        SELECT
            id_magazin
        FROM
            magazin
            JOIN locatie
            USING(id_locatie)
        WHERE
            oras = param_cursor;
    CURSOR c2 (id_mag magazin.id_magazin%type) IS
        SELECT
            id_salariat,
            nume,
            prenume
        FROM
            salariat
        WHERE
            id_magazin = id_mag;
    mag                  magazin.id_magazin%type;
    no_valid_location EXCEPTION;
    PRAGMA exception_init (no_valid_location, -20201);
    no_store_at_location EXCEPTION;
    PRAGMA exception_init (no_store_at_location, -20202);
    aux                  NUMBER;
    flag                 NUMBER := 0;
BEGIN
    SELECT
        COUNT(*) INTO aux
    FROM
        locatie
    WHERE
        oras = nume_oras;
    IF aux = 0 THEN
        RAISE no_valid_location;
    END IF;
    OPEN c1(nume_oras);
    LOOP
        FETCH c1 INTO mag;
        EXIT WHEN c1%notfound;
        dbms_output.put_line('Magazinul: '
            || mag);
        FOR i IN c2 (mag) LOOP
            EXIT WHEN c2%notfound;
            flag := 1;
            dbms_output.put_line('Id:'
                ||i.id_salariat
                ||'-> '
                ||i.nume
                ||' '
                ||i.prenume);
        END LOOP;
    END LOOP;
    IF c1%rowcount = 0 THEN
        RAISE no_store_at_location;
    END IF;
    CLOSE c1;
EXCEPTION
    WHEN no_valid_location THEN
        dbms_output.put_line('A fost introdusa o locatie inexistenta!');
    WHEN no_store_at_location THEN
        dbms_output.put_line('Nu exista niciun magazin la locatia data');
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line('Mesajul erorii: '
            || sqlerrm);
END ex7;
/

BEGIN
    ex7('Bucuresti');
    ex7('Brasov');
    ex7('Inexistent');
END;
/

--8
-- Sa se scrie o functie care returneaza pretul mediu al aparatelor care
-- se afla intr-un departament in care lucreaza un angajat al carui nume
-- si prenume este dat ca parametru. Functia nu v-a calcula media daca
-- salariatul lucreaza intr-un departament in care denumirea contine cuvantul
-- 'electrocasnice'. In cazul unei erori, functia sa returneze valoarea -1;

CREATE OR REPLACE FUNCTION ex8 (
    n salariat.nume%type,
    p salariat.prenume%type
) RETURN NUMBER IS
    medie              NUMBER;
    no_employee EXCEPTION;
    PRAGMA exception_init (no_employee, -20301);
    too_many_employees EXCEPTION;
    PRAGMA exception_init (too_many_employees, -20304);
    no_department EXCEPTION;
    PRAGMA exception_init (no_department, -20302);
    bad_department EXCEPTION;
    PRAGMA exception_init (bad_department, -20305);
    no_items_in_dep EXCEPTION;
    PRAGMA exception_init (no_items_in_dep, -20303);
    aux                NUMBER;
    stringaux          VARCHAR2(50);
BEGIN
    SELECT
        COUNT(*) INTO aux
    FROM
        salariat
    WHERE
        nume =n
        AND prenume = p;
    IF aux = 0 THEN
        RAISE no_employee;
    ELSIF aux > 1 THEN
        RAISE too_many_employees;
    END IF;
    SELECT
        COUNT(*) INTO aux
    FROM
        salariat
        JOIN departament
        USING (id_departament)
    WHERE
        nume = n
        AND prenume = p;
    IF aux = 0 THEN
        RAISE no_department;
    END IF;
    SELECT
        denumire_dep INTO stringaux
    FROM
        salariat
        JOIN departament
        USING (id_departament)
    WHERE
        nume = n
        AND prenume = p;
    IF lower(stringaux) LIKE '%electrocasnice%' THEN
        RAISE bad_department;
    END IF;
    SELECT
        AVG(pret) INTO medie
    FROM
        (
            SELECT
                *
            FROM
                aparat
                JOIN departament
                USING (id_departament)
            WHERE
                id_departament = (
                    SELECT
                        id_departament
                    FROM
                        salariat
                    WHERE
                        nume = n
                        AND prenume = p
                )
        );
    IF medie IS NULL THEN
        RAISE no_items_in_dep;
    END IF;
    RETURN medie;
EXCEPTION
    WHEN no_items_in_dep THEN
        dbms_output.put_line('Nu exista aparate in departament!');
        RETURN -1;
    WHEN bad_department THEN
        dbms_output.put_line('Functia nu calculeaza media pentru departamentele cu ''electrocasnice''!');
        RETURN -1;
    WHEN no_department THEN
        dbms_output.put_line('Salariatul nu are departament!');
        RETURN -1;
    WHEN no_employee THEN
        dbms_output.put_line('Nu exista niciun salariat cu acest nume/prenume!');
        RETURN -1;
    WHEN too_many_employees THEN
        dbms_output.put_line('Exista mai multi salariati cu acelasi nume si prenume!');
        RETURN -1;
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line('Mesajul erorii: '
            || sqlerrm);
        RETURN -1;
END ex8;
/

BEGIN
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Cernat', 'Mihai'));
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Patrascuuuuu', 'Ionel'));
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Patrascu', 'Ionel'));
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Cosma', 'Marius'));
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Marcu', 'Bogdan'));
    dbms_output.put_line('Pretul mediu este: '
        || ex8('Neculai', 'Stefan'));
END;
/

--9
--Sa se afiseze id_salariat, nume si prenume pentru salariatul care
--a validat o tranzactie cu o persoana juridica cu o valoare totala mai
--mare decat un numar dat ca parametru, la valoare fiind luate in calcul
--doar aparate din departamentele care contin in denumire un cuvant dat
--ca parametru. In dreptul salariatului sa fie afisata si tranzactia
--si valoarea produselor luate in calcul pentru tranzactia respectiva.
/

CREATE OR REPLACE PROCEDURE ex9 (
    nr NUMBER,
    cuv_dep VARCHAR2
) IS
    id      salariat.id_salariat%type;
    n       salariat.nume%type;
    p       salariat.prenume%type;
    tran    tranzactie.id_tranzactie%type;
    sumaa   NUMBER;
    no_dept EXCEPTION;
    PRAGMA exception_init(no_dept, -20336);
    neg_nr EXCEPTION;
    PRAGMA exception_init(neg_nr, -20337);
    aux     NUMBER;
BEGIN
    IF nr < 0 THEN
        RAISE neg_nr;
    END IF;
    SELECT
        COUNT(*) INTO aux
    FROM
        departament
    WHERE
        lower(denumire_dep) LIKE '%'
            ||lower(cuv_dep)
            ||'%';
    IF aux = 0 THEN
        RAISE no_dept;
    END IF;
    SELECT
        id_salariat,
        s.nume,
        s.prenume,
        id_tranzactie,
        suma INTO id,
        n,
        p,
        tran,
        sumaa
    FROM
        salariat s
        JOIN (
            SELECT
                t.id_tranzactie,
                t.id_salariat,
                SUM(a.pret*at.nr_buc) suma
            FROM
                tranzactie         t
                JOIN aparate_tranzactie at
                ON (at.id_tranzactie = t.id_tranzactie) JOIN aparat a
                ON (a.id_aparat = at.id_aparat)
                JOIN persoana_juridica pj
                ON (t.id_client = pj.id_client) JOIN departament d
                ON (d.id_departament = a.id_departament)
            WHERE
                lower(d.denumire_dep) LIKE '%'
                    ||lower(cuv_dep)
                    ||'%'
            GROUP BY
                t.id_tranzactie,
                t.id_salariat
        )
        USING (id_salariat)
    WHERE
        suma > nr;
    dbms_output.put_line('salariat-> '
        ||id
        ||' '
        ||n
        ||' '
        ||p
        ||' tranzactie: '
        ||tran
        ||' suma: '
        ||sumaa);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Incearca un numar mai mic!(Nu au fost gasite date)');
    WHEN too_many_rows THEN
        dbms_output.put_line('Incearca un numar mai mare!(Prea multe randuri)');
    WHEN neg_nr THEN
        dbms_output.put_line('Nu sunt acceptate numere negative!');
    WHEN no_dept THEN
        dbms_output.put_line('Nu s-a gasit niciun departament care sa contina cuvantul!');
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line(' Mesajul erorii: '
            || sqlerrm);
END ex9;
/

BEGIN
    ex9(10000, 'electro');
    ex9(0, 'electro');
    ex9(100000, 'electro');
    ex9(10000, 'fjdgshk');
    ex9(-2392, 'electro');
END;
/


--10
-- Sa se faca un trigger care sa nu permita inserarea in tabela DEPARTAMENTE daca prin
-- aceasta inserare s-ar duce la o medie de produse pe departament mai mica de 15.

CREATE OR REPLACE TRIGGER ex10 BEFORE
    INSERT ON departament
DECLARE
    nr_departamente NUMBER;
    nr_aparate      NUMBER;
BEGIN
    SELECT
        COUNT(*) INTO nr_departamente
    FROM
        departament;
    SELECT
        COUNT(*) INTO nr_aparate
    FROM
        aparat;
    IF (nr_departamente+1) * 15 > nr_aparate THEN
        raise_application_error(-20888, 'Prea multe departamente pentru un numar mic de produse, pentru a crea mai multe departamente ar trebui sa fie, in medie, minim 15 aparate/departament!');
    END IF;
END;
/

BEGIN
    INSERT INTO departament VALUES(
        200,
        'Cabluri'
    );
    INSERT INTO departament VALUES(
        210,
        'Altele'
    );
    ROLLBACK;
END;
/

--11
-- Sa se faca un trigger care sa nu permita inserarea in tabela MAGAZIN a unor magazine,
-- daca prin aceasta s-ar duce la existenta a mai mult de 1 magazin la 50000 de locuitori
-- intr-un oras. Inserarea magazinelor este permisa numai daca locatia se afla intr-un
-- oras din Romania.

CREATE OR REPLACE TRIGGER ex11 BEFORE
    INSERT ON magazin FOR EACH ROW
DECLARE
    populatie_oras        NUMBER;
    nr_magazine_existente NUMBER;
    den_tara              oras.tara%type;
BEGIN
    SELECT
        o.populatie,
        o.tara INTO populatie_oras,
        den_tara
    FROM
        locatie l
        JOIN oras o
        ON (l.oras = o.denumire)
    WHERE
        :new.id_locatie = l.id_locatie;
    IF lower(den_tara) != 'romania' THEN
        raise_application_error (-20505, 'Locatia nu este in Romania!');
    END IF;
    SELECT
        COUNT(*) INTO nr_magazine_existente
    FROM
        magazin m
        JOIN locatie l
        USING (id_locatie)
    GROUP BY
        l.oras
    HAVING
        l.oras = (
            SELECT
                oras
            FROM
                locatie
            WHERE
                id_locatie = :new.id_locatie
        );
    IF populatie_oras/(nr_magazine_existente + 1) < 50000 THEN
        raise_application_error(-20506, 'Nu se poate face inserarea deoarece s-ar depasi
    valoarea de un magazin / 50000 locuitori in orasul in care se afla locatia!');
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error (-20507, ' Nu exista o locatie cu codul specificat ');
    WHEN OTHERS THEN 
        raise_application_error (-20508, ' Codul erorii: '
            || sqlcode
            ||' Mesajul erorii: '
            ||sqlerrm);
END;
/

BEGIN
    INSERT INTO magazin VALUES (
        70005,
        3010,
        30000000,
        20000
    );
    ROLLBACK;
END;
/

BEGIN
    INSERT INTO magazin VALUES (
        70005,
        1008,
        30000000,
        20000
    );
    ROLLBACK;
END;
/

BEGIN
    INSERT INTO magazin VALUES (
        70005,
        1018,
        30000000,
        20000
    );
    ROLLBACK;
END;
/

BEGIN
    INSERT INTO magazin VALUES (
        70005,
        1015,
        30000000,
        20000
    );
    ROLLBACK;
END;
/
--12
--Realizati un trigger DLL care nu permite sa se faca DROP unui tabel care
--are date in el

CREATE OR REPLACE TRIGGER ex12 BEFORE DROP ON DATABASE
DECLARE
    table_name VARCHAR2(50);
    nr         NUMBER;
    aux        NUMBER;
BEGIN
    IF sys.dictionary_obj_type = 'TABLE' THEN
    SELECT
        COUNT(*) INTO aux
    FROM
        user_tables
    WHERE
        lower(table_name) = lower(sys.dictionary_obj_name);
    IF aux = 0 THEN
        raise_application_error(-20935, 'Nu exista tabela data ca parametru!');
    END IF;
    table_name := sys.dictionary_obj_name;
    EXECUTE IMMEDIATE 'select count(*) from '
        || table_name INTO nr;
    IF nr > 0 THEN
        raise_application_error (-20934, 'Tabela are date, sterge datele mai intai!');
    END IF;
    END IF;
END;
/

CREATE TABLE test (
    id number
);

INSERT INTO test VALUES(
    10
);

DROP TABLE test;

DROP TABLE testtt;

DELETE FROM test
WHERE
    1 = 1;
    
DROP TABLE test;
/

--13
CREATE OR REPLACE PACKAGE ex13 AS
    PROCEDURE ex6;
    PROCEDURE ex7 (
        nume_oras locatie.oras%type
    );
    FUNCTION ex8 (
        n salariat.nume%type,
        p salariat.prenume%type
    ) RETURN NUMBER;
    PROCEDURE ex9 (
        nr NUMBER,
        cuv_dep VARCHAR2
    );
END ex13;
/

CREATE OR REPLACE PACKAGE BODY ex13 AS
    PROCEDURE ex6 IS
    TYPE tablou_indexat IS
        TABLE OF NUMBER INDEX BY PLS_INTEGER;
    tablou_salariati    tablou_indexat;
    TYPE tablou_indexat_varchar2 IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    lista_salariati_max tablou_indexat_varchar2;
    TYPE rand_tablou_imbricat IS
        RECORD (nr_tranzactie tranzactie.id_tranzactie%type, id_salariat salariat.id_salariat%type, data tranzactie.data_ora%type);
    TYPE tablou_imbricat IS
        TABLE OF rand_tablou_imbricat;
    tablou_tranzactii   tablou_imbricat := tablou_imbricat();
    i                   NUMBER;
    max_nr              NUMBER;
    aux                 VARCHAR2(50);
BEGIN
    SELECT
        id_tranzactie,
        id_salariat,
        data_ora BULK COLLECT INTO tablou_tranzactii
    FROM
        tranzactie
        JOIN salariat
        USING (id_salariat)
    WHERE
        to_char(sysdate-2, 'day') = to_char(data_ora, 'day');
    i := tablou_tranzactii.first;
    WHILE i <= tablou_tranzactii.last LOOP
        IF NOT tablou_salariati.EXISTS(tablou_tranzactii(i).id_salariat) THEN
            tablou_salariati(tablou_tranzactii(i).id_salariat) := 1;
        ELSE
            tablou_salariati(tablou_tranzactii(i).id_salariat) := tablou_salariati(tablou_tranzactii(i).id_salariat) + 1;
        END IF;
        i := tablou_tranzactii.next(i);
    END LOOP;
    i := tablou_salariati.first;
    max_nr := 0;
    WHILE i <= tablou_salariati.last LOOP
        IF max_nr < tablou_salariati(i) THEN
            max_nr := tablou_salariati(i);
            lista_salariati_max.DELETE;
            SELECT
                nume||' '||prenume INTO aux
            FROM
                salariat
            WHERE
                id_salariat = i;
            lista_salariati_max(i) := aux;
        ELSIF max_nr = tablou_salariati(i) THEN
            SELECT
                nume||' '||prenume INTO aux
            FROM
                salariat
            WHERE
                id_salariat = i;
            lista_salariati_max(i) := aux;
        END IF;
        i := tablou_salariati.next(i);
    END LOOP;
    dbms_output.put_line('maximul de tranzactii care au avut loc '
        ||trim(to_char((sysdate-2), 'day'))
        ||' pentru un angajat este '
        ||max_nr);
    dbms_output.put_line('Salariatii cu maximul sunt:');
    i := lista_salariati_max.first;
    WHILE i <= lista_salariati_max.last LOOP
        dbms_output.put_line(i
            ||' -> '
            ||lista_salariati_max(i));
        i := lista_salariati_max.next(i);
    END LOOP;
    dbms_output.put_line('Tranzactiile sunt:');
    i := tablou_tranzactii.first;
    WHILE i <= tablou_tranzactii.last LOOP
        IF tablou_salariati(tablou_tranzactii(i).id_salariat) = max_nr THEN
            dbms_output.put_line(tablou_tranzactii(i).nr_tranzactie);
        END IF;
        i := tablou_tranzactii.next(i);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line(' Mesajul erorii: '
            || sqlerrm);

END ex6;
PROCEDURE ex7 (
        nume_oras locatie.oras%type
    ) IS
        CURSOR c1 (param_cursor locatie.oras%type) IS
            SELECT
                id_magazin
            FROM
                magazin
                JOIN locatie
                USING(id_locatie)
            WHERE
                oras = param_cursor;
        CURSOR c2 (id_mag magazin.id_magazin%type) IS
            SELECT
                id_salariat,
                nume,
                prenume
            FROM
                salariat
            WHERE
                id_magazin = id_mag;
        mag                  magazin.id_magazin%type;
        no_valid_location EXCEPTION;
        PRAGMA exception_init (no_valid_location, -20201);
        no_store_at_location EXCEPTION;
        PRAGMA exception_init (no_store_at_location, -20202);
        aux                  NUMBER;
        flag                 NUMBER := 0;
    BEGIN
        SELECT
            COUNT(*) INTO aux
        FROM
            locatie
        WHERE
            oras = nume_oras;
        IF aux = 0 THEN
            RAISE no_valid_location;
        END IF;
        OPEN c1(nume_oras);
        LOOP
            FETCH c1 INTO mag;
            EXIT WHEN c1%notfound;
            dbms_output.put_line('Magazinul: '
                || mag);
            FOR i IN c2 (mag) LOOP
                EXIT WHEN c2%notfound;
                flag := 1;
                dbms_output.put_line('Id:'
                    ||i.id_salariat
                    ||'-> '
                    ||i.nume
                    ||' '
                    ||i.prenume);
            END LOOP;
        END LOOP;
        IF c1%rowcount = 0 THEN
            RAISE no_store_at_location;
        END IF;
        CLOSE c1;
    EXCEPTION
        WHEN no_valid_location THEN
            dbms_output.put_line('A fost introdusa o locatie inexistenta!');
        WHEN no_store_at_location THEN
            dbms_output.put_line('Nu exista niciun magazin la locatia data');
        WHEN OTHERS THEN
            dbms_output.put_line('Codul erorii: '
                || sqlcode);
            dbms_output.put_line('Mesajul erorii: '
                || sqlerrm);
    END ex7;
    FUNCTION ex8 (
    n salariat.nume%type,
    p salariat.prenume%type
) RETURN NUMBER IS
    medie              NUMBER;
    no_employee EXCEPTION;
    PRAGMA exception_init (no_employee, -20301);
    too_many_employees EXCEPTION;
    PRAGMA exception_init (too_many_employees, -20304);
    no_department EXCEPTION;
    PRAGMA exception_init (no_department, -20302);
    bad_department EXCEPTION;
    PRAGMA exception_init (bad_department, -20305);
    no_items_in_dep EXCEPTION;
    PRAGMA exception_init (no_items_in_dep, -20303);
    aux                NUMBER;
    stringaux          VARCHAR2(50);
BEGIN
    SELECT
        COUNT(*) INTO aux
    FROM
        salariat
    WHERE
        nume =n
        AND prenume = p;
    IF aux = 0 THEN
        RAISE no_employee;
    ELSIF aux > 1 THEN
        RAISE too_many_employees;
    END IF;
    SELECT
        COUNT(*) INTO aux
    FROM
        salariat
        JOIN departament
        USING (id_departament)
    WHERE
        nume = n
        AND prenume = p;
    IF aux = 0 THEN
        RAISE no_department;
    END IF;
    SELECT
        denumire_dep INTO stringaux
    FROM
        salariat
        JOIN departament
        USING (id_departament)
    WHERE
        nume = n
        AND prenume = p;
    IF lower(stringaux) LIKE '%electrocasnice%' THEN
        RAISE bad_department;
    END IF;
    SELECT
        AVG(pret) INTO medie
    FROM
        (
            SELECT
                *
            FROM
                aparat
                JOIN departament
                USING (id_departament)
            WHERE
                id_departament = (
                    SELECT
                        id_departament
                    FROM
                        salariat
                    WHERE
                        nume = n
                        AND prenume = p
                )
        );
    IF medie IS NULL THEN
        RAISE no_items_in_dep;
    END IF;
    RETURN medie;
EXCEPTION
    WHEN no_items_in_dep THEN
        dbms_output.put_line('Nu exista aparate in departament!');
        RETURN -1;
    WHEN bad_department THEN
        dbms_output.put_line('Functia nu calculeaza media pentru departamentele cu ''electrocasnice''!');
        RETURN -1;
    WHEN no_department THEN
        dbms_output.put_line('Salariatul nu are departament!');
        RETURN -1;
    WHEN no_employee THEN
        dbms_output.put_line('Nu exista niciun salariat cu acest nume/prenume!');
        RETURN -1;
    WHEN too_many_employees THEN
        dbms_output.put_line('Exista mai multi salariati cu acelasi nume si prenume!');
        RETURN -1;
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line('Mesajul erorii: '
            || sqlerrm);
        RETURN -1;
END ex8;

    PROCEDURE ex9 (
    nr NUMBER,
    cuv_dep VARCHAR2
) IS
    id      salariat.id_salariat%type;
    n       salariat.nume%type;
    p       salariat.prenume%type;
    tran    tranzactie.id_tranzactie%type;
    sumaa   NUMBER;
    no_dept EXCEPTION;
    PRAGMA exception_init(no_dept, -20336);
    neg_nr EXCEPTION;
    PRAGMA exception_init(neg_nr, -20337);
    aux     NUMBER;
BEGIN
    IF nr < 0 THEN
        RAISE neg_nr;
    END IF;
    SELECT
        COUNT(*) INTO aux
    FROM
        departament
    WHERE
        lower(denumire_dep) LIKE '%'
            ||lower(cuv_dep)
            ||'%';
    IF aux = 0 THEN
        RAISE no_dept;
    END IF;
    SELECT
        id_salariat,
        s.nume,
        s.prenume,
        id_tranzactie,
        suma INTO id,
        n,
        p,
        tran,
        sumaa
    FROM
        salariat s
        JOIN (
            SELECT
                t.id_tranzactie,
                t.id_salariat,
                SUM(a.pret*at.nr_buc) suma
            FROM
                tranzactie         t
                JOIN aparate_tranzactie at
                ON (at.id_tranzactie = t.id_tranzactie) JOIN aparat a
                ON (a.id_aparat = at.id_aparat)
                JOIN persoana_juridica pj
                ON (t.id_client = pj.id_client) JOIN departament d
                ON (d.id_departament = a.id_departament)
            WHERE
                lower(d.denumire_dep) LIKE '%'
                    ||lower(cuv_dep)
                    ||'%'
            GROUP BY
                t.id_tranzactie,
                t.id_salariat
        )
        USING (id_salariat)
    WHERE
        suma > nr;
    dbms_output.put_line('salariat-> '
        ||id
        ||' '
        ||n
        ||' '
        ||p
        ||' tranzactie: '
        ||tran
        ||' suma: '
        ||sumaa);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Incearca un numar mai mic!(Nu au fost gasite date)');
    WHEN too_many_rows THEN
        dbms_output.put_line('Incearca un numar mai mare!(Prea multe randuri)');
    WHEN neg_nr THEN
        dbms_output.put_line('Nu sunt acceptate numere negative!');
    WHEN no_dept THEN
        dbms_output.put_line('Nu s-a gasit niciun departament care sa contina cuvantul!');
    WHEN OTHERS THEN
        dbms_output.put_line('Codul erorii: '
            || sqlcode);
        dbms_output.put_line(' Mesajul erorii: '
            || sqlerrm);
END ex9;

END ex13;
/

--14
CREATE OR REPLACE PACKAGE pachet_flux_tranzactii AS
    TYPE rand_tabel_a_t IS
        RECORD (id_ap NUMBER, nr_b NUMBER);
    TYPE t_aparate_tranzactie IS
        TABLE OF rand_tabel_a_t;
    TYPE emp_tr IS
        RECORD ( id_s salariat.id_salariat%type, n salariat.nume%type, p salariat.prenume%type, nr_tranz NUMBER );
    PROCEDURE afisarebonfiscal (
        id_tr tranzactie.id_tranzactie%type
    );
    PROCEDURE adaugatranzactie (
        id_c client.id_client %type,
        id_sa salariat.id_salariat%type,
        id_ma magazin.id_magazin%type,
        apr_tr t_aparate_tranzactie
    );
    FUNCTION sumatotalaclient (
        id_c client.id_client%type
    ) RETURN NUMBER;
    FUNCTION sumatotalasalariat (
        id_s salariat.id_salariat%type
    ) RETURN NUMBER;
    FUNCTION ang_cu_cmm_nr_tranz_in_luna_curenta RETURN emp_tr;
END pachet_flux_tranzactii;
/

CREATE OR REPLACE PACKAGE BODY pachet_flux_tranzactii AS
    PROCEDURE afisarebonfiscal (
        id_tr tranzactie.id_tranzactie%type
    ) IS
        id_cl NUMBER;
    BEGIN
        SELECT
            id_client INTO id_cl
        FROM
            tranzactie
        WHERE
            id_tranzactie = id_tr;
        dbms_output.put_line('-----------------------------------------');
        dbms_output.put_line('id_client: '
            ||id_cl);
        dbms_output.put_line('id_tranzactie: '
            || id_tr);
        FOR i IN (
            SELECT
                *
            FROM
                aparat
                JOIN aparate_tranzactie
                USING (id_aparat)
            WHERE
                id_tranzactie = id_tr
        ) LOOP
            dbms_output.put_line(i.id_aparat
                || '-> '
                ||i.tip_aparat
                ||' '
                ||i.model
                ||' __ '
                ||i.nr_buc
                ||' X '
                ||i.pret
                ||' = '
                ||i.nr_buc*i.pret);
        END LOOP;
        dbms_output.put_line('-----------------------------------------');
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nu exista aceasta tranzactie!');
    END afisarebonfiscal;
    PROCEDURE adaugatranzactie (
        id_c client.id_client %type,
        id_sa salariat.id_salariat%type,
        id_ma magazin.id_magazin%type,
        apr_tr t_aparate_tranzactie
    ) IS
        i NUMBER;
    BEGIN
        INSERT INTO tranzactie VALUES (
            seq_tranzactie_id.NEXTVAL,
            id_ma,
            id_c,
            id_sa,
            sysdate
        );
        i := apr_tr.first;
        WHILE i<= apr_tr.last LOOP
            INSERT INTO aparate_tranzactie VALUES (
                seq_tranzactie_id.CURRVAL,
                apr_tr(i).id_ap,
                apr_tr(i).nr_b
            );
            i := apr_tr.next(i);
        END LOOP;
    END adaugatranzactie;
    FUNCTION sumatotalaclient (
        id_c client.id_client%type
    ) RETURN NUMBER IS
        suma NUMBER := 0;
    BEGIN
        SELECT
            nvl(SUM(nr_buc*pret),
            0) INTO suma
        FROM
            client
            JOIN tranzactie
            USING(id_client) JOIN aparate_tranzactie
            USING (id_tranzactie)
            JOIN aparat
            USING (id_aparat)
        WHERE
            id_client = id_c;
        RETURN suma;
    END sumatotalaclient;
    FUNCTION sumatotalasalariat (
        id_s salariat.id_salariat%type
    ) RETURN NUMBER IS
        suma NUMBER := 0;
    BEGIN
        SELECT
            nvl(SUM(nr_buc*pret),
            0) INTO suma
        FROM
            salariat
            JOIN tranzactie
            USING(id_salariat) JOIN aparate_tranzactie
            USING (id_tranzactie)
            JOIN aparat
            USING (id_aparat)
        WHERE
            id_salariat = id_s;
        RETURN suma;
    END sumatotalasalariat;
    FUNCTION ang_cu_cmm_nr_tranz_in_luna_curenta RETURN emp_tr IS
        ret emp_tr;
    BEGIN
        SELECT
            id_salariat,
            s.nume,
            s.prenume,
            f.nr INTO ret
        FROM
            (
                SELECT
                    id_salariat,
                    COUNT(*) nr
                FROM
                    salariat
                    JOIN tranzactie
                    USING (id_salariat)
                WHERE
                    EXTRACT(MONTH FROM data_ora)= EXTRACT (MONTH FROM sysdate)
                    AND EXTRACT (YEAR FROM data_ora) = EXTRACT (YEAR FROM sysdate)
                GROUP BY
                    id_salariat
                ORDER BY
                    2
            )        f
            JOIN salariat s
            USING (id_salariat);
        RETURN ret;
    exception
        when no_data_found then
            dbms_output.put_line('Nu s-au facut tranzactii in luna aceasta!');
            return null;
    END ang_cu_cmm_nr_tranz_in_luna_curenta;
END pachet_flux_tranzactii;
/ 
DECLARE
    arg_table   pachet_flux_tranzactii.t_aparate_tranzactie := pachet_flux_tranzactii.t_aparate_tranzactie();
    ret_rec
    pachet_flux_tranzactii.emp_tr;

BEGIN
    pachet_flux_tranzactii.afisarebonfiscal(9000000000);
    pachet_flux_tranzactii.afisarebonfiscal(900000000008);
    arg_table.extend(3);
    arg_table(1) := pachet_flux_tranzactii.rand_tabel_a_t(100002, 2);
    arg_table(2) := pachet_flux_tranzactii.rand_tabel_a_t(100003, 3);
    arg_table(3) := pachet_flux_tranzactii.rand_tabel_a_t(100004, 1);
-- /*pachet_flux_tranzactii.adaugaTranzactie(2000000009, 30000007, 70002, arg_table);*/
    dbms_output.put_line('suma tranzactiilor clientului: ' || pachet_flux_tranzactii.sumatotalaclient(2000000005));
    dbms_output.put_line('suma tranzactiilor clientului: ' || pachet_flux_tranzactii.sumatotalaclient(20000000055555));
    dbms_output.put_line('suma tranzactiilor angajatului: ' || pachet_flux_tranzactii.sumatotalasalariat(30000007));
    dbms_output.put_line('suma tranzactiilor angajatului: ' || pachet_flux_tranzactii.sumatotalasalariat(300000077777));
    ret_rec := pachet_flux_tranzactii.ang_cu_cmm_nr_tranz_in_luna_curenta();
    dbms_output.put_line('id angajat: '
                         || ret_rec.id_s
                         || ' -> '
                         || ret_rec.n
                         || ' '
                         || ret_rec.p
                         || ' -> nr. tranzactii in luna curenta: '
                         || ret_rec.nr_tranz);

END;
/

