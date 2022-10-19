create table MAGAZIN(
id_magazin number(5) primary key,
id_locatie number(4) not null,
id_manager number(9),
suprafata_mp number(7) not null);

create table LOCATIE(
id_locatie number(4) primary key,
strada varchar2(20),
numar number(6),
oras varchar2(25));

alter table MAGAZIN
add constraint FK_locatie_magazin 
foreign key (id_locatie) references LOCATIE(id_locatie) on delete cascade;

create table IMPORTATOR(
id_importator number(4) primary key,
denumire_inp varchar2(30) not null,
id_locatie number(4),
cif varchar2(20) not null,
nr_tel_call_center varchar2(20),
constraint FK_locatie_importator foreign key(id_locatie) references LOCATIE(id_locatie) on delete cascade);

create table PRODUCATOR(
id_producator number(4) primary key,
denumire_prd varchar2(30) not null,
id_locatie number(4),
cif varchar2(20) not null,
email varchar2(50) check(email like '%@%.%'),
constraint FK_locatie_producator foreign key(id_locatie) references LOCATIE(id_locatie)on delete cascade);

create table APARAT(
id_aparat number(6) primary key,
id_departament number(3) not null,
tip_aparat varchar2(20),
data_fabricatie date default sysdate,
pret number(8, 2),
greutate number(8, 2),
culoare varchar2(20));

alter table APARAT
add model varchar2(30);

create table APARAT_IMPORTATOR_PRODUCATOR(
id_aparat number(6),
id_importator number(4),
id_producator number(4),
constraint PK_aparat_importator_producator primary key (id_aparat, id_importator, id_producator));

create table APARATE_MAGAZIN(
id_magazin number(5),
id_aparat number(6),
nr_buc number(5),
constraint PK_aparate_magazin primary key(id_magazin, id_aparat));

create table DEPARTAMENT(
id_departament number(3) primary key,
denumire_dep varchar2(50));

alter table APARAT
add constraint FK_departament_produs foreign key (id_departament) references DEPARTAMENT(id_departament) on delete cascade;

create table DEPARTAMENTE_MAGAZIN(
id_magazin number(5),
id_departament number(3),
constraint PK_departamente_magazin primary key(id_magazin, id_departament));

create table TRANZACTIE(
id_tranzactie number(12) primary key,
id_magazin number(5) not null,
id_client number(10) not null,
id_salariat number(8) not null,
data_ora date default sysdate not null);

create table APARATE_TRANZACTIE(
id_tranzactie number(12),
id_aparat number(6),
nr_buc number(5),
constraint PK_aparate_tranzactie primary key(id_tranzactie, id_aparat));

create table CLIENT(
id_client number(10) primary key,
nr_telefon varchar2(20),
email varchar2(50) check(email like'%@%.%'));

create table PERSOANA_FIZICA(
id_client number(10) primary key,
nume varchar2(40),
prenume varchar2(40),
constraint FK_persoana_fizica_client foreign key (id_client) references CLIENT(id_client) on delete cascade);

create table PERSOANA_JURIDICA(
id_client number(10) primary key,
denumire varchar2(50),
cif varchar2(20) not null unique,
constraint FK_persoana_juridica_client foreign key (id_client) references CLIENT(id_client) on delete cascade);

create table SALARIAT (
id_salariat number(8) primary key,
id_manager number(8), 
id_departament number(3),
id_job number(4),
nume varchar2(30) not null,
prenume varchar2(30) not null,
nr_telefon varchar2(20) not null unique,
email varchar2(50) not null check(email like '%@%.%') unique,
salariu number(5),
data_angajarii date default sysdate,
constraint FK_manager_salariat_s foreign key(id_manager) references SALARIAT(id_salariat) on delete cascade,
constraint FK_departament_salariat_s foreign key (id_departament) references DEPARTAMENT (id_departament) on delete cascade);

alter table SALARIAT
add id_magazin number(5);


create table JOB(
id_job number(4) primary key,
denumire_job varchar2(30),
salariu_minim number(5),
salariu_maxim number(5));


create table ORAS(
denumire varchar2(25) primary key,
populatie number(9),
tara varchar2(25));

alter table LOCATIE
add constraint FK_oras_l foreign key(oras)references ORAS(denumire) on delete cascade;

alter table MAGAZIN
add constraint FK_manager_magazin foreign key(id_manager) references SALARIAT(id_salariat) on delete cascade;

alter table APARAT_IMPORTATOR_PRODUCATOR
add constraint FK_id_importator foreign key(id_importator) references IMPORTATOR(id_importator) on delete cascade;

alter table APARAT_IMPORTATOR_PRODUCATOR
add constraint FK_id_aparat foreign key(id_aparat) references APARAT(id_aparat) on delete cascade;

alter table APARAT_IMPORTATOR_PRODUCATOR
add constraint FK_id_producator foreign key(id_producator) references PRODUCATOR(id_producator) on delete cascade;

alter table APARATE_TRANZACTIE
add constraint FK_id_aparat_at foreign key(id_aparat) references APARAT (id_aparat) on delete cascade;

alter table APARATE_TRANZACTIE
add constraint FK_id_tranzactie_at foreign key(id_tranzactie) references TRANZACTIE (id_tranzactie) on delete cascade;

alter table APARATE_MAGAZIN
add constraint FK_id_aparat_am foreign key(id_aparat) references APARAT (id_aparat) on delete cascade;

alter table APARATE_MAGAZIN
add constraint FK_id_magazin_am foreign key(id_magazin) references MAGAZIN (id_magazin) on delete cascade;

alter table TRANZACTIE
add constraint FK_id_magazin_t foreign key(id_magazin) references MAGAZIN( id_magazin)on delete cascade;

alter table TRANZACTIE
add constraint FK_id_client_t foreign key(id_client) references CLIENT( id_client) on delete cascade;

alter table DEPARTAMENTE_MAGAZIN
add constraint FK_id_magazin_dm foreign key(id_magazin) references MAGAZIN(id_magazin) on delete cascade;

alter table DEPARTAMENTE_MAGAZIN
add constraint FK_id_departament_dm foreign key(id_departament) references DEPARTAMENT(id_departament) on delete cascade;

alter table SALARIAT
add constraint FK_id_job_s foreign key(id_job) references JOB(id_job) on delete cascade;


alter table SALARIAT
add constraint FK_id_magazin_s foreign key(id_magazin) references MAGAZIN(id_magazin) on delete cascade;



insert into ORAS
values('Oradea', 200000, 'Romania');
insert into ORAS
values('Constanta',150000 ,'Romania');
insert into ORAS
values('Timisoara',300000 ,'Romania');
insert into ORAS
values('Cluj-Napoca',300000 ,'Romania');
insert into ORAS
values('Brasov',250000 ,'Romania');
insert into ORAS
values('Galati',250000 ,'Romania');
insert into ORAS
values('Arad',160000 ,'Romania');
insert into ORAS
values('Tulcea',73000 ,'Romania');
insert into ORAS
values('Slatina',70000 ,'Romania');
insert into ORAS
values('Deva',61000 ,'Romania');
insert into ORAS
values('Ramnicu-Valcea',100000 ,'Romania');
insert into ORAS
values('Istanbul',15000000 ,'Turcia');
insert into ORAS
values('Berlin', 3000000,'Germania');
insert into ORAS
values('Madrid',3300000 ,'Spania');
insert into ORAS
values('Viena',1900000 ,'Austria');
insert into ORAS
values('Budapesta',1700000 ,'Ungaria');
insert into ORAS
values('Roma',2800000 ,'Italia');
insert into ORAS
values('Tokyo',37000000 ,'Japonia');
insert into ORAS
values('Beijing',21000000 ,'China');
insert into ORAS
values('Tianjin',14000000 ,'China');
insert into ORAS
values('Cairo',21000000 ,'Egipt');
insert into ORAS
values('Bucuresti', 1700000, 'Romania');

create sequence seq_locatie_id
start with 1000
increment by 1
nomaxvalue
nocycle
nocache;

insert into LOCATIE
values(seq_locatie_id.nextval, 'Apusului', 33, 'Oradea');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Victoriei',39, 'Arad');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Republicii',78, 'Slatina');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Postei',102, 'Deva');
insert into LOCATIE
values(seq_locatie_id.nextval, '1 Mai',4, 'Brasov');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Marasesti', 90, 'Cluj-Napoca');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Pillat Ion',5, 'Timisoara');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Tineretului',8, 'Ramnicu-Valcea');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Podgoriilor',31, 'Tulcea');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Mamaia',73, 'Constanta');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Victoriei',32, 'Tulcea');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Lalelelor',21, 'Timisoara');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Principala',33, 'Oradea');
insert into LOCATIE
values(seq_locatie_id.nextval, 'DN1',402, 'Galati');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Fagului',66, 'Slatina');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Dristor',72, 'Bucuresti');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Raheem Ways',null, 'Viena');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Bartoletti Parks',502, 'Istanbul');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Loreine Gateway',123, 'Cairo');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Suite',473, 'Tianjin');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Simhaven',90, 'Berlin');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Effieshire',671, 'Budapesta');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Mannview',12, 'Madrid');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Nebraska',112, 'Tokyo');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Zorastad',6, 'Istanbul');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Maryland',90, 'Beijing');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Boganland',743, 'Viena');
insert into LOCATIE
values(seq_locatie_id.nextval, 'West Plaza',33, 'Istanbul');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Teresa Rapid',null, 'Tokyo');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Alabama',93, 'Berlin');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Straulesti',18, 'Bucuresti');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Berceni',2, 'Bucuresti');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Militari',21, 'Bucuresti');
insert into LOCATIE
values(seq_locatie_id.nextval, 'Berzei',92, 'Bucuresti');



create sequence seq_producator_id
start with 1000
increment by 1
nomaxvalue
nocycle
nocache;

