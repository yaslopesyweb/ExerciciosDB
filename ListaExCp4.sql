/* É necessário que você elabore todas as instruções DDL (Data Definition
Language) essenciais para a resolução dos exercícios.
Packages:
1. Crie um pacote PL/SQL chamado "pkg_funcionario" que contenha uma função
para retornar o salário de um funcionário com base no ID.
2. Adicione um procedimento ao pacote "pkg_funcionario" para atualizar o
salário de um funcionário.
3. Crie um pacote chamado "pkg_matematica" que inclua uma função para
calcular o fatorial de um número.
4. Desenvolva um pacote "pkg_string" que ofereça uma função para inverter
uma string passado por parâmetro.*/


-- PACKAGES

CREATE TABLE cp4_funcionarios (
id NUMBER PRIMARY KEY,
nome VARCHAR2(100),
salario NUMBER,
departamento VARCHAR2(100),
data_contratacao DATE,
gerente_nome VARCHAR2(100)
);
/

INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome) VALUES (1, 'Carlos Silva', 5000, 'TI', TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'Ana Souza');
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome) VALUES (2, 'Mariana Costa', 6000, 'TI', TO_DATE('2022-06-15', 'YYYY-MM-DD'), 'Ana Souza');
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome) VALUES (3, 'Pedro Martins', 4500, 'Financeiro', TO_DATE('2021-03-20', 'YYYY-MM-DD'), 'Lucas Pereira');
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome) VALUES (4, 'Fernanda Almeida', 7000, 'Recursos Humanos', TO_DATE('2020-10-05', 'YYYY-MM-DD'), 'Juliana Nunes');
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome) VALUES (5, 'Ricardo Mendes', 5200, 'TI', TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'Ana Souza');
COMMIT;
/

SET SERVEROUTPUT ON;
-- 1 
CREATE OR REPLACE PACKAGE pkg_funcionario AS
FUNCTION get_salario_funcionario(p_id_funcionario NUMBER) RETURN NUMBER;
PROCEDURE atualizar_salario(p_id_funcionario NUMBER, p_novo_salario NUMBER);
END pkg_funcionario;
/

CREATE OR REPLACE PACKAGE BODY pkg_funcionario AS

FUNCTION get_salario_funcionario(p_id_funcionario NUMBER) RETURN NUMBER IS
v_salario NUMBER;
BEGIN
SELECT salario INTO v_salario 
FROM cp4_funcionarios 
WHERE id = p_id_funcionario;
RETURN v_salario;
END get_salario_funcionario;

PROCEDURE atualizar_salario(p_id_funcionario NUMBER, p_novo_salario NUMBER) IS
BEGIN
UPDATE cp4_funcionarios 
SET salario = p_novo_salario 
WHERE id = p_id_funcionario;
COMMIT;
END atualizar_salario;

END pkg_funcionario;
/

DECLARE
v_salario NUMBER;
BEGIN
v_salario := pkg_funcionario.get_salario_funcionario(1);
pkg_funcionario.atualizar_salario(1, 5500);
DBMS_OUTPUT.PUT_LINE('Salário do funcionário com ID 1: ' || v_salario);
END;
/

/*4. Desenvolva um pacote "pkg_string" que ofereça uma função para inverter
uma string passado por parâmetro.*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_string AS
FUNCTION inverter_string(p_texto VARCHAR2) RETURN VARCHAR2;
END pkg_string;
/

CREATE OR REPLACE PACKAGE BODY pkg_string AS

FUNCTION inverter_string(p_texto VARCHAR2) RETURN VARCHAR2 IS
v_resultado VARCHAR2(4000) := '';
BEGIN
FOR i IN REVERSE 1..LENGTH(p_texto) LOOP
    v_resultado := v_resultado || SUBSTR(p_texto, i, 1);
END LOOP;
RETURN v_resultado;
END inverter_string;

END pkg_string;
/

DECLARE
v_resultado VARCHAR2(100);
BEGIN
v_resultado := pkg_string.inverter_string('Exemplo');
DBMS_OUTPUT.PUT_LINE('String invertida: ' || v_resultado);
END;
/

/*Procedures:
5. Escreva uma procedure que aceite o nome de um departamento e retorne o
número total de funcionários nesse departamento.*/
CREATE OR REPLACE PROCEDURE total_funcionarios_departamento(
p_nome_departamento IN VARCHAR2,
p_total_funcionarios OUT NUMBER
) AS
BEGIN
SELECT COUNT(*) INTO p_total_funcionarios
FROM cp4_funcionarios
WHERE departamento = p_nome_departamento;
END total_funcionarios_departamento;
/

