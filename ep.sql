CREATE TABLE Conflito
(
  NumFeridos INT NOT NULL,
  CodConf CHAR(10) NOT NULL,
  NomeConf VARCHAR(50) NOT NULL,
  NumMortes INT NOT NULL,
  TipoConflito VARCHAR(20) NOT NULL,
  PRIMARY KEY (CodConf)
);

CREATE TABLE ConfPais
(
  NomePais VARCHAR(50) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (NomePais, CodConf),
  CONSTRAINT paisconffk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Territorial
(
  Regiao VARCHAR(30) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (Regiao, CodConf),
  CONSTRAINT territorialfk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Economico
(
  MatPrima VARCHAR(50) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (MatPrima, CodConf),
  CONSTRAINT economicofk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Religioso
(
  Religiao VARCHAR(30) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (Religiao, CodConf),
  CONSTRAINT religiosofk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Racial
(
  Etnia VARCHAR(30) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (Etnia, CodConf),
  CONSTRAINT racialfk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Grupo_Armado
(
  CodGA CHAR(10) NOT NULL,
  NomeGrupo VARCHAR(30) NOT NULL,
  NumBaixas INT DEFAULT 0,
  PRIMARY KEY (CodGA)
);

CREATE TABLE TipoArma
(
  NomeArma VARCHAR(20) NOT NULL,
  Indicador INT NOT NULL,
  PRIMARY KEY (NomeArma)
);

CREATE TABLE Divisao
(
  Tanques INT NOT NULL,
  Avioes INT NOT NULL,
  Homens INT NOT NULL,
  Barcos INT NOT NULL,
  NumBaixasD INT NOT NULL,
  NroDivisao INT NOT NULL,
  CodGA CHAR(10) NOT NULL,
  PRIMARY KEY (NroDivisao, CodGA),
  CONSTRAINT gadivisao
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lider_Politico
(
  Apoios VARCHAR(30) NOT NULL,
  NomeLider VARCHAR(50) NOT NULL,
  CodGA CHAR(10) NOT NULL,
  PRIMARY KEY (NomeLider, CodGA),
  CONSTRAINT galider
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA)
  ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE SaiParticipa
(
  DS_Grupo DATE NOT NULL,
  CodGA CHAR(10) NOT NULL,
  CodConf CHAR(10) NOT NULL,
  PRIMARY KEY (CodGA, CodConf),
  CONSTRAINT saigapart
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT saiconfpart
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EntParticipa
(
  DE_Grupo DATE NOT NULL,
  CodConf CHAR(10) NOT NULL,
  CodGA CHAR(10) NOT NULL,
  PRIMARY KEY (CodConf, CodGA),
  CONSTRAINT entconfpart
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT entgapart
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Fornece
(
  NumArmas INT NOT NULL,
  NomeTraficante VARCHAR(50) NOT NULL,
  CodGA CHAR(10) NOT NULL,
  NomeArma VARCHAR(20) NOT NULL,
  PRIMARY KEY (NomeTraficante, CodGA, NomeArma),
  CONSTRAINT fornecega
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fornecearma
  FOREIGN KEY (NomeArma) REFERENCES TipoArma(NomeArma)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PodeFornecer
(
  Quantidade INT NOT NULL,
  NomeTraficante VARCHAR(50) NOT NULL,
  NomeArma VARCHAR(20) NOT NULL,
  CONSTRAINT nomearmafk
  FOREIGN KEY (NomeArma) REFERENCES TipoArma(NomeArma)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Chefe_Militar
(
  CodChefe CHAR(10) NOT NULL,
  Faixa CHAR(15) NOT NULL,
  NroDivisao INT,
  CodGA CHAR(10),
  NomeLider VARCHAR(50) NOT NULL,
  PRIMARY KEY (CodChefe),
  FOREIGN KEY (CodGA) REFERENCES Grupo_Armado(CodGA),
  FOREIGN KEY (CodGA, NroDivisao) REFERENCES Divisao(CodGA, NroDivisao)
  ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chefemilitarfk        --Qualquer chefe militar obedece no minimo a um lider politico
  FOREIGN KEY (CodGA, NomeLider) REFERENCES Lider_Politico(CodGA, NomeLider)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Organizacao_Mediadora
(
  CodOrg CHAR(10) NOT NULL,
  NomeOrg VARCHAR(50) NOT NULL,
  TipoAjuda VARCHAR(20) NOT NULL,
  Tipo VARCHAR(20) NOT NULL,
  NumPessoas INT NOT NULL,
  CodOrgLider CHAR(10),
  PRIMARY KEY (CodOrg),
  CONSTRAINT orgliderfk
  FOREIGN KEY (CodOrgLider) REFERENCES Organizacao_Mediadora(CodOrg)
  ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE EntMedia
(
  DE_Org DATE NOT NULL,
  CodConf CHAR(10) NOT NULL,
  CodOrg CHAR(10) NOT NULL,
  PRIMARY KEY (CodConf, CodOrg),
  CONSTRAINT entmediaconffk 
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT  entcodorg
  FOREIGN KEY (CodOrg) REFERENCES Organizacao_Mediadora(CodOrg)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Dialoga
(
  CodOrg CHAR(10) NOT NULL,
  CodGA CHAR(10) NOT NULL,
  NomeLider VARCHAR(50) NOT NULL,
  PRIMARY KEY (CodOrg, CodGA, NomeLider),
  CONSTRAINT dialogaorg
  FOREIGN KEY (CodOrg) REFERENCES Organizacao_Mediadora(CodOrg)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT dialogalider
  FOREIGN KEY (CodGA, NomeLider) REFERENCES Lider_Politico(CodGA, NomeLider)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SaiMedia
(
  DS_Org DATE NOT NULL,
  CodConf CHAR(10) NOT NULL,
  CodOrg CHAR(10) NOT NULL,
  PRIMARY KEY (CodConf, CodOrg),
  CONSTRAINT saimediaconffk
  FOREIGN KEY (CodConf) REFERENCES Conflito(CodConf)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT saicodorg
  FOREIGN KEY (CodOrg) REFERENCES Organizacao_Mediadora(CodOrg)
  ON DELETE CASCADE ON UPDATE CASCADE
);

--Restrições de integridade das hierarquias
CREATE OR REPLACE RULE checaconfterritorio AS ON INSERT to Territorial 
WHERE NEW.CodConf IN (Select CodConf FROM Economico WHERE CodConf = NEW.CodConf)  OR
NEW.CodConf IN (Select CodConf FROM Religioso WHERE CodConf = NEW.CodConf) OR
NEW.CodConf IN (Select CodConf FROM Racial WHERE CodConf = NEW.CodConf)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE checaconfeconomico AS ON INSERT to Economico 
WHERE NEW.CodConf IN (Select CodConf FROM Territorial WHERE CodConf = NEW.CodConf) OR 
NEW.CodConf IN (Select CodConf FROM Religioso WHERE CodConf = NEW.CodConf) OR
NEW.CodConf IN (Select CodConf FROM Racial WHERE CodConf = NEW.CodConf)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE checaconfreligioso AS ON INSERT to Religioso 
WHERE NEW.CodConf IN (Select CodConf FROM Territorial WHERE CodConf = NEW.CodConf) OR 
NEW.CodConf IN (Select CodConf FROM Economico WHERE CodConf = NEW.CodConf)  OR
NEW.CodConf IN (Select CodConf FROM Racial WHERE CodConf = NEW.CodConf)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE checaconfracial AS ON INSERT to Racial 
WHERE NEW.CodConf IN (Select CodConf FROM Territorial WHERE CodConf = NEW.CodConf) OR 
NEW.CodConf IN (Select CodConf FROM Economico WHERE CodConf = NEW.CodConf)  OR
NEW.CodConf IN (Select CodConf FROM Religioso WHERE CodConf = NEW.CodConf)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE umlider AS ON UPDATE to Chefe_Militar
WHERE NEW.NomeLider IS NULL

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE umchefed AS ON DELETE to Chefe_Militar
WHERE OLD.NroDivisao NOT IN (Select NroDivisao FROM Chefe_Militar WHERE CodGA = OLD.CodGA EXCEPT SELECT NroDivisao FROM Chefe_Militar WHERE CodChefe = OLD.CodChefe)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE umchefeu AS ON UPDATE to Chefe_Militar
WHERE OLD.NroDivisao NOT IN (Select NroDivisao FROM Chefe_Militar WHERE CodGA = OLD.CodGA EXCEPT SELECT NroDivisao FROM Chefe_Militar WHERE CodChefe = OLD.CodChefe)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE umadivisaod AS ON DELETE to Divisao
WHERE OLD.CodGA NOT IN (Select CodGA FROM Divisao EXCEPT SELECT CodGA FROM Divisao WHERE CodGA = OLD.CodGA AND NroDivisao = OLD.NroDivisao)

DO INSTEAD NOTHING;

CREATE OR REPLACE RULE umadivisaou AS ON UPDATE to Divisao
WHERE OLD.CodGA NOT IN (Select CodGA FROM Divisao EXCEPT SELECT CodGA FROM Divisao WHERE CodGA = OLD.CodGA AND NroDivisao = OLD.NroDivisao)

DO INSTEAD NOTHING;

CREATE OR REPLACE FUNCTION umpais() RETURNS trigger as $umpais$
DECLARE c integer;
BEGIN
SELECT into c COUNT(NomePais) FROM ConfPais WHERE CodConf = OLD.CodConf;
IF c = 1 THEN 
RETURN NULL;
END IF;
RETURN OLD;
END;
$umpais$ LANGUAGE plpgsql;

CREATE TRIGGER umpais BEFORE UPDATE OR DELETE on ConfPais
FOR EACH ROW EXECUTE PROCEDURE umpais();

CREATE OR REPLACE FUNCTION maisquetres() RETURNS trigger AS $maisquetres$ --Uma divisao não pode ter mais de três chefes militares
DECLARE myint integer;
BEGIN
SELECT into myint COUNT(NroDivisao) FROM Chefe_Militar WHERE CodGA = NEW.CodGA AND NroDivisao = NEW.NroDivisao;
IF myint = 3 THEN
RETURN NULL;
END IF;
RETURN NEW;
END;
$maisquetres$ LANGUAGE plpgsql;

CREATE TRIGGER maisquetres BEFORE INSERT OR UPDATE of NroDivisao on Chefe_Militar 
FOR EACH ROW EXECUTE PROCEDURE maisquetres();


CREATE OR REPLACE FUNCTION doisgrupos() RETURNS trigger AS $doisgrupos$
DECLARE num integer;
BEGIN
SELECT into num COUNT(CodGA) FROM EntParticipa WHERE CodGA NOT IN (Select CodGA FROM SaiParticipa);
IF num < 3 THEN
RETURN NULL;
END IF;
RETURN NEW;
END;
$doisgrupos$ LANGUAGE plpgsql;

CREATE TRIGGER doisgrupos BEFORE INSERT on SaiParticipa
FOR EACH ROW EXECUTE PROCEDURE doisgrupos();

CREATE OR REPLACE FUNCTION checabaixas() RETURNS trigger AS $checabaixas$
DECLARE n integer;
DECLARE numdivisoes integer;
BEGIN
IF (TG_WHEN = 'BEFORE') THEN
SELECT into n COALESCE(SUM(NumBaixasD), 0) FROM Divisao WHERE CodGA = NEW.CodGA;
NEW.NumBaixas = n;
RETURN NEW;
END IF;

IF (TG_OP = 'DELETE') THEN 
SELECT into numdivisoes COUNT(NroDivisao) FROM Divisao WHERE CodGA = OLD.CodGA;
SELECT into n SUM(NumBaixasD) FROM Divisao WHERE CodGA = OLD.CodGA;
UPDATE Grupo_Armado SET NumBaixas = n WHERE CodGA = NEW.CodGA;
END IF;

IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
SELECT into n SUM(NumBaixasD) FROM Divisao WHERE CodGA = NEW.CodGA;
UPDATE Grupo_Armado SET NumBaixas = n WHERE CodGA = NEW.CodGA;
RETURN NEW;

END IF;

IF (numdivisoes = 0) THEN
UPDATE Grupo_Armado SET NumBaixas = DEFAULT WHERE CodGA = OLD.CodGA;
END IF;


RETURN NEW;
END;
$checabaixas$ LANGUAGE plpgsql;

CREATE TRIGGER checabaixas AFTER INSERT OR UPDATE OR DELETE on Divisao
FOR EACH ROW EXECUTE PROCEDURE checabaixas();

CREATE TRIGGER numbaixasupdate BEFORE UPDATE OR INSERT on Grupo_Armado
FOR EACH ROW EXECUTE PROCEDURE checabaixas();

CREATE OR REPLACE FUNCTION checadivisoes() RETURNS trigger AS $checadivisoes$
DECLARE div Divisao;
DECLARE divinho Divisao;
DECLARE it integer;
BEGIN
it = 0;
IF (TG_OP = 'DELETE') THEN
divinho = OLD;
ELSE
divinho = NEW;
END IF;

FOR div in (SELECT * FROM Divisao WHERE CodGA = divinho.CodGA ORDER BY NroDivisao ASC) LOOP

IF (div.NroDivisao != it + 1) THEN
UPDATE Divisao SET NroDivisao = it + 1 WHERE CodGA = div.CodGA AND NroDivisao = div.NroDivisao;
END IF;
it = it + 1;
END LOOP;
RETURN NEW;
END;
$checadivisoes$ LANGUAGE plpgsql;

CREATE TRIGGER checadivisoes AFTER INSERT OR UPDATE OR DELETE on Divisao
FOR EACH ROW EXECUTE PROCEDURE checadivisoes();

INSERT INTO Conflito values (0,'0','guerra papas',0,'Territorial');
INSERT INTO Territorial (Regiao, CodConf) values ('ameia','0');
INSERT INTO ConfPais values ('Hungria','0');

INSERT INTO Grupo_Armado values('99','alibaba',92);
INSERT INTO Lider_Politico values ('aéreo','junpei','99');
INSERT INTO Divisao values (3,3,3,3,3,1,'99');
INSERT INTO chefe_militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('666', 'maleal','99','junpei',1);
INSERT INTO chefe_militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('667', 'releal','99','junpei',1);
INSERT INTO chefe_militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('668', 'laleal','99','junpei',1);
INSERT INTO chefe_militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('669', 'jileal','99','junpei',1);

INSERT INTO Grupo_Armado values('98','mussei',92);

INSERT INTO Conflito values (2,'1','Guerra Camelo',12,'Territorial');
INSERT INTO Territorial values ('aleia', '1');
INSERT INTO ConfPais values ('Cingapura','1');

INSERT INTO Conflito values (17,'2','Halibola nortense',3,'Economico');
INSERT INTO Economico values ('Algodão','2');
INSERT INTO ConfPais values ('Tainwan','2');

INSERT INTO Conflito values (6,'3','Jihad Umbral',12,'Economico');
INSERT INTO Economico values ('Madeira','3');
INSERT INTO ConfPais values ('Arábia Saudita','3');

INSERT INTO Conflito values (22,'4','Guineia koleal',34,'Religioso');
INSERT INTO Religioso values ('Cristianismo','4');
INSERT INTO Religioso values ('Protestantismo', '4');
INSERT INTO ConfPais values ('Sudão', '4');

INSERT INTO Conflito values (0,'5','Corrida do veludo',0,'Religioso');
INSERT INTO Religioso values ('Xintoísmo','5');
INSERT INTO Religioso values ('Hinduísmo','5');
INSERT INTO ConfPais values ('Japão','5');

INSERT INTO Conflito values (6,'6','Eurakunin do rio eufrates',2, 'Racial');
INSERT INTO Racial values ('Palestinos','6');
INSERT INTO Racial values ('Curdos','6');
INSERT INTO ConfPais values ('Iraque','6');

INSERT INTO Conflito values (14,'7','Verão surpresa',69, 'Racial');
INSERT INTO Racial values ('Catalães', '7');
INSERT INTO Racial values ('Espanhóis', '7');
INSERT INTO ConfPais values ('Espanha','7');

INSERT INTO Grupo_Armado values('97','al',92);
INSERT INTO Grupo_Armado values ('96','regossi',0);
INSERT INTO Grupo_Armado values ('95', 'yumemiu',0);
INSERT INTO Grupo_Armado values ('94', 'kigg',0);
INSERT INTO Grupo_Armado values ('93','grupo grupal',0);
INSERT INTO Grupo_Armado values ('92','abyupla',0);
INSERT INTO Grupo_Armado values ('91','subilupla',0);
INSERT INTO Grupo_Armado values ('90','catete',0); --10
INSERT INTO Grupo_Armado values ('89','jihuleit',0);
INSERT INTO Grupo_Armado values ('88','qebela',0);
INSERT INTO Grupo_Armado values ('87', 'rabico',0);
INSERT INTO Grupo_Armado values ('86', 'sadastrof',0);
INSERT INTO Grupo_Armado values ('85', 'salalal',0);
INSERT INTO Grupo_Armado values ('84', 'fylutra',0);
INSERT INTO Grupo_Armado values ('83', 'iktra',0);
INSERT INTO Grupo_Armado values ('82', 'estigel',0);
INSERT INTO Grupo_Armado values ('81', 'gunnigan',0);
INSERT INTO Grupo_Armado values ('80', 'trabetro',0);

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('0','99','17/12/2015');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('0','98','17/12/2015');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('1','96','10/05/2006');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('1','97','10/05/2006');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('2','95','22/09/2013');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('2','94','22/09/2013');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('3','93','28/02/1995');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('3','92','28/02/1995');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('4','91','31/12/2003');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('4','90','31/12/2003');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('5','89','12/04/1976');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('5','88','12/04/1976');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('6','87','01/01/2005');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('6','86','01/01/2005');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('7','85','02/06/2001');
INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('7','84','02/06/2001');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('2','83','30/10/2013');
INSERT INTO SaiParticipa (CodConf,CodGA,DS_Grupo) values ('2','94','26/01/2014');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('4','82','16/02/2004');
INSERT INTO SaiParticipa (CodConf,CodGA,DS_Grupo) values ('4','82','06/04/2004');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('5','81','03/07/1976');
INSERT INTO SaiParticipa (CodConf,CodGA,DS_Grupo) values ('5','89','30/11/1976');

INSERT INTO EntParticipa (CodConf,CodGA,DE_GRUPO) values ('7','80','22/06/2001');
INSERT INTO SaiParticipa (CodConf,CodGA,DS_Grupo) values ('7','84','20/11/2001');

INSERT INTO TipoArma (NomeArma, Indicador) values ('Barret M82',5);
INSERT INTO TipoArma (NomeArma, Indicador) values ('M200 intervention',5);
INSERT INTO TipoArma (NomeArma, Indicador) values ('MP5',2);
INSERT INTO TipoArma (NomeArma, Indicador) values ('Negev',4);
INSERT INTO TipoArma (NomeArma, Indicador) values ('AK-47',3);
INSERT INTO TipoArma (NomeArma, Indicador) values ('Bren',4);
INSERT INTO TipoArma (NomeArma, Indicador) values ('M4A1',3);
INSERT INTO TipoArma (NomeArma, Indicador) values ('Thompson M1921',2);
INSERT INTO TipoArma (NomeArma, Indicador) values ('M1911',1);
INSERT INTO TipoArma (NomeArma, Indicador) values ('Glock',1);

INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Joselido Assunción',200,'Bren');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Joselido Assunción',400,'Glock');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Joselido Assunción',150,'Barret M82');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fragurous Kendo Yullio',400,'Negev');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fragurous Kendo Yullio',400,'AK-47');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fragurous Kendo Yullio',300,'MP5');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Buxin-xei Al Mussei',500,'Thompson M1921');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Buxin-xei Al Mussei',200,'M4A1');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Buxin-xei Al Mussei',150,'Bren');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Telmo Ungo Druttero',300,'M4A1');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Telmo Ungo Druttero',170,'M200 intervention');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Telmo Ungo Druttero',600,'M1911');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fella Juliet Hangadon',300,'M200 intervention');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fella Juliet Hangadon',200,'Barret M82');
INSERT INTO PodeFornecer (NomeTraficante, Quantidade, NomeArma) values ('Fella Juliet Hangadon',700,'Glock');

INSERT INTO Fornece (CodGA, NomeArma, NomeTraficante, NumArmas) values ('99','Bren','Buxin-xei Al Mussei',10);
INSERT INTO Fornece (CodGA, NomeArma, NomeTraficante, NumArmas) values ('99','MP5','Fragurous Kendo Yullio',10);
INSERT INTO Fornece (CodGA, NomeArma, NomeTraficante, NumArmas) values ('98','M200 intervention','Telmo Ungo Druttero',5);
INSERT INTO Fornece (CodGA, NomeArma, NomeTraficante, NumArmas) values ('98','Negev','Fragurous Kendo Yullio',5);
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('97','Fella Juliet Hangadon',7,'Barret M82');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('97','Joselido Assunción',20,'Bren');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('96','Fella Juliet Hangadon',22,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('96','Telmo Ungo Druttero',43,'M4A1');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('95','Fragurous Kendo Yullio',20,'MP5');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('95','Fella Juliet Hangadon',10,'M200 intervention');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('94','Buxin-xei Al Mussei',10,'M4A1');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('94','Buxin-xei Al Mussei',30,'Thompson M1921');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('93','Telmo Ungo Druttero',6,'M200 intervention');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('93','Joselido Assunción',24,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('92','Fella Juliet Hangadon',69,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('92','Joselido Assunción',10,'Barret M82');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('91','Fragurous Kendo Yullio',30,'AK-47');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('91','Telmo Ungo Druttero',77,'M1911');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('90','Buxin-xei Al Mussei',30,'Thompson M1921');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('90','Joselido Assunción',13,'Bren');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('89','Telmo Ungo Druttero',4,'M200 intervention');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('89','Fragurous Kendo Yullio',20,'AK-47');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('88','Buxin-xei Al Mussei',15,'Bren');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('88','Telmo Ungo Druttero',30,'M1911');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('87','Fragurous Kendo Yullio',20,'MP5');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('87','Fella Juliet Hangadon',50,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('86','Fragurous Kendo Yullio',30,'Negev');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('86','Joselido Assunción',50,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('85','Buxin-xei Al Mussei',20,'Thompson M1921');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('85','Fella Juliet Hangadon',10,'Barret M82');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('84','Telmo Ungo Druttero',20,'M200 intervention');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('84','Fragurous Kendo Yullio',33,'AK-47');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('83','Fragurous Kendo Yullio',27,'MP5');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('83','Telmo Ungo Druttero',45,'M1911');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('83','Joselido Assunción',20,'Bren');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('82','Fella Juliet Hangadon',10,'M200 intervention');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('82','Buxin-xei Al Mussei',30,'Thompson M1921');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('81','Fragurous Kendo Yullio',20,'Negev');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('81','Joselido Assunción',50,'Glock');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('80','Fella Juliet Hangadon',15,'Barret M82');
INSERT INTO Fornece (CodGA, NomeTraficante, NumArmas, NomeArma) values ('80','Telmo Ungo Druttero',44,'M1911');

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Aleil', '99', 'Terrestre');
INSERT INTO Divisao values (3,3,3,3,7,2,'99');
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('669', 'General','99','Aleil',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('670', 'Cabo','99','Aleil',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Ymiryu', '98', 'Gélido');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Salisvata', '98', 'Aéreo');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('98',1,5,5,5,30,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('665','Marechal','98','Ymiryu',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('664','Major','98','Salisvata',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('98',2,2,2,2,40,17);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('663', 'General', '98', 'Ymiryu',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('662', 'Capitão', '98', 'Salisvata',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Huglido', '97', 'Marítimo');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Juo','97','Qualitativo');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('97',1,1,5,7,22,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('661','Major','97','Huglido',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('660', 'Soldado','97','Juo',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('97',2,1,5,1,72,18);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('659','General','97','Huglido',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('658','Marechal','97','Juo',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Mimiu', '96', 'Umbral');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Zastin','96','Espacial');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('96',1,3,5,7,21,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('657','Major','96','Mimiu',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('656', 'Capitão','96','Zastin',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('96',2,1,5,1,44,18);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('655','Soldado','96','Mimiu',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('654', 'Marechal','96','Zastin',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Tello', '95', 'Astral');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Fagudo','95', 'Aéreo');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('95',1,5,3,2,32,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('653','Cabo','95','Tello',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('652','General','95','Fagudo',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('95',2,3,2,4,54,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('651','Marechal','95','Tello',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('650','Capitão', '95','Fagudo',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Tlipu','94','Umbral');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Caleto','94','Marítimo');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('94',1,5,3,3,76,22);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('649','Capitão','94','Tlipu',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('648','Marechal','94','Caleto',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('94',2,3,1,3,21,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('647','Soldado','94','Tlipu',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('646','Cabo','94','Caleto',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Traberosso','93','Orbital');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Ema','93','Aéreo');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('93',1,2,2,3,20,9);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('645','Tenente','93','Traberosso',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('644','Major','93','Ema',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('93',2,3,3,3,33,13);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('643','Capitão','93','Traberosso',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('642','General','93','Ema',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Sabarol','92','Solar');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Ceratete','92','Polar');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('92',1,1,1,3,12,0);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('641','Marechal','92','Sabarol',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('640','Soldado','92','Ceratete',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('92',2,5,6,3,33,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('639','Cabo','92','Sabarol',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('638','General','92','Ceratete',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Abat','91','Lunar');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Thur','91','Terrestre');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('91',1,2,2,5,50,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('637','Tenente','91','Abat',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('636','Major','91','Thur',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('91',2,2,1,3,40,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('635','General','91','Abat',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('634','Cabo','91','Thur',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Qebec','90','Pluvial');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Zulu', '90','Democrático');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('90',1,3,3,3,67,20);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('633','Soldado','90','Qebec',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('632','Marechal','90','Zulu',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('90',2,4,1,1,49,11);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('631','Major','90','Qebec',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('630','Cabo','90','Zulu',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Rafael','89','Aéreo');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Gabriel','89','Ditatorial');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('89',1,7,1,2,44,7);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('629','General','89','Rafael',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('628','Tenente','89','Gabriel',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('89',2,3,3,7,29,1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('627','Capitão','89','Rafael',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('626','Cabo','89','Gabriel',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Eldeio','88','Polar');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Jidrelio','88','Bancário');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('88',1,4,2,1,50,7);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('625','Marechal','88','Eldeio',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('624','Cabo','88','Jidrelio',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('88',2,1,1,3,40,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('623','Capitão','88','Eldeio',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('622','Major','88','Jidrelio',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Skroly','87','Marítimo');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Gugu','87','Bélico');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('87',1,5,4,2,87,13);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('621','General','87','Skroly',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('620','Cabo','87','Gugu',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('87',2,1,4,5,30,0);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('619','Soldado','87','Skroly',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('618','Tenente','87','Gugu',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Inkalidian','86','Proletário');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Felicio','86','Triunfal');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('86',1,7,2,1,50,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('617','Capitão','86','Inkalidian',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('616','Major','86','Felicio',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('86',2,1,1,4,17,0);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('615','General','86','Inkalidian',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('614','Tenente','86','Felicio',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Gulliver','85','Financeiro');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Palivero','85','Protista');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('85',1,2,2,3,70,20);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('613','Marechal','85','Gulliver',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('612','Soldado','85','Palivero',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('85',2,1,5,3,40,12);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('611','Cabo','85','Gulliver',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('610','General','85','Palivero',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Pavilier','84','Bancário');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Polveton','84','Bélico');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('84',1,3,4,1,25,3);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('609','Capitão','84','Pavilier',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('608','Tenente','84','Polveton',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('84',2,1,2,1,40,10);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('607','Major','84','Pavilier',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('606','Soldado','84','Polveton',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Kaleb','83','Quantitativo');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Lovito','83','Vigilante');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('83',1,1,1,1,30,9);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('605','General','83','Kaleb',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('604','Capitão','83','Lovito',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('83',2,1,4,4,50,10);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('603','Cabo','83','Kaleb',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('602','Major','83','Lovito',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Subila','82','Financeiro');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Aeon','82','Patológico');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('82',1,5,3,3,30,4);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('601','Soldado','82','Subila',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('600','Marechal','82','Aeon',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('82',2,6,3,3,85,15);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('599','General','82','Subila',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('598','Capitão','82','Aeon',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Cristus','81','Central');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Retolvi','81','Qualificado');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('81',1,6,6,2,60,14);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('597','Tenente','81','Cristus',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('596','Major','81','Retolvi',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('81',2,2,6,3,57,2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('595','Marechal','81','Cristus',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('594','Cabo','81','Retolvi',2);

INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Denise','80','Doméstico');
INSERT INTO Lider_Politico (NomeLider, CodGA, Apoios) values ('Elvis','80','Musical');
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('80',1,2,1,5,56,32);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('593','Capitão','80','Denise',1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('592','General','80','Elvis',1);
INSERT INTO Divisao (CodGA, NroDivisao, Tanques, Avioes, Barcos, Homens, NumBaixasD) values ('80',2,3,7,3,22,1);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('591','Major','80','Denise',2);
INSERT INTO Chefe_Militar (CodChefe,Faixa,CodGA,NomeLider,NroDivisao) values ('590','Tenente','80','Elvis',2);


INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('30','Anticonflitos Beliais','Diplomática','Internacional',30);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('31','Soberbos Pacíficos','Médica','Não-Governamental',20,'30');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('32','Guerreiros de Juzão','Diplomática','Internacional',60);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('33','Anticonflitos Beliais','Médica','Governamental',20,'32');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('34','Sapatos de Ciano','Diplomática','Internacional',40);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('35','Soberbos Pacíficos','Presencial','Não-Governamental',20,'34');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('36','Palpebras abertas','Presencial','Governamental',65);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('37','Feira católica','Médica','Não-Governamental',29,'36');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('38','Anticonflitos Beliais','Diplomática','Internacional',100);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('39','Soberbos Pacíficos','Médica','Não-Governamental',32,'38');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('40','Gatinhos Felizes','Diplomática','Internacional',60);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('41','De peito aberto','Presencial','Não-Governamental',20,'40');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('42','Médicos com fronteiras','Médica','Internacional',120);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('43','Película perdida','Médica','Governamental',20,'42');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('44','Sociedade B. Trab.','Diplomática','Internacional',40);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('45','Banheira do Gugu','Presencial','Não-Governamental',35,'44');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('46','Banco de força','Presencial','Governamental',125);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('47','Brassil','Médica','Não-Governamental',79,'46');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('48','Tecladistas conflitantes','Diplomática','Internacional',100);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('49','Terceiro Pino','Médica','Governamental',32,'48');

INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas) values ('50','Óculos feitores','Diplomática','Internacional',60);
INSERT INTO Organizacao_Mediadora (CodOrg,NomeOrg,TipoAjuda,Tipo,NumPessoas,CodOrgLider) values ('51','Lentes Limpas','Presencial','Internacional',20,'50');


INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('30','90','Qebec');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('32','99','Aleil');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('31','96','Zastin');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('44','87','Gugu');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('34','85','Palivero');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('37','82','Aeon');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('39','81','Cristus');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('42','88','Eldeio');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('43','89','Gabriel');
INSERT INTO Dialoga (CodOrg, CodGA, NomeLider) values ('51','91','Abat');



INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('1','33','11/06/2006');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('2','35','22/09/2013');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('3','37','30/03/1995');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('4','39','07/02/2004');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('5','41','12/04/1976');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('6','43','22/01/2005');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('7','45','18/07/2001'); 
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('3','47','24/04/1995');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('7','49','03/07/2001');
INSERT INTO EntMedia (CodConf,CodOrg,DE_Org) values ('1','51','11/06/2006');

INSERT INTO SaiMedia (CodConf,CodOrg,DS_Org) values ('3','33','27/06/2006');
INSERT INTO SaiMedia (CodConf,CodOrg,DS_Org) values ('7','45','10/08/2001');
INSERT INTO SaiMedia (CodConf,CodOrg,DS_Org) values ('1','51','28/06/2006');