insert into PRODUCATOR
values(seq_producator_id.nextval, 'Samsung', 1025, '11325690151', 'samsung@mobile.net');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Sony', 1029, 'DE235476422DS', 'sony@company.com');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'LG', 1027, 'JK283764', 'lg@connect.us');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Apple',1021 , '83264812', 'apple@official.apl');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Toshiba',1019 , 'TW1287630112', 'toshiba@electronics.cn');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Microsoft',1026 , 'MS8176212', 'microsoft@ms.us');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Apple',1028 , 'APL318812', 'apple@apl.com');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'IBM',1024 , 'DE3287612', 'ibm@computing.net');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Panasonic',1017 , 'TKY236481', 'panasonic@pnsnc.com');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Arctic',1016 , 'AR1287633232', 'arctic@emailus.net');
insert into PRODUCATOR
values(seq_producator_id.nextval, 'Bosch', 1018, 'BSCH12835821123', 'bosch.fab@bmail.us');

create sequence seq_importator_id
start with 1000
increment by 1
nomaxvalue
nocycle
nocache;

insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.importauto.srl',1013 ,'RO172634182121','+40478391643');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.tirimport.sa',1009 ,'RO162387216387','+40874646257');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.electronictrans.srl',1011 ,'RO2374682182','+407516237182');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.autoimport.sa',1008 ,'RO872615837233','+40542763978');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.marfadinafara.srl',1032 ,'RO617266612832','+40544469941');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.tehnoimp.srl',1033 ,'RO12873612134','+40588874132');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.telefoaneimport.srl',1014 ,'RO217635821734','+40987123564');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.deviceprovider.srl',1012 ,'RO1289367213','+40334921764');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'sc.refrigerator.srl',1031 ,'RO22187653182','+40183225813');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'globalelectronics.inc',1022 ,'GLB18253817','+71228367411');
insert into IMPORTATOR
values(seq_importator_id.nextval, 'masstransport.inc',1023 ,'TR128376128','+172653712332');


create sequence seq_departament_id
start with 110
increment by 10
nomaxvalue
nocycle
nocache;

insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Telefoane, tablete si accesorii');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Laptopuri, desktopuri si servere');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'TV, Audio-Video si foto');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Electrocasnice mari');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Electrocasnice mici');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Curatenie, intretinere casa');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Trotinete, Biciclete');
insert into DEPARTAMENT
values(seq_departament_id.nextval, 'Bauturi: cafea, apa si suc');



create sequence seq_job_id
start with 5000
increment by 10
nomaxvalue
nocycle
nocache;

insert into JOB
values(seq_job_id.nextval,'manager',5000 ,25000);
insert into JOB
values(seq_job_id.nextval, 'casier',2000 ,10000);
insert into JOB
values(seq_job_id.nextval, 'asistent vanzari',2000 ,15000);
insert into JOB
values(seq_job_id.nextval, 'instalator echipamente',3500 ,10000);
insert into JOB
values(seq_job_id.nextval, 'agent call center', 2500, 9500);
insert into JOB
values(seq_job_id.nextval, 'stivuitorist',2000 ,7500);
insert into JOB
values(seq_job_id.nextval, 'sofer',3000 ,7000);
insert into JOB
values(seq_job_id.nextval, 'inspector',4500 ,13000);
insert into JOB
values(seq_job_id.nextval, 'dispecer monitorizare video',2500 ,5000);
insert into JOB
values(seq_job_id.nextval, 'responsabil service',3200 ,10000);
insert into JOB
values(seq_job_id.nextval, 'stock controller',3500 ,9000);

create sequence seq_aparat_id
start with 100000
increment by 1
nomaxvalue
nocycle
nocache;

insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','15-12-2020',699.33 ,0.20 ,'negru', 'S10');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','21-04-2019',1789.99 ,0.35 ,'alb', 'A70');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','23-09-2020',429.00 ,0.5 ,'verde', 'R25');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','04-05-2020',789.99 ,0.4 ,'albastru', 'D32');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','18-03-2020',1239.99 ,0.4 ,'negru', 'R33');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','23-02-2019',2300.99 ,0.3 ,'auriu', 'S22');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','15-01-2020',999.99 ,0.34 ,'argintiu', 'T21');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','07-03-2018',496.99 ,0.39 ,'negru', 'G2');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'telefon','31-05-2020',2199.99 ,0.6 ,'negru', 'C10');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'tableta','21-02-2018',3900.99 ,1.5 ,'argintiu', 'T12');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'tableta','23-06-2017',2409.99 ,1.2 ,'alb', 'E20');
insert into APARAT
values(seq_aparat_id.nextval, 110 , 'tableta','12-03-2020',3049.99 ,1.4 ,'negru', 'T990');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','20-3-2018', 3006.04,0.62,'negru', 'pro65');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','23-9-2020', 3156.95,0.43,'argintiu', 't85');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','18-4-2017', 1089.74,0.46,'auriu', 't99');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','11-4-2018', 4351.05,0.54,'auriu', 'st78');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','23-11-2020', 407.56,0.35,'auriu', 't63');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','12-5-2017', 4231.32,0.49,'alb', 'a2');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','14-8-2020', 2552.14,0.61,'auriu', 'vx8');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','7-5-2020', 4558.93,0.67,'rosu', 'pro62');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','1-7-2018', 4942.29,0.65,'auriu', 'a49');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','14-10-2017', 754.88,0.49,'argintiu', 'st58');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','15-11-2020', 3631.12,0.45,'alb', 'st26');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','24-11-2018', 3340.28,0.35,'albastru', 't61');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','9-11-2020', 2323.73,0.34,'rosu', 'g8');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','1-11-2018', 1681.23,0.34,'alb', 'c32');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','25-6-2020', 2046.56,0.43,'galben', 't9');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','15-5-2019', 3709.44,0.33,'verde', 'c79');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','26-12-2018', 4202.04,0.4,'galben', 'st31');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','14-1-2020', 4363.56,0.57,'auriu', 'pro8');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','15-12-2019', 818.52,0.41,'negru', 'st9');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'telefon','17-3-2017', 3425.27,0.3,'albastru', 'pro67');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','18-10-2018', 4096.5,2.26,'argintiu', 'pro49');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','21-1-2019', 1837.45,1.76,'galben', 'g46');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','15-3-2020', 1530.43,1.84,'rosu', 'g62');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','19-9-2019', 1594.67,1.77,'galben', 't34');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','7-2-2020', 5038.63,1.37,'auriu', 'st80');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','28-9-2018', 7357.69,1.98,'argintiu', 'pro78');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','16-8-2017', 3119.75,1.16,'negru', 't63');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','12-1-2017', 4810.42,2.0,'alb', 't2');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','23-2-2020', 1085.33,1.52,'negru', 'a93');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'tableta','24-7-2019', 3391.88,2.48,'alb', 't62');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','12-1-2020', 151.84,0.67,'negru', 'zx97');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','14-3-2019', 140.69,0.68,'negru', 's37');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','28-5-2020', 137.63,0.11,'negru', 'ks57');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','12-11-2020', 128.11,0.51,'negru', 's68');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','8-12-2017', 157.85,0.58,'negru', 's13');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','10-11-2020', 183.66,0.1,'negru', 'g11');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','1-6-2020', 114.7,0.59,'negru', 'ls71');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','14-7-2020', 45.08,0.85,'negru', 'vx36');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','8-9-2019', 146.23,0.21,'negru', 'zx68');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','22-2-2020', 170.35,0.86,'negru', 'er71');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','20-3-2020', 40.28,0.53,'negru', 'ks9');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','15-7-2020', 175.48,0.14,'negru', 't37');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','17-11-2020', 191.14,0.78,'negru', 'g31');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','17-3-2020', 131.29,0.86,'negru', 'g34');
insert into APARAT
values(seq_aparat_id.nextval, 110, 'incarcator','24-11-2020', 89.97,0.58,'negru', 'sa85');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','24-3-2020', 10920.19,6.44,'argintiu', 'er24');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','10-9-2018', 5972.57,2.51,'rosu', 'vx86');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','12-11-2020', 10203.55,5.13,'negru', 'gt25');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','19-4-2020', 8550.97,4.68,'alb', 's99');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','4-10-2020', 9195.03,2.99,'albastru', 'chr70');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','19-7-2017', 1149.95,7.54,'albastru', 's68');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','22-4-2020', 2501.21,7.43,'argintiu', 'g49');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','2-5-2020', 5875.68,5.28,'alb', 'ls91');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','19-11-2020', 4646.01,4.95,'negru', 't83');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','20-6-2017', 7022.23,4.46,'argintiu', 'sa36');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','10-11-2020', 4055.49,2.38,'galben', 'zx79');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','11-5-2018', 1827.54,2.47,'negru', 'a6');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','16-1-2020', 11598.7,5.07,'alb', 'pr21');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','13-9-2017', 1038.12,2.85,'verde', 'pr75');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','4-3-2020', 6501.56,3.73,'galben', 'gt74');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','8-12-2020', 11646.43,6.66,'rosu', 'a44');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','13-3-2020', 5950.22,3.51,'galben', 'ks55');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','18-8-2018', 8409.18,6.97,'argintiu', 'g16');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','21-4-2020', 5223.45,4.72,'galben', 'chr7');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'laptop','20-4-2020', 4220.81,2.63,'argintiu', 'ls95');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','17-1-2018', 9482.07,7.31,'alb', 'a86');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','9-3-2020', 1861.64,6.38,'alb', 'c49');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','11-12-2020', 5220.31,4.48,'alb', 'a86');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','16-1-2020', 1664.38,4.94,'alb', 'chr63');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','15-1-2017', 1330.14,7.22,'negru', 'c22');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','23-12-2019', 8238.55,6.7,'alb', 'er33');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','13-5-2018', 8714.74,4.93,'alb', 'vx68');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','27-9-2018', 3661.79,3.99,'alb', 'a17');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','23-6-2017', 6037.86,5.67,'negru', 'pr77');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'desktop','20-4-2018', 1400.06,3.41,'alb', 'g99');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'server','14-12-2018', 1917.35,6.49,'alb', 't76');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'server','12-8-2019', 2475.74,6.16,'negru', 'pr36');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'server','26-5-2020', 1551.62,6.32,'negru', 't22');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'server','25-5-2020', 4349.07,7.91,'negru', 'sa86');
insert into APARAT
values(seq_aparat_id.nextval, 120, 'server','10-10-2020', 4155.9,6.73,'negru', 'sa57');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','11-11-2020', 7707.66,19.67,'negru', 'chr5');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','16-4-2017', 8424.87,11.52,'alb', 'ks68');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','21-5-2018', 14128.83,34.16,'alb', 'chr86');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','10-7-2019', 12607.68,18.51,'alb', 'pr89');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','28-9-2018', 5491.45,31.92,'negru', 'pr69');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','9-6-2020', 14046.23,23.65,'alb', 'st4');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','22-9-2019', 3809.42,12.89,'alb', 'gt53');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','5-11-2020', 11048.97,29.53,'alb', 'gt82');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','18-4-2019', 13228.67,10.66,'negru', 'pr20');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'TV','12-4-2020', 4594.65,20.28,'negru', 'a16');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','12-12-2020', 7021.89,5.82,'verde', 'vx9');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','1-12-2020', 1311.51,0.65,'verde', 'c81');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','13-10-2018', 8669.99,1.06,'negru', 'ks35');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','14-5-2020', 9486.17,1.23,'galben', 'zx66');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','10-3-2017', 7469.77,4.51,'galben', 'sa86');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','9-2-2018', 4665.17,1.3,'argintiu', 'chr51');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','1-8-2020', 3003.1,4.23,'verde', 'chr38');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','11-10-2020', 8145.68,5.68,'alb', 'er8');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','10-10-2018', 7353.45,1.32,'albastru', 'er47');
insert into APARAT
values(seq_aparat_id.nextval, 130, 'camera foto','9-9-2017', 450.46,2.24,'rosu', 'g75');
insert into APARAT
values(seq_aparat_id.nextval, 140, 'masina de spalat','28-12-2020', 1854.94,60.86,'argintiu', 'chr91');
insert into APARAT
values(seq_aparat_id.nextval, 140, 'hota','3-7-2017', 943.07,47.76,'negru', 'ks45');
insert into APARAT
values(seq_aparat_id.nextval, 140, 'masina de spalat','26-1-2017', 3469.56,91.82,'alb', 't71');
insert into APARAT
values(seq_aparat_id.nextval, 140, 'aragaz','25-1-2017', 3613.02,92.08,'argintiu', 'gt10');
insert into APARAT
values(seq_aparat_id.nextval, 140, 'hota','10-11-2018', 1818.16,52.21,'alb', 'ls33');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'feon','6-11-2020', 230.42,1.76,'alb', 'st32');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'toaster','5-3-2017', 273.01,3.32,'alb', 'vx80');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'blender','13-8-2019', 375.17,1.74,'argintiu', 'ks16');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'feon','11-11-2019', 269.33,2.5,'alb', 'gt1');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'prajitor','7-11-2019', 144.43,3.49,'negru', 'chr21');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'feon','1-2-2018', 262.8,4.71,'negru', 's36');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'toaster','20-6-2019', 399.83,4.2,'alb', 'pr3');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'feon','22-3-2017', 350.37,1.93,'alb', 'st47');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'blender','19-6-2017', 108.9,2.93,'alb', 'ls72');
insert into APARAT
values(seq_aparat_id.nextval, 150, 'toaster','4-12-2020', 178.4,0.68,'argintiu', 'chr91');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'robot curatenie','19-11-2020', 204.67,2.14,'negru', 'vx46');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'mop','17-3-2020', 237.01,4.64,'negru', 'pr64');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'aspirator','22-4-2019', 408.15,1.52,'argintiu', 'c13');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'aspirator','26-5-2020', 358.82,3.61,'alb', 'gt40');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'aspirator','10-4-2020', 382.38,0.79,'negru', 'ls49');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'robot curatenie','17-1-2020', 457.85,2.88,'argintiu', 'er31');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'aspirator','28-8-2020', 290.61,3.18,'negru', 'sa50');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'mop','22-6-2018', 232.69,4.69,'negru', 's85');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'aspirator','23-3-2019', 150.25,4.85,'negru', 'chr91');
insert into APARAT
values(seq_aparat_id.nextval, 160, 'mop','20-10-2017', 235.67,1.09,'argintiu', 'zx99');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','16-1-2020', 7419.82,21.37,'negru', 't56');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'bicicleta','18-12-2017', 4530.32,37.49,'argintiu', 'zx61');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','22-9-2017', 9266.41,41.67,'argintiu', 'chr58');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','22-6-2019', 4847.36,44.81,'alb', 'pr37');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'bicicleta','1-11-2018', 6784.89,15.86,'argintiu', 'pr91');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','15-4-2017', 7070.46,44.89,'negru', 'a95');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','9-3-2020', 2798.8,43.57,'alb', 'c36');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'trotineta','24-10-2018', 4661.49,28.83,'alb', 'st69');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'bicicleta','20-5-2020', 6710.45,32.75,'negru', 't27');
insert into APARAT
values(seq_aparat_id.nextval, 170, 'bicicleta','6-5-2020', 6576.03,49.09,'argintiu', 'vx95');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'aparat cafea','6-8-2017', 1466.88,9.39,'negru', 'pr59');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'aparat cafea','12-10-2017', 778.86,1.62,'argintiu', 'chr72');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'dozator','22-9-2017', 551.72,10.68,'alb', 't21');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'dozator','10-5-2020', 1075.31,11.29,'alb', 'er8');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'aparat cafea','3-12-2020', 613.84,5.62,'argintiu', 'ls91');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'aparat cafea','15-3-2018', 655.7,11.72,'alb', 'ks28');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'dozator','18-7-2020', 1408.44,1.47,'negru', 's78');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'aparat cafea','10-2-2020', 1001.87,2.39,'argintiu', 'a76');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'dozator','19-12-2018', 783.8,11.71,'argintiu', 'ls20');
insert into APARAT
values(seq_aparat_id.nextval, 180, 'smoothie maker','21-11-2018', 547.77,9.09,'negru', 'sa58');



insert into APARAT_IMPORTATOR_PRODUCATOR
values(100000, 1007, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100000, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100001, 1007, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100002, 1004, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100003, 1010, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100004, 1009, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100005, 1004, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100006, 1002, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100006, 1001, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100007, 1009, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100007, 1006, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100008, 1003, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100009, 1009, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100010, 1005, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100010, 1006, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100011, 1005, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100012, 1009, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100012, 1005, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100013, 1009, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100013, 1007, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100014, 1007, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100015, 1002, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100016, 1001, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100016, 1002, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100017, 1010, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100018, 1000, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100019, 1006, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100020, 1009, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100020, 1001, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100021, 1005, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100021, 1003, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100022, 1005, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100023, 1006, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100023, 1005, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100024, 1005, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100024, 1002, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100025, 1004, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100026, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100026, 1000, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100027, 1006, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100027, 1010, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100028, 1006, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100028, 1000, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100029, 1009, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100029, 1004, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100030, 1001, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100031, 1003, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100031, 1008, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100032, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100032, 1007, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100033, 1005, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100034, 1005, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100035, 1009, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100036, 1004, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100036, 1003, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100037, 1002, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100037, 1007, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100038, 1008, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100039, 1010, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100039, 1006, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100040, 1001, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100040, 1006, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100041, 1004, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100041, 1001, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100042, 1004, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100043, 1001, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100043, 1007, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100044, 1009, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100045, 1000, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100046, 1000, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100047, 1003, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100048, 1000, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100049, 1003, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100049, 1006, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100050, 1006, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100051, 1004, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100052, 1000, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100053, 1001, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100053, 1000, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100054, 1007, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100055, 1008, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100055, 1004, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100056, 1000, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100057, 1008, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100057, 1004, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100058, 1004, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100058, 1007, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100059, 1008, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100059, 1010, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100060, 1000, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100061, 1004, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100062, 1005, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100062, 1007, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100063, 1003, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100063, 1005, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100064, 1008, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100064, 1006, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100065, 1001, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100065, 1008, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100066, 1010, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100067, 1003, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100067, 1004, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100068, 1006, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100069, 1005, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100070, 1003, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100071, 1001, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100072, 1000, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100072, 1002, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100073, 1009, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100073, 1002, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100074, 1004, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100075, 1000, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100076, 1000, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100076, 1004, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100077, 1000, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100078, 1000, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100079, 1002, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100080, 1003, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100081, 1008, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100082, 1000, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100082, 1001, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100083, 1007, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100084, 1003, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100085, 1008, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100085, 1006, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100086, 1002, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100087, 1006, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100088, 1004, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100088, 1008, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100089, 1006, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100090, 1003, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100090, 1001, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100091, 1007, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100092, 1000, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100092, 1007, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100093, 1003, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100094, 1008, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100094, 1002, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100095, 1010, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100096, 1008, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100097, 1001, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100098, 1005, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100098, 1009, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100099, 1007, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100100, 1006, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100101, 1003, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100102, 1001, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100102, 1009, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100103, 1010, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100103, 1002, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100104, 1007, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100105, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100105, 1008, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100106, 1002, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100107, 1000, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100108, 1004, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100108, 1002, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100109, 1006, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100110, 1008, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100111, 1000, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100111, 1010, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100112, 1004, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100113, 1009, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100114, 1010, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100115, 1008, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100116, 1003, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100117, 1008, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100117, 1004, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100118, 1008, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100119, 1005, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100120, 1006, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100120, 1007, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100121, 1006, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100122, 1005, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100123, 1001, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100123, 1000, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100124, 1005, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100124, 1000, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100125, 1002, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100126, 1002, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100127, 1001, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100128, 1002, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100129, 1004, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100130, 1003, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100130, 1007, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100131, 1004, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100132, 1010, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100133, 1004, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100134, 1000, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100134, 1008, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100135, 1006, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100136, 1000, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100137, 1001, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100138, 1010, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100138, 1006, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100139, 1009, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100139, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100140, 1009, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100141, 1006, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100142, 1010, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100143, 1009, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100144, 1006, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100145, 1005, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100145, 1003, 1006);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100146, 1002, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100147, 1002, 1000);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100147, 1001, 1010);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100148, 1004, 1005);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100149, 1003, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100150, 1004, 1007);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100151, 1002, 1003);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100151, 1008, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100152, 1006, 1004);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100152, 1000, 1002);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100153, 1002, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100154, 1010, 1001);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100154, 1005, 1008);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100155, 1000, 1009);
insert into APARAT_IMPORTATOR_PRODUCATOR
values(100155, 1010, 1002);