SET SERVEROUTPUT ON;

DECLARE
v_total_funcionarios NUMBER;
BEGIN
total_funcionarios_departamento('TI', v_total_funcionarios);
DBMS_OUTPUT.PUT_LINE('Total de funcionários no departamento de TI: ' || v_total_funcionarios);
END;
/

/*6. Crie uma procedure que insira um novo registro na tabela de funcionários.*/

CREATE OR REPLACE PROCEDURE inserir_funcionario(
p_id IN NUMBER,
p_nome IN VARCHAR2,
p_salario IN NUMBER,
p_departamento IN VARCHAR2,
p_data_contratacao IN DATE,
p_gerente_nome IN VARCHAR2
) AS
BEGIN
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome)
VALUES (p_id, p_nome, p_salario, p_departamento, p_data_contratacao, p_gerente_nome);

COMMIT;
END inserir_funcionario;
/

SET SERVEROUTPUT ON;

-- Executa a procedure para inserir um novo funcionário
BEGIN
inserir_funcionario(6, 'João Santos', 4800, 'Marketing', TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Maria Silva');
DBMS_OUTPUT.PUT_LINE('Funcionário inserido com sucesso.');
END;
/

-- Consulta para exibir todos os registros da tabela cp4_funcionarios
SELECT * FROM cp4_funcionarios;
/

/*7. Desenvolva uma procedure que aceite o ID de um funcionário e retorne em
um parâmetro de saída o nome do gerente desse funcionário.*/
CREATE OR REPLACE PROCEDURE nome_gerente_funcionario(
p_id_funcionario IN NUMBER,
p_nome_gerente OUT VARCHAR2
) AS
BEGIN
SELECT gerente_nome INTO p_nome_gerente
FROM cp4_funcionarios
WHERE id = p_id_funcionario;
END nome_gerente_funcionario;
/

SET SERVEROUTPUT ON;

DECLARE
v_nome_gerente VARCHAR2(100);
BEGIN
nome_gerente_funcionario(1, v_nome_gerente);
DBMS_OUTPUT.PUT_LINE('Nome do gerente do funcionário com ID 1: ' || v_nome_gerente);
END;
/
/*Triggers:
9. Crie um trigger que registre todas as alterações na tabela de funcionários em
uma tabela de log.
*/

CREATE TABLE cp4_funcionarios_log (
log_id NUMBER PRIMARY KEY,
operacao VARCHAR2(10),
id_funcionario NUMBER,
nome VARCHAR2(100),
salario NUMBER,
departamento VARCHAR2(100),
data_contratacao DATE,
gerente_nome VARCHAR2(100),
data_alteracao DATE
);
/

CREATE SEQUENCE cp4_funcionarios_log_seq START WITH 1 INCREMENT BY 1;
/

CREATE OR REPLACE TRIGGER trg_cp4_funcionarios_log
AFTER INSERT OR UPDATE OR DELETE ON cp4_funcionarios
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO cp4_funcionarios_log (log_id, operacao, id_funcionario, nome, salario, departamento, data_contratacao, gerente_nome, data_alteracao)
VALUES (cp4_funcionarios_log_seq.NEXTVAL, 'INSERT', :NEW.id, :NEW.nome, :NEW.salario, :NEW.departamento, :NEW.data_contratacao, :NEW.gerente_nome, SYSDATE);

ELSIF UPDATING THEN
INSERT INTO cp4_funcionarios_log (log_id, operacao, id_funcionario, nome, salario, departamento, data_contratacao, gerente_nome, data_alteracao)
VALUES (cp4_funcionarios_log_seq.NEXTVAL, 'UPDATE', :NEW.id, :NEW.nome, :NEW.salario, :NEW.departamento, :NEW.data_contratacao, :NEW.gerente_nome, SYSDATE);

ELSIF DELETING THEN
INSERT INTO cp4_funcionarios_log (log_id, operacao, id_funcionario, nome, salario, departamento, data_contratacao, gerente_nome, data_alteracao)
VALUES (cp4_funcionarios_log_seq.NEXTVAL, 'DELETE', :OLD.id, :OLD.nome, :OLD.salario, :OLD.departamento, :OLD.data_contratacao, :OLD.gerente_nome, SYSDATE);
END IF;
END;
/

SET SERVEROUTPUT ON;

BEGIN
-- Atualiza o salário de um funcionário para gerar um log
pkg_funcionario.atualizar_salario(1, 6000);
DBMS_OUTPUT.PUT_LINE('Salário do funcionário com ID 1 atualizado para 6000.');

-- Consulta o log de alterações
FOR rec IN (SELECT * FROM cp4_funcionarios_log) LOOP
DBMS_OUTPUT.PUT_LINE('Log ID: ' || rec.log_id || ', Operação: ' || rec.operacao || ', ID Funcionário: ' || rec.id_funcionario || ', Data de Alteração: ' || rec.data_alteracao);
END LOOP;
END;
/

/*Triggers:
10. Escreva um trigger que impeça a inserção de um novo funcionário com
salário menor que o salário mínimo atual da nossa legislação.*/

CREATE OR REPLACE TRIGGER trg_salario_minimo
BEFORE INSERT OR UPDATE ON cp4_funcionarios
FOR EACH ROW
DECLARE
salario_minimo NUMBER := 1212;  -- Substitua pelo salário mínimo atual
BEGIN
IF :NEW.salario < salario_minimo THEN
RAISE_APPLICATION_ERROR(-20001, 'O salário do funcionário não pode ser menor que o salário mínimo.');
END IF;
END;
/

SET SERVEROUTPUT ON;

BEGIN
-- Tenta inserir um funcionário com salário abaixo do mínimo
BEGIN
inserir_funcionario(7, 'Lucas Pereira', 1000, 'TI', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Ana Souza');
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
END;
/

/*Triggers:
11. Desenvolva um trigger que atualize automaticamente a data de modificação
da tabela departamento, sempre que um registro na tabela de departamentos*/
CREATE TABLE cp4_departamentos (
departamento_id NUMBER PRIMARY KEY,
nome VARCHAR2(100),
data_modificacao DATE
);
/

CREATE OR REPLACE TRIGGER trg_atualizar_data_modificacao
BEFORE UPDATE ON cp4_departamentos
FOR EACH ROW
BEGIN
:NEW.data_modificacao := SYSDATE;
END;
/

SET SERVEROUTPUT ON;

-- Atualiza o nome de um departamento para acionar a trigger
BEGIN
UPDATE cp4_departamentos SET nome = 'Recursos Humanos' WHERE departamento_id = 1;
DBMS_OUTPUT.PUT_LINE('Nome do departamento atualizado para Recursos Humanos.');

-- Consulta para exibir todos os registros da tabela cp4_departamentos após a atualização
FOR rec IN (SELECT * FROM cp4_departamentos) LOOP
DBMS_OUTPUT.PUT_LINE('Departamento ID: ' || rec.departamento_id || ', Nome: ' || rec.nome || ', Data de Modificação: ' || rec.data_modificacao);
END LOOP;
END;
/

/*Triggers:
12. Implemente um trigger que notifique em uma tabela de recursos humanos
sempre que um novo funcionário for contratado.*/

CREATE TABLE cp4_rh_notificacoes (
notificacao_id NUMBER PRIMARY KEY,
id_funcionario NUMBER,
nome_funcionario VARCHAR2(100),
data_contratacao DATE,
data_notificacao DATE
);
/

-- Criação da sequência para a tabela de notificações
CREATE SEQUENCE cp4_rh_notificacoes_seq START WITH 1 INCREMENT BY 1;
/

CREATE OR REPLACE TRIGGER trg_notificar_nova_contratacao
AFTER INSERT ON cp4_funcionarios
FOR EACH ROW
BEGIN
INSERT INTO cp4_rh_notificacoes (notificacao_id, id_funcionario, nome_funcionario, data_contratacao, data_notificacao)
VALUES (cp4_rh_notificacoes_seq.NEXTVAL, :NEW.id, :NEW.nome, :NEW.data_contratacao, SYSDATE);
END;
/

SET SERVEROUTPUT ON;

BEGIN
-- Insere um novo funcionário para acionar a notificação
inserir_funcionario(8, 'Marcelo Oliveira', 4500, 'Financeiro', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Lucas Pereira');
DBMS_OUTPUT.PUT_LINE('Novo funcionário Marcelo Oliveira inserido.');

-- Consulta para exibir todos os registros da tabela cp4_rh_notificacoes após a inserção
FOR rec IN (SELECT * FROM cp4_rh_notificacoes) LOOP
DBMS_OUTPUT.PUT_LINE('Notificação ID: ' || rec.notificacao_id || ', ID Funcionário: ' || rec.id_funcionario || ', Nome: ' || rec.nome_funcionario || ', Data de Notificação: ' || rec.data_notificacao);
END LOOP;
END;
/

/*Encapsulamento de objeto:
13. Desenvolva uma package denominada pkg_util que deve ter incluído os
seguintes objetos já desenvolvidos anteriormente nos exercícios 5 e 6.*/

-- DEFINIÇÃO DO PACOTE
CREATE OR REPLACE PACKAGE pkg_util AS
-- Procedure para retornar o número total de funcionários em um departamento
PROCEDURE total_funcionarios_departamento(
p_nome_departamento IN VARCHAR2,
p_total_funcionarios OUT NUMBER
);

-- Procedure para inserir um novo registro na tabela de funcionários
PROCEDURE inserir_funcionario(
p_id IN NUMBER,
p_nome IN VARCHAR2,
p_salario IN NUMBER,
p_departamento IN VARCHAR2,
p_data_contratacao IN DATE,
p_gerente_nome IN VARCHAR2
);
END pkg_util;
/

-- IMPLEMENTAÇÃO DO CORPO

CREATE OR REPLACE PACKAGE BODY pkg_util AS

PROCEDURE total_funcionarios_departamento(
p_nome_departamento IN VARCHAR2,
p_total_funcionarios OUT NUMBER
) AS
BEGIN
SELECT COUNT(*) INTO p_total_funcionarios
FROM cp4_funcionarios
WHERE departamento = p_nome_departamento;
END total_funcionarios_departamento;

PROCEDURE inserir_funcionario(
p_id IN NUMBER,
p_nome IN VARCHAR2,
p_salario IN NUMBER,
p_departamento IN VARCHAR2,
p_data_contratacao IN DATE,
p_gerente_nome IN VARCHAR2
) AS
BEGIN
INSERT INTO cp4_funcionarios (id, nome, salario, departamento, data_contratacao, gerente_nome)
VALUES (p_id, p_nome, p_salario, p_departamento, p_data_contratacao, p_gerente_nome);

COMMIT;
END inserir_funcionario;

END pkg_util;
/

-- TESTE

SET SERVEROUTPUT ON;

DECLARE
v_total_funcionarios NUMBER;
BEGIN
-- Testando a procedure para contar o total de funcionários em um departamento
pkg_util.total_funcionarios_departamento('TI', v_total_funcionarios);
DBMS_OUTPUT.PUT_LINE('Total de funcionários no departamento de TI: ' || v_total_funcionarios);

-- Testando a procedure para inserir um novo funcionário
pkg_util.inserir_funcionario(9, 'Fernando Silva', 4700, 'Marketing', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Maria Souza');
DBMS_OUTPUT.PUT_LINE('Novo funcionário Fernando Silva inserido com sucesso.');

-- Verificar a inserção de funcionário
FOR rec IN (SELECT * FROM cp4_funcionarios) LOOP
DBMS_OUTPUT.PUT_LINE('ID: ' || rec.id || ', Nome: ' || rec.nome || ', Salário: ' || rec.salario);
END LOOP;
END;
/
