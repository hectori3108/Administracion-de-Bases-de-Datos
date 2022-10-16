DROP TABLE CONCESION;
DROP TABLE FALTA;
DROP TABLE ESPACIO_PUESTO;
DROP TABLE ESPACIO_ZONA_COMERCIAL;
DROP TABLE ESPACIO_INSTALACION_AUXILIAR;
DROP TABLE ESPACIO;
DROP TABLE MERCADO;
DROP TABLE ESTABLECIMIENTO;
DROP TABLE TITULAR;

DROP TYPE tipoPers;
DROP TYPE tipoConc;
DROP TYPE Estado;
DROP TYPE medioConcesion;
DROP TYPE tipoGestion;
DROP TYPE tipoFalta;

CREATE TYPE tipoPers AS
ENUM('fisica','juridica');
CREATE TYPE tipoConc AS
ENUM('fijo','especial','temporal');
CREATE TYPE Estado AS
ENUM('asignada','sin_asignar','en_proceso_asignacion','bloqueada');
CREATE TYPE medioConcesion AS
ENUM('subasta','concurso','adjudicacion_directa','derechos_fallecimiento','intervivos');
CREATE TYPE tipoGestion AS
ENUM('gestion_Directa','gestion_Indirecta');
CREATE TYPE tipoFalta AS
ENUM('leve','grave','muy_grave');