create sequence seq_magazin_id
start with 70000
increment by 1
nomaxvalue
nocycle
nocache;

insert into MAGAZIN
values(seq_magazin_id.nextval, 1010, null, 20000);
insert into MAGAZIN
values(seq_magazin_id.nextval, 1032, null, 35000);
insert into MAGAZIN
values(seq_magazin_id.nextval, 1001, null, 25000);
insert into MAGAZIN
values(seq_magazin_id.nextval, 1031, null, 40000);
insert into MAGAZIN
values(seq_magazin_id.nextval, 1009, null, 15000);

insert into DEPARTAMENTE_MAGAZIN
values(70000, 180);
insert into DEPARTAMENTE_MAGAZIN
values(70000, 150);
insert into DEPARTAMENTE_MAGAZIN
values(70000, 170);
insert into DEPARTAMENTE_MAGAZIN
values(70001, 150);
insert into DEPARTAMENTE_MAGAZIN
values(70001, 130);
insert into DEPARTAMENTE_MAGAZIN
values(70001, 140);
insert into DEPARTAMENTE_MAGAZIN
values(70002, 170);
insert into DEPARTAMENTE_MAGAZIN
values(70002, 120);
insert into DEPARTAMENTE_MAGAZIN
values(70002, 160);
insert into DEPARTAMENTE_MAGAZIN
values(70003, 130);
insert into DEPARTAMENTE_MAGAZIN
values(70003, 110);
insert into DEPARTAMENTE_MAGAZIN
values(70003, 180);
insert into DEPARTAMENTE_MAGAZIN
values(70004, 170);
insert into DEPARTAMENTE_MAGAZIN
values(70004, 120);
insert into DEPARTAMENTE_MAGAZIN
values(70004, 140);




insert into APARATE_MAGAZIN
values(70000, 100037, 8);
insert into APARATE_MAGAZIN
values(70000, 100110, 16);
insert into APARATE_MAGAZIN
values(70000, 100129, 19);
insert into APARATE_MAGAZIN
values(70000, 100073, 18);
insert into APARATE_MAGAZIN
values(70000, 100140, 10);
insert into APARATE_MAGAZIN
values(70000, 100104, 11);
insert into APARATE_MAGAZIN
values(70000, 100086, 16);
insert into APARATE_MAGAZIN
values(70000, 100097, 11);
insert into APARATE_MAGAZIN
values(70000, 100052, 14);
insert into APARATE_MAGAZIN
values(70000, 100098, 10);
insert into APARATE_MAGAZIN
values(70001, 100005, 9);
insert into APARATE_MAGAZIN
values(70001, 100153, 17);
insert into APARATE_MAGAZIN
values(70001, 100100, 8);
insert into APARATE_MAGAZIN
values(70001, 100073, 13);
insert into APARATE_MAGAZIN
values(70001, 100087, 19);
insert into APARATE_MAGAZIN
values(70001, 100036, 15);
insert into APARATE_MAGAZIN
values(70001, 100079, 7);
insert into APARATE_MAGAZIN
values(70001, 100068, 15);
insert into APARATE_MAGAZIN
values(70001, 100065, 2);
insert into APARATE_MAGAZIN
values(70002, 100028, 13);
insert into APARATE_MAGAZIN
values(70002, 100046, 12);
insert into APARATE_MAGAZIN
values(70002, 100112, 2);
insert into APARATE_MAGAZIN
values(70002, 100132, 7);
insert into APARATE_MAGAZIN
values(70002, 100037, 4);
insert into APARATE_MAGAZIN
values(70002, 100022, 1);
insert into APARATE_MAGAZIN
values(70002, 100116, 18);
insert into APARATE_MAGAZIN
values(70002, 100088, 8);
insert into APARATE_MAGAZIN
values(70002, 100091, 5);
insert into APARATE_MAGAZIN
values(70002, 100155, 12);
insert into APARATE_MAGAZIN
values(70003, 100084, 3);
insert into APARATE_MAGAZIN
values(70003, 100088, 2);
insert into APARATE_MAGAZIN
values(70003, 100024, 3);
insert into APARATE_MAGAZIN
values(70003, 100138, 16);
insert into APARATE_MAGAZIN
values(70003, 100063, 12);
insert into APARATE_MAGAZIN
values(70003, 100107, 17);
insert into APARATE_MAGAZIN
values(70003, 100041, 18);
insert into APARATE_MAGAZIN
values(70003, 100000, 11);
insert into APARATE_MAGAZIN
values(70003, 100082, 9);
insert into APARATE_MAGAZIN
values(70003, 100103, 5);
insert into APARATE_MAGAZIN
values(70004, 100083, 17);
insert into APARATE_MAGAZIN
values(70004, 100089, 11);
insert into APARATE_MAGAZIN
values(70004, 100041, 4);
insert into APARATE_MAGAZIN
values(70004, 100082, 5);
insert into APARATE_MAGAZIN
values(70004, 100051, 5);
insert into APARATE_MAGAZIN
values(70004, 100150, 7);
insert into APARATE_MAGAZIN
values(70004, 100140, 4);
insert into APARATE_MAGAZIN
values(70004, 100142, 10);

                 

create sequence seq_client_id
start with 2000000000
increment by 1
nomaxvalue
nocycle
nocache;

insert into CLIENT
values(seq_client_id.nextval, '+40751742814', 'andrei.popescu@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40723372484', 'gigi.dima@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40381627388', 'daniela.toma@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+41982638129', 'tecliceanu.mihai@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+07123487613', 'eduard.panait@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40324826187', 'nelu.petrea@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+43929391239', 'banica.stefan@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+49293129387', 'ana.codreanu@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40328734618', 'filconstruct@fil.net');
insert into CLIENT
values(seq_client_id.nextval, '+40386712837', 'itcompany@company.com');
insert into CLIENT
values(seq_client_id.nextval, '+40332647326', 'motoctraduceri@ymail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40372635476', 'serviceauto@gmail.com');
insert into CLIENT
values(seq_client_id.nextval, '+40316523765', 'sevmarcranes@scranes.com');


insert into PERSOANA_FIZICA
values(2000000000, 'Popescu', 'Andrei');
insert into PERSOANA_FIZICA
values(2000000001, 'Dima', 'George');
insert into PERSOANA_FIZICA
values(2000000002, 'Toma', 'Daniela');
insert into PERSOANA_FIZICA
values(2000000003, 'Tecliceanu', 'Mihai');
insert into PERSOANA_FIZICA
values(2000000004, 'Panait', 'Eduard');
insert into PERSOANA_FIZICA
values(2000000005, 'Petrea', 'Nelu');
insert into PERSOANA_FIZICA
values(2000000006, 'Banica', 'Stefan');
insert into PERSOANA_FIZICA
values(2000000007, 'Codreanu', 'Ana');
insert into PERSOANA_JURIDICA
values(2000000008, 'sc.filconstuct.sa', 'RO765128632');
insert into PERSOANA_JURIDICA
values(2000000009, 'sc.itcompany.srl', 'RO8736483281');
insert into PERSOANA_JURIDICA
values(2000000010, 'motoctraduceri.pfa', 'RO861238432');
insert into PERSOANA_JURIDICA
values(2000000011, 'sc.serviceauto.sa', 'RO237468121');
insert into PERSOANA_JURIDICA
values(2000000012, 'sc.sevmarcranes.srl', 'RO237645123');


create sequence seq_salariat_id
start with 30000000
increment by 1
nomaxvalue
nocycle
nocache;


