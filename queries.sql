--ex 12
--La unele magazine au fost aduse produse al caror departament nu exista in magazinul respectiv. 
--Sa se afiseze magazinele si departamentele care ar trebui adaugate pentru ca toate magazinele
--sa abia departamente corespunzatoare pentru aparatele pe care le au.
select fs.id_magazin, sd.id_departament  
from MAGAZIN fs, DEPARTAMENT sd
where sd.id_departament in (select distinct a.id_departament
                 from APARAT a, APARATE_MAGAZIN am
                 where am.id_aparat = a.id_aparat and am.id_magazin = fs.id_magazin
                 minus
                 select id_departament
                 from DEPARTAMENTE_MAGAZIN
                 where id_magazin = fs.id_magazin);--14 rezultate
                 
            
--Sa se afiseze id_angajat, id_manager, initialele numelui si prenumelui angajatului, tipul de aparat,
--data fabricatiei aparatului 
--si data vanzarii acestuia pentru tranzactiile validate de catre angajati care au salariul
--mai mic decat jumatate din valoare medie a salariului angajatilor din magazinul in care acestia lucreaza.

select s.id_salariat , nvl(to_char(s.id_manager),'este manager') manager,
        concat(substr(s.nume, 1, 1)||' ',substr(s.prenume, 1, 1)) initiale_nume,
        a.tip_aparat, a.data_fabricatie, t.data_ora
from SALARIAT s, TRANZACTIE t, APARATE_TRANZACTIE at, APARAT a
where s.id_salariat = t.id_salariat and t.id_tranzactie = at.id_tranzactie
and at.id_aparat = a.id_aparat
and s.salariu > (select avg(ss.salariu)
                from SALARIAT ss
                group by ss.id_magazin
                having ss.id_magazin = s.id_magazin)/2
order by t.data_ora;--184 rezultate



--sa se afiseze id_aparat, tipul aparatului, pretul inainte de crestere si pretul dupa o potentiala 
--crestere a aparatelor din departamentele ce contin in nume cuvantul "electrocasnice".
--Cresterea pretului este de 5%, cu exceptia aparatelor de tip "aragaz", la care pretul creste cu 10%,
--si hota, la care pretul creste cu 20%. Aparatele afisate trebuie sa fie importate de un importator
--din Romania, iar importatorul respectiv sa nu aduca aparatul de la un producator din Japonia.
--Ordonati-le crescator dupa pretul de dupa potentiala scumpire.


select a.id_aparat, a.tip_aparat, a.pret,
decode(lower(a.tip_aparat), 'hota', a.pret * 1.2, 'aragaz', a.pret *1.1, a.pret *1.05) pret_dupa_scumpire
from APARAT a, DEPARTAMENT d
where a.id_departament = d.id_departament
and lower(d.denumire_dep) like '%electrocasnice%' 
and a.id_aparat in (select * from(
    with subcerere_importatori as (select distinct apa.id_aparat
        from APARAT apa, APARAT_IMPORTATOR_PRODUCATOR aipp, IMPORTATOR imp, LOCATIE loc, ORAS ora
        where aipp.id_aparat = apa.id_aparat
        and aipp.id_importator = imp.id_importator
        and imp.id_locatie = loc.id_locatie
        and loc.oras = ora.denumire 
        and upper(tara) = 'ROMANIA')
    
    select distinct aa.id_aparat
    from APARAT aa, APARAT_IMPORTATOR_PRODUCATOR aip, PRODUCATOR pp, LOCATIE ll, ORAS o
    where aip.id_aparat = aa.id_aparat
    and aip.id_producator = pp.id_producator
    and pp.id_locatie = ll.id_locatie
    and ll.oras = o.denumire
    and upper(tara) != 'JAPONIA'
    and aa.id_aparat in (select * from subcerere_importatori)))
order by 4; -- 13 rezultate


--Un angajat isi poate renegocia salariul la 3 luni dupa data angajarii. Sa se afiseze numele si prenumele
--denumirea jobului, data angajarii, salariul si salariul dupa marire pentru angajatii care
--au avut renegocierea inaintea primei zile de marti de dupa ultima zi a lunii in care a fost angajat 
--salariatul angajat dupa "Cosma Marius". Cresterea salariului se face cu 10% pentru cei care au negociat 
--salariul in anul 2017 si cu 5% pentru cei care au negociat in anul 2018. Rezultatul se ordoneze dupa
--data angajarii. Managerii nu isi renegociaza salariul.


select s.nume||' '||s.prenume, j.denumire_job, s.data_angajarii, s.salariu,
case to_number(to_char(add_months(data_angajarii, 3), 'YYYY'))
when 2017 then salariu * 1.1
when 2018 then salariu * 1.05
else salariu
end salariu_marit
from SALARIAT s, JOB j
where s.id_job = j.id_job
and lower(j.denumire_job) != 'manager' 
and add_months(data_angajarii, 3)<(select next_day(data_angajarii, 'Marti')
                                   from(
                                        select nume, data_angajarii
                                        from salariat
                                        where data_angajarii > (select last_day(data_angajarii)
                                                                from SALARIAT
                                                                where lower(nume) = 'cosma'
                                                                and lower(prenume) = 'marius'
                                                                )
                                        order by data_angajarii)
                                   where rownum < 2)
order by data_angajarii; -- 8 rezultate


--sa se afiseze informatii complete despre aparatele care au pretul sub media de pret a produselor 
--din departamentul corespunzator lor si au cel putin un importator care sa aiba a 4 a litera din denumire 
--identica cu prima litera din tipul aparatului.