CREATE TABLE TITULAR(
    dni                char(9) NOT NULL ,
    tipoPersona        tipoPers,
    nombre             char(20) NOT NULL,
    apellidos          char(20) NOT NULL,
    telefono           INTEGER NOT NULL,
    correo_electronico char(50) NOT NULL,
    direcion           char(100) NOT NULL,
    primary key (dni)
);
CREATE TABLE MERCADO(
    nombre             char(25) NOT NULL,
    direccion           char(100) NOT NULL,
    gestion            tipoGestion,
    primary key (nombre)
);
CREATE TABLE ESTABLECIMIENTO(
    nombre             char(25) NOT NULL,
    primary key (nombre)
);
CREATE TABLE ESPACIO(
    id                 INTEGER NOT NULL,
    dniEsp             char(9) NOT NULL,
    nombreEsp          char(25) NOT NULL,
    nombreEst          char(25) NOT NULL,
    fianza             INTEGER CHECK (fianza>= 0),
    obras              BOOLEAN NOT NULL,
    importeAnual       decimal(8,2) CHECK (importeAnual >= 0),
    calle              char(100) NOT NULL,
    precioAlquiler     decimal(8,2) CHECK ( precioAlquiler >= 0),
    primary key (id),
    foreign key (dniEsp) references TITULAR
      ON DELETE SET DEFAULT
      ON UPDATE CASCADE,
    foreign key (nombreEsp) references MERCADO
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    foreign key (nombreEst) references ESTABLECIMIENTO
      ON DELETE SET DEFAULT
      ON UPDATE CASCADE
);
CREATE TABLE ESPACIO_PUESTO(
    id                 INTEGER NOT NULL,
    tipoVenta          char(25) NOT NULL,
    superficie         decimal(5,2) CHECK(superficie >= 0),
    primary key (id),
    foreign key (id) references ESPACIO
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
CREATE TABLE ESPACIO_INSTALACION_AUXILIAR(
    id                 INTEGER NOT NULL,
    servicio           char(25) NOT NULL,
    primary key (id),
    foreign key (id) references ESPACIO
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
CREATE TABLE ESPACIO_ZONA_COMERCIAL(
    id                 INTEGER NOT NULL CHECK ( id>= 0),
    tipoVenta          char(25) NOT NULL,
    superficie         decimal(5,2),
    primary key (id),
    foreign key (id) references ESPACIO
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
CREATE TABLE CONCESION(
    inicioConcesion    date NOT NULL CHECK (inicioConcesion< current_date),
    idConc             INTEGER NOT NULL,
    dniConc            char(9) NOT NULL,
    tipo               tipoConc,
    estado             Estado,
    medio              medioConcesion,
    fechaTraspaso      date CHECK (fechaTraspaso< current_date),
    precioTraspaso     decimal(15,2) CHECK (precioTraspaso>= 0),
    finConcesion       date NOT NULL CHECK (inicioConcesion< finConcesion),
    prorroga           BOOLEAN NOT NULL,
    finProrroga        date CHECK (finConcesion < finProrroga),

    primary key (idConc),
    foreign key (dniConc) references TITULAR
      ON UPDATE SET DEFAULT
);
CREATE TABLE FALTA(
    fecha              date NOT NULL CHECK (fecha < current_date),
    dniFalta           char(9) NOT NULL,
    idemFalta          INTEGER NOT NULL,
    idFalta            INTEGER NOT NULL,
    tipo               tipoFalta,
    multa              decimal(10,2) CHECK (multa>=0),
    derechos           BOOLEAN NOT NULL,
    motivo             char(10000) NOT NULL,
    contador           INTEGER CHECK (contador>=0),
    primary key (idemFalta),
    foreign key (idFalta) references ESPACIO
      ON DELETE CASCADE
      ON UPDATE SET DEFAULT,
    foreign key (dniFalta) references TITULAR
      ON DELETE CASCADE
      ON UPDATE SET DEFAULT
);

INSERT INTO TITULAR VALUES ('99999999X','juridica' :: tipoPers,'Ayuntamiento','Mercado Bilbao',944010010,'010@bilbao.eus','Plaza Ernesto Erkoreka Nº 1 Piso:1ºA');

INSERT INTO TITULAR VALUES ('12345678A','fisica' :: tipoPers,'Carlos','Lopez Torres',651474896,'carloslopeztorres@gmail.com','C\Torre Nº 24 Piso:2ºA');
INSERT INTO TITULAR VALUES ('12445678B','fisica' :: tipoPers,'Carla','Pulido Torres',651688996,'carlapulidotorres@gmail.com','C\Mino Nº 1 Piso:8ºA');
INSERT INTO TITULAR VALUES ('12348648C','fisica' :: tipoPers,'Juan','Pages Martin',652414895,'juanpagesmartin@gmail.com','C\Nilo Nº 12 Piso:7ºD');
INSERT INTO TITULAR VALUES ('12345678D','juridica' :: tipoPers,'Hector','Menta Fresca',659474892,'hectormentafresca@hotmail.com','C\Orbigo Nº 14 Piso:3ºA');
INSERT INTO TITULAR VALUES ('12345678E','juridica' :: tipoPers,'Monica','Galindo Garcia',751474896,'monicagalindogarcia@gmail.com','C\Esla Nº 4 Piso:7ºE');
INSERT INTO TITULAR VALUES ('12345658F','fisica' :: tipoPers,'Alejandro','Medario Manzano',751874296,'alejandromedariomanzano@hotmail.com','C\Torre Nº 24 Piso:2ºD');
INSERT INTO TITULAR VALUES ('12345638G','juridica' :: tipoPers,'Luis','Gabilondo Hernandez',851474896,'luisgabilondohernandez@gmail.com','C\Arlanza Nº 24 Piso:5ºA');
INSERT INTO TITULAR VALUES ('12345672H','fisica' :: tipoPers,'Hector','Nudo Diez',651474896,'hectornudodiez@gmail.com','C\Turras Nº 12 Piso:1ºC');
INSERT INTO TITULAR VALUES ('52345678I','juridica' :: tipoPers,'Hector','Tilla Since',951474296,'hectortillasince@gmail.com','C\Arlanzon Nº 17 Piso:1ºA');
INSERT INTO TITULAR VALUES ('62345678J','fisica' :: tipoPers,'Amparo','Loro Raro',351474899,'amparolororaro@gmail.com','C\Eume Nº 10 Piso:3ºD');
INSERT INTO TITULAR VALUES ('12325678K','juridica' :: tipoPers,'Carlos','Perez Gil',891474899,'carlosperezgil@gmail.com','C\Mino Nº 21 Piso:3ºA');
INSERT INTO TITULAR VALUES ('12325638L','fisica' :: tipoPers,'Debora','Derio Tonin',193464899,'deboradariotonin@gmail.com','C\Turia Nº 3 Piso:7ºA');
INSERT INTO TITULAR VALUES ('12325678M','juridica' :: tipoPers,'Cesar','Pages Martin',451474899,'cesarpagesmartin@gmail.com','C\Mino Nº 25 Piso:2ºA');
INSERT INTO TITULAR VALUES ('12327678N','juridica' :: tipoPers,'Mario','Perez Gil',698472859,'marioperezgil@gmail.com','C\Turras Nº 1 Piso:1ºD');

INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2015-05-10', 1,'12345678A','fijo' :: tipoConc,'asignada' :: Estado, 'subasta' :: medioConcesion,NULL, 2777.77 , '2020-05-20',TRUE,'2021-07-14');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2010-05-15', 2,'12345678A','temporal' :: tipoConc,'en_proceso_asignacion' :: Estado, 'intervivos' :: medioConcesion,NULL, 3492.0 , '2014-05-28',TRUE,'2014-12-15');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-08-11', 3,'12345678A','fijo' :: tipoConc,'asignada' :: Estado, 'concurso' :: medioConcesion,'2017-08-25', 277.45 , '2021-10-27',TRUE,'2022-09-20');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2015-06-16', 4,'12445678B','especial' :: tipoConc,'asignada' :: Estado, 'intervivos' :: medioConcesion ,NULL, 6256.0,'2018-12-17',TRUE,'2025-08-14');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2012-04-14', 5,'12445678B','fijo' :: tipoConc,'asignada' :: Estado, 'subasta' :: medioConcesion ,NULL, 6223.99,'2017-01-13',TRUE,'2018-05-20');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-10-18', 6,'12445678B','temporal' :: tipoConc,'en_proceso_asignacion' :: Estado, 'concurso' :: medioConcesion ,NULL, 2345.48,'2020-11-20',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2016-04-11', 7,'12348648C','temporal' :: tipoConc,'asignada' :: Estado, 'derechos_fallecimiento' :: medioConcesion,NULL, 193.50 , '2016-05-16',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2016-05-11', 8,'12345678D','fijo' :: tipoConc,'bloqueada' :: Estado, 'subasta' :: medioConcesion,'2019-07-17', 9193.50 , '2020-01-11',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2016-08-11', 9,'12345678E','especial' :: tipoConc,'bloqueada' :: Estado, 'concurso' :: medioConcesion ,NULL, 4193.75, '2020-04-21',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2020-01-28', 10,'12345678E','fijo' :: tipoConc,'bloqueada' :: Estado, 'intervivos' :: medioConcesion ,NULL, 4100.0, '2021-07-21',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2010-04-10', 11,'12345678E','fijo' :: tipoConc,'sin_asignar' :: Estado, 'subasta' :: medioConcesion ,NULL, 1023.63, '2011-01-01',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2016-12-11', 12,'12345658F','temporal' :: tipoConc,'bloqueada' :: Estado, 'subasta' :: medioConcesion ,NULL, 350.05, '2017-01-10',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-01-01', 13,'99999999X','fijo' :: tipoConc,'sin_asignar' :: Estado, 'derechos_fallecimiento' :: medioConcesion,NULL, 0.0, '2017-03-10',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2015-02-17', 14,'99999999X','temporal' :: tipoConc,'asignada' :: Estado, 'concurso' :: medioConcesion ,NULL, 3000.0, '2020-12-13',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2013-02-10', 15,'99999999X','especial' :: tipoConc,'sin_asignar' :: Estado, 'adjudicacion_directa' :: medioConcesion ,NULL, 5896.63 , '2013-12-04',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-04-20', 16,'99999999X','especial' :: tipoConc,'bloqueada' :: Estado, 'adjudicacion_directa' :: medioConcesion ,NULL, 3156.0 , '2019-05-07',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-02-12', 17,'12345638G','fijo' :: tipoConc,'asignada' :: Estado, 'concurso' :: medioConcesion ,'2019-06-25', 5236.10, '2021-11-15',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2014-07-14', 18,'12345638G','temporal' :: tipoConc,'sin_asignar' :: Estado, 'intervivos' :: medioConcesion ,NULL, 1948.56, '2016-10-07',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2011-10-10', 19,'12345638G','temporal' :: tipoConc,'asignada' :: Estado, 'concurso' :: medioConcesion ,'2015-08-05', 3168.00, '2011-12-15',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-06-29', 20,'12345672H','especial' :: tipoConc,'en_proceso_asignacion' :: Estado, 'concurso' :: medioConcesion,NULL, 3586.19 , '2020-04-18',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2004-04-15', 21,'12345672H','especial' :: tipoConc,'sin_asignar' :: Estado, 'subasta' :: medioConcesion,NULL, 7486.20, '2006-07-18',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2006-10-04', 22,'12345672H','especial' :: tipoConc,'bloqueada' :: Estado, 'subasta' :: medioConcesion,NULL, 9623.0 , '2009-10-21',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-08-31', 23,'52345678I','temporal' :: tipoConc,'bloqueada' :: Estado, 'concurso' :: medioConcesion,NULL, 586.19 , '2017-09-30',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-08-31', 24,'62345678J','temporal' :: tipoConc,'asignada' :: Estado, 'derechos_fallecimiento' :: medioConcesion , NULL,5642.00, '2021-09-15',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2014-08-06', 25,'62345678J','especial' :: tipoConc,'bloqueada' :: Estado, 'derechos_fallecimiento' :: medioConcesion , NULL,852.20, '2018-03-08',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2018-01-18', 26,'62345678J','fijo' :: tipoConc,'bloqueada' :: Estado, 'subasta' :: medioConcesion , NULL,9764.54, '2020-10-16',TRUE,'2021-11-14');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-10-30', 27,'12325678K','fijo' :: tipoConc,'asignada' :: Estado, 'concurso' :: medioConcesion,'2019-05-05', 3586.19 , '2020-05-12',TRUE,'2021-06-14');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2014-10-02', 28,'12325678K','fijo' :: tipoConc,'bloqueada' :: Estado, 'derechos_fallecimiento' :: medioConcesion,NULL, 1525.00 , '2015-05-05',TRUE,'2017-06-04');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2017-12-03', 29,'12325638L','especial' :: tipoConc,'asignada' :: Estado, 'adjudicacion_directa' :: medioConcesion,NULL, 5000.00 , '2021-08-04',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2010-06-09', 30,'12325638L','fijo' :: tipoConc,'en_proceso_asignacion' :: Estado, 'intervivos' :: medioConcesion,NULL, 5000.00 , '2015-10-04',FALSE,NULL);
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2018-01-09', 31,'12325678M','especial' :: tipoConc,'asignada' :: Estado, 'intervivos' :: medioConcesion ,NULL, 6789.10, '2023-01-18',TRUE,'2027-03-25');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2018-02-15', 32,'12327678N','fijo' :: tipoConc,'asignada' :: Estado, 'adjudicacion_directa' :: medioConcesion,'2020-05-25', 7777.14, '2022-12-13',TRUE,'2023-02-14');
INSERT INTO CONCESION (inicioConcesion,idConc,dniConc,tipo,estado,medio,fechaTraspaso,precioTraspaso,finConcesion,prorroga,finProrroga)
VALUES ('2020-03-08', 33,'12327678N','temporal' :: tipoConc,'sin_asignar' :: Estado, 'concurso' :: medioConcesion,NULL, 1866.80, '2020-10-15',FALSE,NULL);

