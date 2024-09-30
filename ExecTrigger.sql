/*SINTAXE TRIGGER

CREATE [OR REPLACE] TRIGGER NOME
    {BEFORE | AFTER} COMANDO_SQL
    [OF CAMPO] ON TABELA
    [FOR EACH ROW]
    [WHEN (CONDIÇÃO)]
    
DESABILITAR OU HABILITAR UMA TRIGGER:
ALTER TRIGGER NOME {DISABLE|ENABLE}

ELIMINAR UMA TRIGGER:
DROP TRIGGER NOME*/

-- EXEMPLO DE RIGGER STAMENT-LEVEL
/*CRIAR A TABELA TAB_AUDIT QUE ARMAZENA O NOME DO USUARIO, A HORA E O EVENTO 
QUE O USUARIO REALIZOU QUALQUER DM NA TABELA DE CLIENTE(LOC_CLIENTE)*/

--EXERC 1

DROP TABLE TAB_AUDIT_DML;
DROP TABLE TAB_ALUNO;
DROP TRIGGER TRG_AUDIT_ALUNO;

CREATE TABLE TAB_AUDIT_DML(
    NOM_TABELA VARCHAR2(30),
    NOM_USUARIO VARCHAR2(30),
    DAT_EVENTO DATE,
    TIP_EVENTO VARCHAR2(30),
    NEW_TEXTO VARCHAR2(30),
    OLD_TEXTO VARCHAR2(30)
    );
    
CREATE TABLE TAB_ALUNO(
    RM NUMBER(5),
    NOME VARCHAR2(60)
    );
    
CREATE OR REPLACE TRIGGER TRG_AUDIT_ALUNO
BEFORE INSERT OR UPDATE OR DELETE ON TAB_ALUNO

DECLARE
    V_TEXTO VARCHAR2(100);
BEGIN
    IF INSERTING THEN
        INSERT INTO TAB_AUDIT_DML VALUES('ALUNO',USER, SYSDATE, 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO TAB_AUDIT_DML VALUES('ALUNO',USER, SYSDATE, 'UPDATE');
    ELSE 
        INSERT INTO TAB_AUDIT_DML VALUES('ALUNO',USER, SYSDATE, 'DELETE');
    END IF;
END;
/

-- INSERT

INSERT INTO TAB_ALUNO (RM, NOME) VALUES (99097, 'BRUNO CICCIO');
UPDATE TAB_ALUNO SET NOME = 'BRUNO' WHERE RM = 99097;
DELETE FROM TAB_ALUNO WHERE RM = 99097;

SELECT * FROM TAB_AUDIT_DML;

-- EXERC 2

CREATE OR REPLACE TRIGGER TRG_AUDIT_ALUNO
BEFORE INSERT OR UPDATE OR DELETE ON TAB_ALUNO
FOR EACH ROW

BEGIN
    IF INSERTING THEN
        INSERT INTO TAB_AUDIT_DML (NOM_TABELA, NOM_USUARIO, DAT_EVENTO, TIP_EVENTO, NEW_TEXTO)
        VALUES ('ALUNO', USER, SYSDATE, 'INSERT', :NEW.NOME);
        
    ELSIF UPDATING THEN
        INSERT INTO TAB_AUDIT_DML (NOM_TABELA, NOM_USUARIO, DAT_EVENTO, TIP_EVENTO, NEW_TEXTO, OLD_TEXTO)
        VALUES ('ALUNO', USER, SYSDATE, 'UPDATE', :NEW.NOME, :OLD.NOME);
        
    ELSIF DELETING THEN
        INSERT INTO TAB_AUDIT_DML (NOM_TABELA, NOM_USUARIO, DAT_EVENTO, TIP_EVENTO, OLD_TEXTO)
        VALUES ('ALUNO', USER, SYSDATE, 'DELETE', :OLD.NOME);
    END IF;
END;
/

-- INSERT

INSERT INTO TAB_ALUNO (RM, NOME) VALUES (99097, 'BRUNO CICCIO');
UPDATE TAB_ALUNO SET NOME = 'BRUNO' WHERE RM = 99097;
DELETE FROM TAB_ALUNO WHERE RM = 99097;

SELECT * FROM TAB_AUDIT_DML;