select *
from APARAT a
where a.pret <
        (select round(avg(aa.pret))
        from APARAT aa
        group by aa.id_departament
        having aa.id_departament = a.id_departament)
and id_aparat in (select distinct aa.id_aparat
              from APARAT aa, APARAT_IMPORTATOR_PRODUCATOR aip, IMPORTATOR i
              where aa.id_aparat = aip.id_aparat
              and aip.id_importator = i.id_importator
              and substr(i.denumire_inp, 4, 1) = substr(a.tip_aparat, 1, 1));-- 16 rezultate
        
        
-----------------------------------------------------------------------------------------
--ex13
--sa se modifice salariul angajatilor care sunt platiti mai bine decat angajatul cu numele 'Matei' 
-- si prenumele 'Marcel' cu o reducere de 10%.
update SALARIAT s 
set s.salariu = (select ss.salariu * 0.9
                from SALARIAT ss
                where s.id_salariat = ss.id_salariat)
where s.salariu > (select sn.salariu
                   from SALARIAT sn
                   where lower(sn.nume) = 'matei' and lower(sn.prenume) = 'marcel');--4 rows updated

  

--Sa se gaseasca cel mai mare pret mai mic decat 1000 al unui aparat. Aparatelor care au urmatoarele
--3 preturi mai mari sa le fie modificat pretul cu cel gasit anterior.
update APARAT a
set a.pret = 
        (select pret
        from
            (select *
             from APARAT aa
             where aa.pret < 1000
             order by pret desc)
        where rownum < 2)
where a.pret in (select pret
                from
                   (select *
                    from APARAT apa
                    where apa.pret > 1000
                order by apa.pret)
where rownum <4);--3 rows updated



--sa se stearga cele mai vechi 5 tranzactii din baza de date.

delete from TRANZACTIE t
where t.id_tranzactie in 
    (select id_tranzactie
     from (select * from TRANZACTIE
         order by data_ora)
     where rownum < 6); --5 rows deleted
     

---------------------------------------------------------------------------------------------------
--ex.16
--formulati in limbaj natural si implementati in SQL: o cerere ce utilizeaza operatia outer-join
--pe minimum 4 tabele si doua cereri ce utilizeaza operatia division.

--sa se afiseze aparatele care apar la toate magazinele care au id_magazin mai mare sau egal de 70003
select distinct id_aparat
from aparate_magazin a
where not exists
    (select 1
    from magazin b
    where b.id_magazin >= 70003
    and not exists
        (select 1
        from aparate_magazin c
        where c.id_aparat = a.id_aparat
        and b.id_magazin = c.id_magazin)); -- 2 rezultate
        
--sa se afiseze departamentele care apar in toate magazinele cu id_magazin mai mic decat 70002

select distinct id_departament
from departamente_magazin a
where not exists (
    (select id_magazin
    from magazin b
    where b.id_magazin < 70002)
    minus
    (select c.id_magazin
    from magazin c, departamente_magazin d
    where c.id_magazin = d.id_magazin
    and d.id_departament = a.id_departament));--1 rezultat

--sa se afiseze id-ul clientilor care au tranzactii care au fost procesate de salariatii care nu sunt
--in departamentele care au in denumire "electrocasnice".


select distinct c.id_client
from client c, tranzactie t, salariat s, departament d
where c.id_client = t.id_client
and t.id_salariat = s.id_salariat
and s.id_departament = d.id_departament (+)
and (lower(d.denumire_dep) not like 'electrocasnice%' or d.denumire_dep is null);--13 rezultate

--------------------------------------------------------------------------------------------------------
--ex.17
--optimizarea unei cereri, aplicand regulile de optimizare ce deriva din propietatile operatorilor 
--algebrei relationale. Cererea va fi exprimata prin expresie algebrica, arbore algebric si limbaj
-- sql, atat anterior cat si ulterior optimizarii.


-- sa se afiseze id-urie angajatilor care au salariul mai mare de 7000 sau care au confirmat cel putin o
-- tranzactie a clientului cu numele Popescu si au vandut cel putin o data un aparat de tip desktop.

select id_salariat
from salariat
where salariu > 7000

union
(
select distinct s.id_salariat
from salariat s, tranzactie t, persoana_fizica pf
where s.id_salariat = t.id_salariat and t.id_client = pf.id_client and lower(pf.nume) like 'popescu'

intersect

select distinct s.id_salariat
from salariat s, tranzactie t, aparate_tranzactie at, aparat a
where s.id_salariat = t.id_salariat
and t.id_tranzactie = at.id_tranzactie
and at.id_aparat = a.id_aparat
and a.tip_aparat like 'desktop'
);
 
--optimizat

select id_salariat
from salariat
where salariu > 7000

union

select distinct s.id_salariat
from 
(select distinct s.id_salariat
    from (select id_salariat
        from salariat) s,
    (select id_client, id_salariat
    from tranzactie) t,
    (select id_client
    from persoana_fizica
    where lower(nume) like 'popescu') pf
    
    where s.id_salariat = t.id_salariat
    and t.id_client = pf.id_client) s, 
    
(select id_tranzactie, id_salariat
    from tranzactie) t,
    
aparate_tranzactie at,

(select id_aparat
    from aparat
    where tip_aparat like 'desktop') a
    
where s.id_salariat = t.id_salariat
and at.id_tranzactie = t.id_tranzactie
and a.id_aparat = at.id_aparat;
        
        
    

        