insert into SALARIAT
values(seq_salariat_id.nextval, null, null,5000,'Neculai', 'Stefan','+40785347894',
'neculai.stefan@gmail.com', 23000, '19-05-2016', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, null, null,5000,'Cimpoiesu', 'Sabin','+40777238764',
'cimpoiesu.sabin@gmail.com', 21000, '19-05-2016', 70001);
insert into SALARIAT
values(seq_salariat_id.nextval, null, null,5000,'Vasiliu', 'Andra','+40775361853',
'vasiliu.andra@gmail.com', 22500, '20-07-2016', 70002);
insert into SALARIAT
values(seq_salariat_id.nextval, null, null,5000,'Cazacencu', 'Adrian','+40574628165',
'cazcencu.adrian@gmail.com', 24000, '12-10-2016', 70003);
insert into SALARIAT
values(seq_salariat_id.nextval, null, null,5000,'Matei', 'Marcel','+40767456457',
'matei.marcel@gmail.com', 20500, '05-02-2017', 70004);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000000, 110,5000,'Baltag', 'Octavian','+40792348942',
'baltag.octavian@gmail.com', 10000, '23-04-2017', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000000, 150,5040,'Chiuta', 'Ion','+40783642891',
'chiuta.ion@gmail.com', 6000, '30-01-2017', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000000, 180,5050,'Cernat', 'Mihai','+40778372912',
'cernat.mihai@gmail.com', 5000, '17-05-2017', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000000, 120,5030,'Cimpan', 'Liliana','+40756427816',
'cimpan.liliana@gmail.com', 7000, '06-03-2018', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000001, 120,5040,'Bidian', 'Daniel','+40774278542',
'bidian.daniel@gmail.com', 3400, '07-02-2018', 70001);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000001, 140,5060,'Cosma', 'Marius','+40756853678',
'cosma.marius@gmail.com', 5600, '12-08-2018', 70001);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000001, 130,5090,'Branisteanu', 'George','+40774573186',
'branisteanu.george@gmail.com', 6600, '30-12-2018', 70001);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000002, 150,5100,'Badica', 'Ana','+40773298164',
'badica.ana@gmail.com', 4000, '11-07-2019', 70002);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000002, 150,5020,'Manole', 'Rares','+40714285913',
'rares.manole@gmail.com', 9000, '12-05-2019', 70002);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000002, 160,5050,'Darie', 'Sorin','+40734572901',
'darie.sorin@gmail.com', 3000, '01-03-2020', 70002);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000003, 130,5080,'Balaj', 'Stefan','+40723064891',
'balaj.stefan@gmail.com', 4500, '11-03-2018', 70003);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000003, 170,5030,'Ion', 'Costin','+40798037549',
'ion.costin@gmail.com', 7500, '09-02-2018', 70003);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000003, 110,5070,'Udrea', 'Gabriel','+40767013728',
'udrea.gabriel@gmail.com', 4500, '03-11-2017', 70003);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000004, 120,5040,'Dima', 'Robert','+40752860187',
'dima.robert@gmail.com', 7500, '30-04-2019', 70004);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000004, 180,5080,'Ivanov', 'Mihaela','+40764109457',
'ivanov.mihaela@gmail.com', 3000, '25-10-2019', 70004);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000004, 140,5010,'Luca', 'Traian','+40793547134',
'luca.traian@gmail.com', 5000, '24-09-2019', 70004);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000000, 140,5000,'Marcu', 'Bogdan', '+40734583145',
'marcu.bogdan@gmail.com', 15000, '21-02-2018', 70000);
insert into SALARIAT
values(seq_salariat_id.nextval, 30000021, 140,5080,'Zamfir', 'George','+40723457418',
'zamfir.george@gmail.com', 3400, '03-07-2019', 70000);


create sequence seq_tranzactie_id
start with 900000000000
increment by 1
nomaxvalue
nocycle
nocache;


insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,  2000000005, 30000007, to_date('12/05/2021, 10:35:43','DD/MM/YYYY, HH24:MI:SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000005,30000005,to_date('23/4/2021, 17:50:2','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000002,30000019,to_date('23/10/2021, 14:19:55','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000015,to_date('2/2/2021, 10:32:9','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000009,to_date('3/6/2021, 10:31:43','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000005,30000007,to_date('13/1/2021, 11:14:52','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000002,30000016,to_date('16/10/2021, 15:7:10','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000009,30000002,to_date('25/10/2021, 15:30:14','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000017,to_date('1/12/2021, 8:5:56','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000002,30000002,to_date('28/5/2021, 12:59:15','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000001,30000000,to_date('25/6/2021, 8:37:47','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000006,30000014,to_date('8/7/2021, 9:14:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000013,to_date('7/11/2021, 16:28:54','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000015,to_date('9/5/2021, 18:6:26','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000008,30000016,to_date('5/11/2021, 16:44:6','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000020,to_date('4/10/2021, 17:57:51','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000005,30000006,to_date('25/9/2021, 12:39:15','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000004,to_date('23/1/2021, 11:20:20','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000001,30000015,to_date('28/4/2021, 16:48:25','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000019,to_date('9/3/2021, 8:50:59','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000007,30000020,to_date('10/9/2021, 16:31:37','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000016,to_date('21/8/2021, 11:26:9','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000005,to_date('12/6/2021, 16:13:26','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000010,to_date('28/7/2021, 18:16:52','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000012,to_date('8/8/2021, 10:46:37','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000011,to_date('10/1/2021, 15:10:22','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000010,30000017,to_date('15/3/2021, 19:58:46','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000003,30000012,to_date('9/2/2021, 9:38:23','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000006,30000006,to_date('12/8/2021, 8:33:14','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000009,30000008,to_date('17/11/2021, 13:25:56','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000001,30000013,to_date('26/2/2021, 15:43:7','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000008,30000012,to_date('7/10/2021, 13:28:1','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000011,30000017,to_date('6/6/2021, 13:30:52','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000003,30000018,to_date('22/12/2021, 18:13:38','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000009,30000020,to_date('12/11/2021, 19:19:8','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000011,30000018,to_date('2/7/2021, 8:59:37','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000011,30000019,to_date('22/4/2021, 14:55:8','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000006,30000013,to_date('6/6/2021, 19:21:0','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000010,to_date('14/2/2021, 15:13:29','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000005,30000011,to_date('4/6/2021, 11:36:41','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000006,30000004,to_date('28/4/2021, 11:51:54','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000006,30000018,to_date('11/3/2021, 9:8:44','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000019,to_date('17/2/2021, 13:0:38','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000007,30000005,to_date('14/2/2021, 14:16:27','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000015,to_date('8/9/2021, 10:5:44','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000004,30000005,to_date('3/5/2021, 11:3:27','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000009,30000017,to_date('12/12/2021, 18:14:55','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000004,30000016,to_date('26/10/2021, 12:28:33','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000009,30000012,to_date('23/10/2021, 9:4:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000004,30000014,to_date('9/11/2021, 8:1:5','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000012,to_date('17/2/2021, 19:22:24','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000003,30000005,to_date('5/11/2021, 11:49:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000008,30000010,to_date('12/7/2021, 17:30:15','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000009,30000007,to_date('15/5/2021, 14:40:58','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000004,30000017,to_date('4/11/2021, 10:41:9','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000020,to_date('8/1/2021, 13:34:24','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000007,30000019,to_date('11/3/2021, 17:15:35','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000010,30000018,to_date('17/8/2021, 18:17:40','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000007,to_date('27/2/2021, 18:10:19','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000006,30000009,to_date('15/10/2021, 15:0:3','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000004,30000010,to_date('8/3/2021, 10:4:46','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000010,30000011,to_date('5/9/2021, 12:30:30','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000002,30000016,to_date('28/9/2021, 17:24:7','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000011,30000012,to_date('19/8/2021, 11:27:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000001,30000015,to_date('20/9/2021, 11:20:54','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000004,30000016,to_date('29/12/2021, 17:59:4','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000003,30000011,to_date('13/4/2021, 9:13:30','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000007,to_date('8/6/2021, 15:22:55','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000003,30000012,to_date('28/1/2021, 17:2:51','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000015,to_date('13/5/2021, 8:38:54','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000011,30000010,to_date('2/7/2021, 13:15:18','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000007,30000000,to_date('3/9/2021, 8:55:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000007,30000012,to_date('27/11/2021, 14:55:35','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000009,30000005,to_date('26/6/2021, 18:16:21','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000008,30000015,to_date('9/3/2021, 18:3:39','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000004,30000017,to_date('17/4/2021, 17:38:35','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000006,to_date('20/8/2021, 17:8:56','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000012,30000003,to_date('1/1/2021, 8:49:36','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000010,30000018,to_date('11/9/2021, 11:28:25','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000002,30000009,to_date('20/8/2021, 9:30:51','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000001,30000010,to_date('17/1/2021, 12:14:22','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000013,to_date('19/3/2021, 14:1:19','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000005,30000010,to_date('8/10/2021, 8:11:21','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000011,30000017,to_date('26/12/2021, 18:21:41','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000014,to_date('13/3/2021, 15:12:27','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000003,30000007,to_date('26/8/2021, 13:10:58','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000008,30000020,to_date('2/4/2021, 14:49:43','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000000,30000009,to_date('6/12/2021, 10:16:17','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000009,30000010,to_date('12/3/2021, 10:40:39','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000011,to_date('26/8/2021, 10:42:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000006,to_date('12/1/2021, 19:33:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000006,30000019,to_date('28/1/2021, 9:53:14','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000001,30000008,to_date('22/6/2021, 13:17:18','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000017,to_date('13/3/2021, 8:12:42','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000012,30000009,to_date('12/9/2021, 19:48:57','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000002,30000005,to_date('19/7/2021, 18:22:8','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000009,30000015,to_date('29/8/2021, 19:29:10','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000005,30000014,to_date('8/3/2021, 12:56:42','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000004,30000013,to_date('2/8/2021, 11:30:35','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000010,30000012,to_date('10/2/2021, 12:20:44','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000017,to_date('10/9/2021, 8:59:4','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000007,30000013,to_date('9/11/2021, 19:47:36','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000020,to_date('10/11/2021, 14:38:43','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000001,30000007,to_date('7/9/2021, 11:41:10','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000015,to_date('23/10/2021, 12:10:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000002,30000010,to_date('14/10/2021, 18:3:7','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000012,30000013,to_date('9/6/2021, 11:45:0','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000002,30000007,to_date('26/12/2021, 15:26:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000010,30000014,to_date('23/9/2021, 16:53:47','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000000,30000013,to_date('27/2/2021, 8:7:42','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000004,30000019,to_date('7/8/2021, 8:53:25','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000000,30000013,to_date('16/8/2021, 17:14:32','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000006,30000018,to_date('19/11/2021, 18:26:10','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000008,30000019,to_date('27/9/2021, 12:12:15','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000004,30000015,to_date('8/7/2021, 18:13:0','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000011,30000010,to_date('2/7/2021, 10:3:6','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000004,30000019,to_date('16/12/2021, 12:24:39','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000005,30000015,to_date('26/11/2021, 18:27:56','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000001,30000001,to_date('29/9/2021, 16:7:33','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000016,to_date('1/6/2021, 16:45:7','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000012,30000009,to_date('5/9/2021, 13:40:31','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000012,30000010,to_date('4/11/2021, 15:46:25','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000009,30000016,to_date('4/6/2021, 18:47:46','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000020,to_date('22/1/2021, 10:35:53','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000008,30000015,to_date('29/11/2021, 17:53:41','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000006,30000007,to_date('27/8/2021, 10:11:8','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000010,30000010,to_date('25/10/2021, 16:30:53','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000008,30000012,to_date('27/4/2021, 15:13:57','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000009,30000012,to_date('23/1/2021, 12:7:9','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000008,30000006,to_date('10/2/2021, 15:4:50','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000002,30000010,to_date('13/1/2021, 8:28:6','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000010,to_date('17/7/2021, 18:30:45','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000001,30000015,to_date('22/8/2021, 8:57:14','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000004,30000013,to_date('6/6/2021, 16:42:31','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000003,30000012,to_date('27/6/2021, 15:2:25','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000009,30000009,to_date('16/1/2021, 8:10:40','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000008,30000010,to_date('25/5/2021, 14:18:21','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000008,to_date('6/11/2021, 9:29:4','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000002,30000007,to_date('22/4/2021, 15:29:33','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000009,30000013,to_date('29/9/2021, 8:10:27','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000007,30000018,to_date('6/12/2021, 16:30:23','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000003,30000019,to_date('24/11/2021, 11:48:41','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000011,30000005,to_date('11/12/2021, 14:27:30','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000002,30000003,to_date('14/9/2021, 13:41:1','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000008,30000015,to_date('15/2/2021, 15:25:38','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000000,30000009,to_date('22/10/2021, 17:32:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000001,30000016,to_date('5/4/2021, 17:56:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000002,30000019,to_date('14/5/2021, 13:15:29','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000006,30000005,to_date('6/9/2021, 13:3:46','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000009,30000013,to_date('16/11/2021, 15:28:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000012,30000020,to_date('2/2/2021, 17:1:59','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000004,30000007,to_date('3/5/2021, 8:35:3','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000009,30000017,to_date('5/8/2021, 12:21:16','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000005,30000008,to_date('22/9/2021, 15:55:39','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000007,30000009,to_date('4/11/2021, 14:43:37','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000001,30000005,to_date('15/10/2021, 14:32:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000003,30000006,to_date('24/1/2021, 14:44:16','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000012,30000007,to_date('11/12/2021, 12:6:9','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000006,30000013,to_date('9/4/2021, 18:7:55','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000003,30000017,to_date('12/8/2021, 16:22:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000005,30000010,to_date('17/8/2021, 9:38:53','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000009,30000018,to_date('19/3/2021, 9:29:32','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000003,30000020,to_date('8/9/2021, 10:53:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000002,30000012,to_date('24/9/2021, 18:11:48','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000010,30000015,to_date('8/8/2021, 8:24:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000018,to_date('1/2/2021, 10:10:29','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000000,30000011,to_date('17/4/2021, 9:30:33','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000008,30000015,to_date('16/1/2021, 15:39:52','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000001,30000013,to_date('28/11/2021, 19:42:37','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000010,30000020,to_date('16/7/2021, 8:9:8','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000002,30000013,to_date('19/9/2021, 14:10:48','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000008,30000014,to_date('26/4/2021, 11:25:51','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000002,30000007,to_date('17/9/2021, 19:5:20','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000019,to_date('21/5/2021, 19:37:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000004,30000020,to_date('19/11/2021, 17:5:48','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000007,30000005,to_date('4/2/2021, 9:36:39','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000000,30000015,to_date('22/2/2021, 12:56:23','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000011,30000016,to_date('4/4/2021, 9:37:38','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000003,30000017,to_date('2/5/2021, 10:13:51','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000020,to_date('15/3/2021, 8:41:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000009,30000010,to_date('28/5/2021, 10:18:32','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000005,30000019,to_date('1/2/2021, 14:38:2','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000001,30000015,to_date('3/4/2021, 18:4:18','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000012,30000016,to_date('13/3/2021, 8:48:11','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000003,30000009,to_date('19/6/2021, 13:41:21','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000004,30000007,to_date('1/4/2021, 15:46:18','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000004,30000018,to_date('8/7/2021, 10:54:17','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000003,30000010,to_date('6/11/2021, 15:1:22','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000009,30000007,to_date('26/4/2021, 13:0:28','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000008,30000016,to_date('20/8/2021, 17:45:10','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000001,30000013,to_date('18/6/2021, 13:36:12','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000019,to_date('27/6/2021, 16:53:13','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000005,30000001,to_date('25/2/2021, 13:38:17','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70003,2000000007,30000015,to_date('20/10/2021, 14:12:56','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000007,30000006,to_date('25/8/2021, 8:3:27','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000003,30000006,to_date('26/1/2021, 19:0:7','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000001,30000019,to_date('20/12/2021, 16:2:21','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70004,2000000003,30000020,to_date('4/10/2021, 14:29:23','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70001,2000000004,30000009,to_date('9/2/2021, 17:39:19','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70002,2000000007,30000012,to_date('6/11/2021, 9:23:23','DD/MM/YYYY, HH24/MI/SS'));
insert into TRANZACTIE
values(seq_tranzactie_id.nextval, 70000,2000000004,30000006,to_date('11/4/2021, 13:51:9','DD/MM/YYYY, HH24/MI/SS'));



insert into APARATE_TRANZACTIE values(900000000000, 100145, 8);
insert into APARATE_TRANZACTIE values(900000000001, 100011, 5);
insert into APARATE_TRANZACTIE values(900000000002, 100069, 6);
insert into APARATE_TRANZACTIE values(900000000002, 100100, 3);
insert into APARATE_TRANZACTIE values(900000000003, 100076, 6);
insert into APARATE_TRANZACTIE values(900000000003, 100047, 5);
insert into APARATE_TRANZACTIE values(900000000004, 100116, 1);
insert into APARATE_TRANZACTIE values(900000000004, 100072, 3);
insert into APARATE_TRANZACTIE values(900000000005, 100128, 2);
insert into APARATE_TRANZACTIE values(900000000006, 100095, 4);
insert into APARATE_TRANZACTIE values(900000000007, 100022, 3);
insert into APARATE_TRANZACTIE values(900000000008, 100154, 7);
insert into APARATE_TRANZACTIE values(900000000008, 100101, 3);
insert into APARATE_TRANZACTIE values(900000000009, 100136, 1);
insert into APARATE_TRANZACTIE values(900000000009, 100105, 3);
insert into APARATE_TRANZACTIE values(900000000010, 100052, 2);
insert into APARATE_TRANZACTIE values(900000000011, 100035, 2);
insert into APARATE_TRANZACTIE values(900000000011, 100003, 4);
insert into APARATE_TRANZACTIE values(900000000012, 100118, 2);
insert into APARATE_TRANZACTIE values(900000000013, 100097, 2);
insert into APARATE_TRANZACTIE values(900000000014, 100072, 8);
insert into APARATE_TRANZACTIE values(900000000015, 100128, 9);
insert into APARATE_TRANZACTIE values(900000000015, 100115, 7);
insert into APARATE_TRANZACTIE values(900000000016, 100029, 5);
insert into APARATE_TRANZACTIE values(900000000017, 100008, 8);
insert into APARATE_TRANZACTIE values(900000000018, 100089, 4);
insert into APARATE_TRANZACTIE values(900000000018, 100063, 8);
insert into APARATE_TRANZACTIE values(900000000019, 100128, 6);
insert into APARATE_TRANZACTIE values(900000000019, 100020, 2);
insert into APARATE_TRANZACTIE values(900000000020, 100039, 5);
insert into APARATE_TRANZACTIE values(900000000020, 100122, 3);
insert into APARATE_TRANZACTIE values(900000000021, 100059, 8);
insert into APARATE_TRANZACTIE values(900000000021, 100122, 9);
insert into APARATE_TRANZACTIE values(900000000022, 100046, 2);
insert into APARATE_TRANZACTIE values(900000000022, 100039, 1);
insert into APARATE_TRANZACTIE values(900000000023, 100100, 2);
insert into APARATE_TRANZACTIE values(900000000024, 100063, 6);
insert into APARATE_TRANZACTIE values(900000000024, 100029, 8);
insert into APARATE_TRANZACTIE values(900000000025, 100142, 6);
insert into APARATE_TRANZACTIE values(900000000026, 100022, 7);
insert into APARATE_TRANZACTIE values(900000000027, 100104, 6);
insert into APARATE_TRANZACTIE values(900000000027, 100075, 1);
insert into APARATE_TRANZACTIE values(900000000028, 100141, 4);
insert into APARATE_TRANZACTIE values(900000000029, 100034, 4);
insert into APARATE_TRANZACTIE values(900000000030, 100117, 2);
insert into APARATE_TRANZACTIE values(900000000030, 100012, 8);
insert into APARATE_TRANZACTIE values(900000000031, 100041, 6);
insert into APARATE_TRANZACTIE values(900000000031, 100022, 6);
insert into APARATE_TRANZACTIE values(900000000032, 100005, 5);
insert into APARATE_TRANZACTIE values(900000000032, 100003, 9);
insert into APARATE_TRANZACTIE values(900000000033, 100151, 5);
insert into APARATE_TRANZACTIE values(900000000034, 100014, 4);
insert into APARATE_TRANZACTIE values(900000000034, 100152, 3);
insert into APARATE_TRANZACTIE values(900000000035, 100046, 4);
insert into APARATE_TRANZACTIE values(900000000035, 100133, 5);
insert into APARATE_TRANZACTIE values(900000000036, 100145, 1);
insert into APARATE_TRANZACTIE values(900000000036, 100144, 5);
insert into APARATE_TRANZACTIE values(900000000037, 100149, 2);
insert into APARATE_TRANZACTIE values(900000000038, 100135, 9);
insert into APARATE_TRANZACTIE values(900000000038, 100077, 8);
insert into APARATE_TRANZACTIE values(900000000039, 100009, 4);
insert into APARATE_TRANZACTIE values(900000000040, 100115, 5);
insert into APARATE_TRANZACTIE values(900000000041, 100070, 8);
insert into APARATE_TRANZACTIE values(900000000041, 100028, 2);
insert into APARATE_TRANZACTIE values(900000000042, 100060, 2);
insert into APARATE_TRANZACTIE values(900000000043, 100124, 3);
insert into APARATE_TRANZACTIE values(900000000044, 100033, 7);
insert into APARATE_TRANZACTIE values(900000000045, 100017, 4);
insert into APARATE_TRANZACTIE values(900000000045, 100135, 7);
insert into APARATE_TRANZACTIE values(900000000046, 100099, 7);
insert into APARATE_TRANZACTIE values(900000000046, 100063, 2);
insert into APARATE_TRANZACTIE values(900000000047, 100109, 1);
insert into APARATE_TRANZACTIE values(900000000048, 100005, 7);
insert into APARATE_TRANZACTIE values(900000000049, 100123, 1);
insert into APARATE_TRANZACTIE values(900000000050, 100023, 6);
insert into APARATE_TRANZACTIE values(900000000050, 100036, 8);
insert into APARATE_TRANZACTIE values(900000000051, 100155, 2);
insert into APARATE_TRANZACTIE values(900000000051, 100143, 5);
insert into APARATE_TRANZACTIE values(900000000052, 100143, 3);
insert into APARATE_TRANZACTIE values(900000000052, 100077, 6);
insert into APARATE_TRANZACTIE values(900000000053, 100032, 4);
insert into APARATE_TRANZACTIE values(900000000053, 100121, 8);
insert into APARATE_TRANZACTIE values(900000000054, 100011, 2);
insert into APARATE_TRANZACTIE values(900000000054, 100129, 8);
insert into APARATE_TRANZACTIE values(900000000055, 100122, 4);
insert into APARATE_TRANZACTIE values(900000000056, 100081, 5);
insert into APARATE_TRANZACTIE values(900000000056, 100032, 8);
insert into APARATE_TRANZACTIE values(900000000057, 100152, 6);
insert into APARATE_TRANZACTIE values(900000000058, 100136, 9);
insert into APARATE_TRANZACTIE values(900000000058, 100042, 8);
insert into APARATE_TRANZACTIE values(900000000059, 100096, 7);
insert into APARATE_TRANZACTIE values(900000000059, 100119, 3);
insert into APARATE_TRANZACTIE values(900000000060, 100045, 4);
insert into APARATE_TRANZACTIE values(900000000060, 100074, 2);
insert into APARATE_TRANZACTIE values(900000000061, 100045, 1);
insert into APARATE_TRANZACTIE values(900000000061, 100060, 1);
insert into APARATE_TRANZACTIE values(900000000062, 100040, 8);
insert into APARATE_TRANZACTIE values(900000000062, 100049, 3);
insert into APARATE_TRANZACTIE values(900000000063, 100129, 5);
insert into APARATE_TRANZACTIE values(900000000063, 100068, 9);
insert into APARATE_TRANZACTIE values(900000000064, 100155, 1);
insert into APARATE_TRANZACTIE values(900000000065, 100080, 7);
insert into APARATE_TRANZACTIE values(900000000066, 100027, 5);
insert into APARATE_TRANZACTIE values(900000000066, 100046, 5);
insert into APARATE_TRANZACTIE values(900000000067, 100143, 2);
insert into APARATE_TRANZACTIE values(900000000068, 100076, 2);
insert into APARATE_TRANZACTIE values(900000000069, 100088, 4);
insert into APARATE_TRANZACTIE values(900000000070, 100150, 8);
insert into APARATE_TRANZACTIE values(900000000071, 100142, 8);
insert into APARATE_TRANZACTIE values(900000000072, 100083, 3);
insert into APARATE_TRANZACTIE values(900000000073, 100064, 1);
insert into APARATE_TRANZACTIE values(900000000074, 100005, 9);
insert into APARATE_TRANZACTIE values(900000000074, 100084, 4);
insert into APARATE_TRANZACTIE values(900000000075, 100126, 2);
insert into APARATE_TRANZACTIE values(900000000075, 100121, 5);
insert into APARATE_TRANZACTIE values(900000000076, 100034, 7);
insert into APARATE_TRANZACTIE values(900000000076, 100111, 9);
insert into APARATE_TRANZACTIE values(900000000077, 100135, 7);
insert into APARATE_TRANZACTIE values(900000000077, 100093, 3);
insert into APARATE_TRANZACTIE values(900000000078, 100036, 5);
insert into APARATE_TRANZACTIE values(900000000078, 100138, 6);
insert into APARATE_TRANZACTIE values(900000000079, 100107, 6);
insert into APARATE_TRANZACTIE values(900000000080, 100066, 3);
insert into APARATE_TRANZACTIE values(900000000080, 100060, 3);
insert into APARATE_TRANZACTIE values(900000000081, 100037, 4);
insert into APARATE_TRANZACTIE values(900000000081, 100003, 4);
insert into APARATE_TRANZACTIE values(900000000082, 100108, 1);
insert into APARATE_TRANZACTIE values(900000000083, 100099, 8);
insert into APARATE_TRANZACTIE values(900000000083, 100064, 7);
insert into APARATE_TRANZACTIE values(900000000084, 100101, 4);
insert into APARATE_TRANZACTIE values(900000000084, 100031, 2);
insert into APARATE_TRANZACTIE values(900000000085, 100103, 5);
insert into APARATE_TRANZACTIE values(900000000085, 100123, 4);
insert into APARATE_TRANZACTIE values(900000000086, 100086, 8);
insert into APARATE_TRANZACTIE values(900000000086, 100057, 3);
insert into APARATE_TRANZACTIE values(900000000087, 100154, 8);
insert into APARATE_TRANZACTIE values(900000000088, 100036, 2);
insert into APARATE_TRANZACTIE values(900000000088, 100148, 2);
insert into APARATE_TRANZACTIE values(900000000089, 100106, 7);
insert into APARATE_TRANZACTIE values(900000000089, 100134, 3);
insert into APARATE_TRANZACTIE values(900000000090, 100108, 4);
insert into APARATE_TRANZACTIE values(900000000091, 100019, 3);
insert into APARATE_TRANZACTIE values(900000000091, 100049, 8);
insert into APARATE_TRANZACTIE values(900000000092, 100010, 4);
insert into APARATE_TRANZACTIE values(900000000092, 100047, 1);
insert into APARATE_TRANZACTIE values(900000000093, 100106, 2);
insert into APARATE_TRANZACTIE values(900000000094, 100000, 4);
insert into APARATE_TRANZACTIE values(900000000094, 100096, 5);
insert into APARATE_TRANZACTIE values(900000000095, 100050, 9);
insert into APARATE_TRANZACTIE values(900000000096, 100093, 9);
insert into APARATE_TRANZACTIE values(900000000096, 100066, 9);
insert into APARATE_TRANZACTIE values(900000000097, 100126, 6);
insert into APARATE_TRANZACTIE values(900000000097, 100014, 2);
insert into APARATE_TRANZACTIE values(900000000098, 100044, 7);
insert into APARATE_TRANZACTIE values(900000000099, 100053, 3);
insert into APARATE_TRANZACTIE values(900000000100, 100140, 3);
insert into APARATE_TRANZACTIE values(900000000100, 100101, 7);
insert into APARATE_TRANZACTIE values(900000000101, 100080, 8);
insert into APARATE_TRANZACTIE values(900000000101, 100018, 5);
insert into APARATE_TRANZACTIE values(900000000102, 100066, 3);
insert into APARATE_TRANZACTIE values(900000000102, 100101, 3);
insert into APARATE_TRANZACTIE values(900000000103, 100119, 1);
insert into APARATE_TRANZACTIE values(900000000104, 100093, 1);
insert into APARATE_TRANZACTIE values(900000000105, 100031, 1);
insert into APARATE_TRANZACTIE values(900000000106, 100029, 5);
insert into APARATE_TRANZACTIE values(900000000106, 100127, 7);
insert into APARATE_TRANZACTIE values(900000000107, 100010, 6);
insert into APARATE_TRANZACTIE values(900000000107, 100007, 3);
insert into APARATE_TRANZACTIE values(900000000108, 100111, 5);
insert into APARATE_TRANZACTIE values(900000000109, 100142, 4);
insert into APARATE_TRANZACTIE values(900000000109, 100088, 2);
insert into APARATE_TRANZACTIE values(900000000110, 100015, 9);
insert into APARATE_TRANZACTIE values(900000000111, 100018, 1);
insert into APARATE_TRANZACTIE values(900000000112, 100003, 3);
insert into APARATE_TRANZACTIE values(900000000112, 100153, 9);
insert into APARATE_TRANZACTIE values(900000000113, 100005, 4);
insert into APARATE_TRANZACTIE values(900000000114, 100030, 5);
insert into APARATE_TRANZACTIE values(900000000115, 100029, 8);
insert into APARATE_TRANZACTIE values(900000000115, 100068, 7);
insert into APARATE_TRANZACTIE values(900000000116, 100077, 1);
insert into APARATE_TRANZACTIE values(900000000116, 100056, 7);
insert into APARATE_TRANZACTIE values(900000000117, 100154, 8);
insert into APARATE_TRANZACTIE values(900000000118, 100112, 4);
insert into APARATE_TRANZACTIE values(900000000119, 100029, 2);
insert into APARATE_TRANZACTIE values(900000000119, 100139, 8);
insert into APARATE_TRANZACTIE values(900000000120, 100135, 4);
insert into APARATE_TRANZACTIE values(900000000121, 100044, 9);
insert into APARATE_TRANZACTIE values(900000000122, 100061, 2);
insert into APARATE_TRANZACTIE values(900000000123, 100088, 3);
insert into APARATE_TRANZACTIE values(900000000123, 100147, 3);
insert into APARATE_TRANZACTIE values(900000000124, 100010, 8);
insert into APARATE_TRANZACTIE values(900000000124, 100008, 1);
insert into APARATE_TRANZACTIE values(900000000125, 100002, 8);
insert into APARATE_TRANZACTIE values(900000000126, 100133, 9);
insert into APARATE_TRANZACTIE values(900000000127, 100008, 7);
insert into APARATE_TRANZACTIE values(900000000127, 100095, 6);
insert into APARATE_TRANZACTIE values(900000000128, 100045, 3);
insert into APARATE_TRANZACTIE values(900000000128, 100072, 7);
insert into APARATE_TRANZACTIE values(900000000129, 100139, 7);
insert into APARATE_TRANZACTIE values(900000000130, 100045, 2);
insert into APARATE_TRANZACTIE values(900000000130, 100127, 1);
insert into APARATE_TRANZACTIE values(900000000131, 100119, 3);
insert into APARATE_TRANZACTIE values(900000000132, 100076, 7);
insert into APARATE_TRANZACTIE values(900000000132, 100006, 7);
insert into APARATE_TRANZACTIE values(900000000133, 100077, 3);
insert into APARATE_TRANZACTIE values(900000000134, 100068, 8);
insert into APARATE_TRANZACTIE values(900000000135, 100003, 4);
insert into APARATE_TRANZACTIE values(900000000136, 100019, 7);
insert into APARATE_TRANZACTIE values(900000000137, 100055, 1);
insert into APARATE_TRANZACTIE values(900000000138, 100028, 2);
insert into APARATE_TRANZACTIE values(900000000138, 100002, 6);
insert into APARATE_TRANZACTIE values(900000000139, 100101, 5);
insert into APARATE_TRANZACTIE values(900000000139, 100067, 1);
insert into APARATE_TRANZACTIE values(900000000140, 100000, 5);
insert into APARATE_TRANZACTIE values(900000000141, 100015, 4);
insert into APARATE_TRANZACTIE values(900000000142, 100067, 5);
insert into APARATE_TRANZACTIE values(900000000142, 100113, 9);
insert into APARATE_TRANZACTIE values(900000000143, 100043, 3);
insert into APARATE_TRANZACTIE values(900000000143, 100068, 5);
insert into APARATE_TRANZACTIE values(900000000144, 100083, 2);
insert into APARATE_TRANZACTIE values(900000000145, 100101, 6);
insert into APARATE_TRANZACTIE values(900000000145, 100124, 3);
insert into APARATE_TRANZACTIE values(900000000146, 100022, 5);
insert into APARATE_TRANZACTIE values(900000000147, 100001, 1);
insert into APARATE_TRANZACTIE values(900000000148, 100127, 7);
insert into APARATE_TRANZACTIE values(900000000148, 100089, 2);
insert into APARATE_TRANZACTIE values(900000000149, 100086, 2);
insert into APARATE_TRANZACTIE values(900000000149, 100009, 3);
insert into APARATE_TRANZACTIE values(900000000150, 100037, 9);
insert into APARATE_TRANZACTIE values(900000000150, 100034, 1);
insert into APARATE_TRANZACTIE values(900000000151, 100013, 8);
insert into APARATE_TRANZACTIE values(900000000152, 100097, 1);
insert into APARATE_TRANZACTIE values(900000000153, 100080, 6);
insert into APARATE_TRANZACTIE values(900000000154, 100148, 6);
insert into APARATE_TRANZACTIE values(900000000154, 100025, 1);
insert into APARATE_TRANZACTIE values(900000000155, 100084, 2);
insert into APARATE_TRANZACTIE values(900000000156, 100006, 2);
insert into APARATE_TRANZACTIE values(900000000156, 100145, 5);
insert into APARATE_TRANZACTIE values(900000000157, 100110, 2);
insert into APARATE_TRANZACTIE values(900000000157, 100018, 3);
insert into APARATE_TRANZACTIE values(900000000158, 100106, 4);
insert into APARATE_TRANZACTIE values(900000000159, 100010, 5);
insert into APARATE_TRANZACTIE values(900000000159, 100123, 4);
insert into APARATE_TRANZACTIE values(900000000160, 100006, 9);
insert into APARATE_TRANZACTIE values(900000000160, 100097, 2);
insert into APARATE_TRANZACTIE values(900000000161, 100105, 6);
insert into APARATE_TRANZACTIE values(900000000162, 100128, 7);
insert into APARATE_TRANZACTIE values(900000000162, 100030, 6);
insert into APARATE_TRANZACTIE values(900000000163, 100029, 7);
insert into APARATE_TRANZACTIE values(900000000164, 100058, 2);
insert into APARATE_TRANZACTIE values(900000000165, 100032, 6);
insert into APARATE_TRANZACTIE values(900000000165, 100061, 8);
insert into APARATE_TRANZACTIE values(900000000166, 100114, 6);
insert into APARATE_TRANZACTIE values(900000000167, 100041, 9);
insert into APARATE_TRANZACTIE values(900000000168, 100049, 7);
insert into APARATE_TRANZACTIE values(900000000168, 100040, 9);
insert into APARATE_TRANZACTIE values(900000000169, 100009, 6);
insert into APARATE_TRANZACTIE values(900000000169, 100004, 2);
insert into APARATE_TRANZACTIE values(900000000170, 100058, 2);
insert into APARATE_TRANZACTIE values(900000000171, 100133, 4);
insert into APARATE_TRANZACTIE values(900000000172, 100030, 7);
insert into APARATE_TRANZACTIE values(900000000172, 100060, 1);
insert into APARATE_TRANZACTIE values(900000000173, 100080, 4);
insert into APARATE_TRANZACTIE values(900000000173, 100009, 3);
insert into APARATE_TRANZACTIE values(900000000174, 100100, 7);
insert into APARATE_TRANZACTIE values(900000000174, 100019, 2);
insert into APARATE_TRANZACTIE values(900000000175, 100129, 6);
insert into APARATE_TRANZACTIE values(900000000176, 100107, 4);
insert into APARATE_TRANZACTIE values(900000000177, 100055, 7);
insert into APARATE_TRANZACTIE values(900000000178, 100016, 2);
insert into APARATE_TRANZACTIE values(900000000178, 100072, 1);
insert into APARATE_TRANZACTIE values(900000000179, 100155, 4);
insert into APARATE_TRANZACTIE values(900000000180, 100091, 5);
insert into APARATE_TRANZACTIE values(900000000180, 100043, 4);
insert into APARATE_TRANZACTIE values(900000000181, 100014, 1);
insert into APARATE_TRANZACTIE values(900000000181, 100071, 3);
insert into APARATE_TRANZACTIE values(900000000182, 100114, 5);
insert into APARATE_TRANZACTIE values(900000000182, 100045, 7);
insert into APARATE_TRANZACTIE values(900000000183, 100125, 7);
insert into APARATE_TRANZACTIE values(900000000183, 100101, 7);
insert into APARATE_TRANZACTIE values(900000000184, 100000, 6);
insert into APARATE_TRANZACTIE values(900000000184, 100116, 3);
insert into APARATE_TRANZACTIE values(900000000185, 100114, 6);
insert into APARATE_TRANZACTIE values(900000000186, 100018, 7);
insert into APARATE_TRANZACTIE values(900000000187, 100148, 7);
insert into APARATE_TRANZACTIE values(900000000187, 100147, 9);
insert into APARATE_TRANZACTIE values(900000000188, 100116, 6);
insert into APARATE_TRANZACTIE values(900000000189, 100074, 5);
insert into APARATE_TRANZACTIE values(900000000190, 100008, 2);
insert into APARATE_TRANZACTIE values(900000000190, 100099, 7);
insert into APARATE_TRANZACTIE values(900000000191, 100020, 7);
insert into APARATE_TRANZACTIE values(900000000192, 100075, 9);
insert into APARATE_TRANZACTIE values(900000000193, 100123, 3);
insert into APARATE_TRANZACTIE values(900000000194, 100079, 4);
insert into APARATE_TRANZACTIE values(900000000195, 100099, 7);
insert into APARATE_TRANZACTIE values(900000000196, 100008, 6);
insert into APARATE_TRANZACTIE values(900000000196, 100098, 2);
insert into APARATE_TRANZACTIE values(900000000197, 100097, 9);
insert into APARATE_TRANZACTIE values(900000000197, 100144, 9);
insert into APARATE_TRANZACTIE values(900000000198, 100152, 6);
insert into APARATE_TRANZACTIE values(900000000198, 100003, 4);
insert into APARATE_TRANZACTIE values(900000000199, 100018, 3);
insert into APARATE_TRANZACTIE values(900000000199, 100098, 3);
insert into APARATE_TRANZACTIE values(900000000200, 100083, 7);

update MAGAZIN
set id_manager = 30000000
where id_magazin = 70000;

update MAGAZIN
set id_manager = 30000001
where id_magazin = 70001;

update MAGAZIN
set id_manager = 30000002
where id_magazin = 70002;

update MAGAZIN
set id_manager = 30000003
where id_magazin = 70003;

update MAGAZIN
set id_manager = 30000004
where id_magazin = 70004;