INSERT INTO MERCADO (nombre,direccion,gestion)
VALUES ('Mercado Bilbao','Plaza Ernesto Erkoreka Nº1 Piso:1ºA', 'gestion_Directa' :: tipoGestion);


INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Fruteria Manolo');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Conservas Carlos');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Carniceria Lopez');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Frutas Yoli');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Pescaderia Loli');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Fruteria Mario');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Floristeria Flores');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Informática VIP');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Relojes Zafiro');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Joyería Icono');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Conservas Toribio');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Alta Carniceria');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Papelería Anfitrion');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Pet Estudio');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Recambios Carrera');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Repuestos Genius');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Televisores Turbo');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Juguetes Pelayo');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Fruteria Marietta');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Eco Informatica');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Exquisite Panty');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Cesta Dorada');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('La placita de la frescura');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Rey de la fruta');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Ferreteria Luis');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Econo-Market');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('La tienda del ahorro');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Recambios Lopez');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Dulce Home');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Decora Todo');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Drogueria Lolo');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Carniceria Genius');
INSERT INTO ESTABLECIMIENTO (nombre)
VALUES ('Pescaderia Pescaito');

INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (0,'12345678A','Mercado Bilbao','Fruteria Manolo',500.23,FALSE,12000.36,'1 Izquierda',530.56);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (1,'12345678A','Mercado Bilbao','Conservas Carlos',502.23,TRUE,14600.36,'1 Derecha',642.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (2,'12445678B','Mercado Bilbao','Carniceria Lopez',670.23,FALSE,10560.36,'1 Izquierda',497.52);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (3,'12348648C','Mercado Bilbao','Frutas Yoli',322.23,FALSE,12467.36,'3 Derecha',713.67);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (4,'12345678D','Mercado Bilbao','Pescaderia Loli',350.23,TRUE,21000.36,'2 Izquierda',460.56);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (5,'12345678A','Mercado Bilbao','Fruteria Mario',521.33,FALSE,13607.36,'4 Derecha',842.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (6,'12345678E','Mercado Bilbao','Floristeria Flores',120.23,FALSE,17032.36,'7 Izquierda',591.52);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (7,'12345658F','Mercado Bilbao','Informática VIP',352.63,FALSE,22467.36,'4 Derecha',413.67);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (8,'12345638G','Mercado Bilbao','Relojes Zafiro',700.23,TRUE,13560.36,'5 Izquierda',360.26);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (9,'12345672H','Mercado Bilbao','Joyería Icono',562.23,FALSE,11600.56,'3 Derecha',541.33);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (10,'12345672H','Mercado Bilbao','Conservas Toribio',631.25,FALSE,30560.36,'6 Derecha',590);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (11,'12345672H','Mercado Bilbao','Alta Carniceria',212.23,FALSE,22472.36,'4 Izquierda',243.77);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (12,'52345678I','Mercado Bilbao','Papelería Anfitrion',130.23,TRUE,21350.36,'1 Derecha',860.56);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (13,'62345678J','Mercado Bilbao','Pet Estudio',181.33,TRUE,17607.36,'6 Izquierda',1042.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (14,'12325678K','Mercado Bilbao','Recambios Carrera',126.23,TRUE,27232.36,'2 Izquierda',696.72);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (15,'12325638L','Mercado Bilbao','Repuestos Genius',356.23,FALSE,11467.36,'5 Derecha',723.17);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (16,'12325678M','Mercado Bilbao','Televisores Turbo',420.23,FALSE,12466.26,'2 Derecha',861.26);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (17,'12327678N','Mercado Bilbao','Juguetes Pelayo',562.23,FALSE,18690.52,'7 Derecha',714.73);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (18,'12345638G','Mercado Bilbao','Fruteria Marietta',632.25,FALSE,20160.36,'6 Derecha',121.52);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (19,'12445678B','Mercado Bilbao','Eco Informatica',411.53,TRUE,28272.36,'3 Izquierda',147.97);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (20,'12445678B','Mercado Bilbao','Exquisite Panty',711.23,FALSE,12680.36,'3 Derecha',568.56);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (21,'62345678J','Mercado Bilbao','Cesta Dorada',113.33,TRUE,19107.56,'4 Izquierda',242.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (22,'12325678K','Mercado Bilbao','La placita de la frescura',147.23,FALSE,21572.36,'7 Izquierda',612.72);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (23,'12325638L','Mercado Bilbao','Rey de la fruta',356.23,FALSE,18467.36,'1 Derecha',723.17);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (24,'12345678E','Mercado Bilbao','Ferreteria Luis',425.24,TRUE,22147.26,'5 Izquierda',261.26);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (25,'12327678N','Mercado Bilbao','Econo-Market',562.23,FALSE,12640.52,'5 Derecha',713.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (26,'12345638G','Mercado Bilbao','La tienda del ahorro',638.25,FALSE,21160.36,'6 Derecha',271.52);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (27,'99999999X','Mercado Bilbao','Recambios Lopez',621.53,TRUE,21472.36,'3 Izquierda',0);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (28,'12345678E','Mercado Bilbao','Dulce Home',867.23,FALSE,12680.36,'3 Derecha',518.56);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (29,'62345678J','Mercado Bilbao','Decora Todo',131.73,TRUE,19127.56,'4 Izquierda',216.53);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (30,'99999999X','Mercado Bilbao','Drogueria Lolo',141.93,FALSE,23672.36,'7 Izquierda',0);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (31,'99999999X','Mercado Bilbao','Carniceria Genius',357.23,FALSE,24467.36,'2 Derecha',0);
INSERT INTO ESPACIO (id,dniEsp,nombreEsp,nombreEst,fianza,obras,importeAnual,calle,precioAlquiler)
VALUES (32,'99999999X','Mercado Bilbao','Pescaderia Pescaito',836.63,FALSE,26867.36,'1 Derecha',0);


INSERT INTO FALTA(fecha, dniFalta, idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2015-05-10', '12345678A',0, 1, 'leve', 25000, FALSE, 'No abrir y cerrar puntualmente el puesto según el horario establecido.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2015-05-13', '12345678A',1, 1,  'leve', 30000, FALSE, 'La obstrucción indebida de la zona limitada de carga y descarga.', 2 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2016-07-13', '12445678B',2, 2,  'grave', 100000, FALSE, 'No mantener el local en las debidas condiciones de salubridad e higiene, ni en
perfectas condiciones de limpieza la zona del pasillo lindante con aquél.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2013-04-12', '12445678B',3, 2, 'grave', 90000, FALSE, 'La realización de obras en los puestos sin la previa obtención de las
autorizaciones y licencias preceptivas.', 2 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2018-06-01', '12345678D',4, 4, 'muy_grave', 200000, FALSE, 'Subarriendo del local o transmisión irregular de la concesión.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2019-02-24', '12345678D',5, 4, 'muy_grave', 300000, TRUE, 'Falta de pago en periodo voluntario de los devengos por ocupación de puestos.', 2 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2016-12-20','12345658F',6, 6, 'leve', 20000, FALSE, 'El cierre de un local durante 5 días consecutivos sin la previa autorización del
Ayuntamiento', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2017-02-13','12345638G',7, 8, 'leve', 30000, FALSE, 'La colocación de envases, género u otra clase de objetos en lugar no autorizado.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2017-09-04','52345678I',8, 11, 'leve', 27000, FALSE, 'No vestir prendas exteriores adecuadas.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2017-11-30','12325678K',9, 12, 'grave', 100000, FALSE, 'Alteración del orden.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2019-02-01','12325638L',10, 13, 'grave', 90000, FALSE, 'Destinar la concesión a fines distintos de los autorizados.', 1 );
INSERT INTO FALTA(fecha, dniFalta,idemFalta, idFalta, tipo, multa, derechos, motivo, contador)
VALUES('2018-02-16','12327678N',11, 15, 'muy_grave', 200000, FALSE, 'Cierre de un local durante más de 30 días seguidos.', 1 );


INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(2, 'Alimentos', 34.00);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(8, 'Relojería', 50.63);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(15, 'Repuestos', 58.13);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(26, 'Variedad', 20.00);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(31, 'Alimentos', 30.50);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(4, 'Alimentos', 69.20);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(7, 'Informática', 56.23);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(9, 'Bisutería', 23.00);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(21, 'Alimentos', 64.08);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(13, 'Animales', 74.21);
INSERT INTO ESPACIO_PUESTO(id, tipoVenta, superficie)
VALUES(32, 'Alimentos',34.21);


INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(1, 'Alimentos', 105.23);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(0, 'Alimentos', 89.00);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(3, 'Alimentos', 100.00);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(5, 'Alimentos', 95.23);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(6, 'Plantas', 50.69);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(10, 'Alimentos', 77.77);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(11, 'Alimentos', 104.65);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(12, 'Papelería', 53.21);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(14, 'Repuestos', 66.32);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(16, 'Informática', 100.27);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(17, 'Juguetería', 105.23);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(18, 'Alimentos', 200.61);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(19, 'Informática', 101.13);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(20, 'Ropa', 86.23);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(22, 'Alimentos', 105.23);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(23, 'Alimentos', 106.70);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(24, 'Ferretería', 150.61);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(25, 'Variedad', 181.00);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(27, 'Repuestos', 91.91);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(28, 'Hogar', 225.00);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(29, 'Decoración', 210.30);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(30, 'Droguería', 80.54);
INSERT INTO ESPACIO_ZONA_COMERCIAL(id, tipoVenta, superficie)
VALUES(31, 'Alimentos', 95.84);



INSERT INTO ESPACIO_INSTALACION_AUXILIAR(id, servicio)
VALUES(8, 'Taller');
INSERT INTO ESPACIO_INSTALACION_AUXILIAR(id, servicio)
VALUES(12, 'Almacén');
INSERT INTO ESPACIO_INSTALACION_AUXILIAR(id, servicio)
VALUES(4, 'Frigorífico');
INSERT INTO ESPACIO_INSTALACION_AUXILIAR(id, servicio)
VALUES(23, 'Almacén');
INSERT INTO ESPACIO_INSTALACION_AUXILIAR(id, servicio)
VALUES(31, 'Frigorífico');
