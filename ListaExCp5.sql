-- Drop tables se já existirem
DROP TABLE FUNCIONARIOS;

DROP TABLE CLIENTES;

-- Criação das tabelas
CREATE TABLE FUNCIONARIOS (
    ID NUMBER(6) PRIMARY KEY, -- Identificador único do funcionário
    NOME VARCHAR2(100), -- Nome do funcionário
    CARGO VARCHAR2(50), -- Cargo do funcionário
    SALARIO NUMBER(10, 2) -- Salário do funcionário
);

CREATE TABLE CLIENTES (
    ID NUMBER(6) PRIMARY KEY, -- Identificador único do cliente
    NOME VARCHAR2(100), -- Nome do cliente
    TELEFONE VARCHAR2(15) -- Telefone do cliente
);

-- Inserindo dados nas tabelas de funcionários
INSERT INTO FUNCIONARIOS (ID,NOME,CARGO,SALARIO) 
VALUES (1,'João Silva','Desenvolvedor',5000);

INSERT INTO FUNCIONARIOS (ID,NOME,CARGO,SALARIO) 
VALUES (2,'Maria Souza','Analista',4000);

INSERT INTO FUNCIONARIOS (ID,NOME,CARGO,SALARIO) 
VALUES (3,'Carlos Pereira','Gerente',7000);

INSERT INTO FUNCIONARIOS (ID,NOME,CARGO,SALARIO) 
VALUES (4,'Fernanda Costa','Desenvolvedor',4500);

INSERT INTO FUNCIONARIOS (ID,NOME,CARGO,SALARIO) 
VALUES (5,'Ana Martins','Analista', 4200);

-- 1. Criar um Record para armazenar informações de um funcionário
-- Enunciado: Crie um record para armazenar os dados de um funcionário (ID, Nome, Cargo, Salário) da tabela funcionarios.
-- Em seguida, insira valores no record.
DECLARE
    TYPE EMP_RECORD IS RECORD (
        EMP_ID FUNCIONARIOS.ID%TYPE,
        EMP_NAME FUNCIONARIOS.NOME%TYPE,
        EMP_CARGO FUNCIONARIOS.CARGO%TYPE,
        EMP_SAL FUNCIONARIOS.SALARIO%TYPE
    );
    V_EMP EMP_RECORD;
BEGIN
    -- Atribuindo valores ao record
    V_EMP.EMP_ID := 1;
    V_EMP.EMP_NAME := 'João Silva';
    V_EMP.EMP_CARGO := 'Desenvolvedor';
    V_EMP.EMP_SAL := 5000;

    -- Exibindo valores
    DBMS_OUTPUT.PUT_LINE('ID: '|| V_EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('Nome: '|| V_EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('Cargo: '|| V_EMP.EMP_CARGO);
    DBMS_OUTPUT.PUT_LINE('Salário: '|| V_EMP.EMP_SAL);
END;
/

-- 2. Crie uma collection (VARRAY) para armazenar os IDs de 5 funcionários da tabela funcionarios.
DECLARE
    TYPE EMP_ID_ARRAY IS
        VARRAY(5) OF FUNCIONARIOS.ID%TYPE;
    V_EMP_IDS EMP_ID_ARRAY := EMP_ID_ARRAY(1, 2, 3, 4, 5);
BEGIN
    FOR I IN 1..V_EMP_IDS.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID do Funcionário: '|| V_EMP_IDS(I));
    END LOOP;
END;
/

-- 3. Crie uma plsql table para armazenar os nomes de clientes da tabela clientes.
-- Em seguida, insira três nomes e exiba-os.
DECLARE
    TYPE CLIENT_NAME_TABLE IS
        TABLE OF CLIENTES.NOME%TYPE;
    V_CLIENT_NAMES CLIENT_NAME_TABLE := CLIENT_NAME_TABLE('Ana', 'Pedro', 'Lucas');
BEGIN
    FOR I IN 1..V_CLIENT_NAMES.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Nome do Cliente: '|| V_CLIENT_NAMES(I));
    END LOOP;
END;
/

-- 4. Crie uma plsql table para armazenar os nomes dos funcionários da tabela funcionarios.
-- Preencha essa tabela com dados reais da tabela.
DECLARE
    TYPE EMP_NAME_TABLE IS
        TABLE OF FUNCIONARIOS.NOME%TYPE INDEX BY PLS_INTEGER;
    V_EMP_NAMES EMP_NAME_TABLE;
BEGIN
    SELECT
        NOME BULK COLLECT INTO V_EMP_NAMES
    FROM
        FUNCIONARIOS;
    FOR I IN 1..V_EMP_NAMES.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Nome do Funcionário: '|| V_EMP_NAMES(I));
    END LOOP;
END;
/

-- 5. Utilize uma plsql table para armazenar os IDs de funcionários.
-- Em seguida, aumente o salário em 10% para cada funcionário cujo ID está na plsql table.
DECLARE
    TYPE EMP_ID_TABLE IS
        TABLE OF FUNCIONARIOS.ID%TYPE;
    V_EMP_IDS EMP_ID_TABLE := EMP_ID_TABLE(1, 2, 3); -- IDs de exemplo
BEGIN
    FOR I IN 1..V_EMP_IDS.COUNT LOOP
        UPDATE FUNCIONARIOS
        SET
            SALARIO = SALARIO * 1.10
        WHERE
            ID = V_EMP_IDS(I);
        DBMS_OUTPUT.PUT_LINE('Salário do Funcionário ID '||V_EMP_IDS(I)|| ' foi aumentado em 10%.');
    END LOOP;
END;
/

-- 6. Crie um associative array para armazenar os nomes dos funcionários indexados por seus IDs.
DECLARE
    TYPE EMP_ASSOC_ARRAY IS
        TABLE OF FUNCIONARIOS.NOME%TYPE INDEX BY PLS_INTEGER;
    V_EMP_ASSOC EMP_ASSOC_ARRAY;
    V_EMP_IDS   SYS_REFCURSOR; -- Cursor para armazenar os IDs e nomes
    V_ID        FUNCIONARIOS.ID%TYPE;
    V_NOME      FUNCIONARIOS.NOME%TYPE;
    I           PLS_INTEGER := 1;
BEGIN
    -- Abrindo o cursor para buscar IDs e nomes
    OPEN V_EMP_IDS FOR
        SELECT
            ID,
            NOME
        FROM
            FUNCIONARIOS;
    -- Loop para buscar valores do cursor e armazenar na tabela associativa
    LOOP
        FETCH V_EMP_IDS INTO V_ID, V_NOME;
        EXIT WHEN V_EMP_IDS%NOTFOUND;
        V_EMP_ASSOC(I) := V_NOME; -- Armazenando o nome no índice numérico
        I := I + 1;
    END LOOP;

    CLOSE V_EMP_IDS;

    -- Iterando pela tabela associativa e exibindo os valores
    FOR IDX IN 1..V_EMP_ASSOC.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Nome do Funcionário: '|| V_EMP_ASSOC(IDX));
    END LOOP;
END;
/

-- 7. Crie uma função que recebe o ID do cliente e retorna um record com os dados do cliente (ID, Nome, Telefone).
CREATE OR REPLACE FUNCTION GET_CLIENT_INFO(
    P_ID CLIENTES.ID%TYPE
) RETURN CLIENTES%ROWTYPE IS
    V_CLIENT CLIENTES%ROWTYPE;
BEGIN
    SELECT
        * INTO V_CLIENT
    FROM
        CLIENTES
    WHERE
        ID = P_ID;
    RETURN V_CLIENT;
END;
/

-- 8. Insira 2 novos clientes na tabela clientes usando uma plsql table e o comando FOR tradicional.
DECLARE
    TYPE CLIENT_TABLE IS
        TABLE OF CLIENTES%ROWTYPE;
    V_CLIENTS CLIENT_TABLE;
    V_CLIENT  CLIENTES%ROWTYPE; -- Registro temporário para cada cliente
BEGIN

    -- Inicializando a tabela de clientes
    V_CLIENTS := CLIENT_TABLE();

    -- Adicionando clientes à tabela
    V_CLIENT.ID := 101;
    V_CLIENT.NOME := 'Maria Souza';
    V_CLIENT.TELEFONE := '123456789';
    V_CLIENTS.EXTEND; -- Aumenta o tamanho da tabela para adicionar um novo registro
    V_CLIENTS(V_CLIENTS.COUNT) := V_CLIENT; -- Adiciona o cliente ao array

    V_CLIENT.ID := 102;
    V_CLIENT.NOME := 'Carlos Silva';
    V_CLIENT.TELEFONE := '987654321';
    V_CLIENTS.EXTEND; -- Aumenta o tamanho da tabela para adicionar um novo registro
    V_CLIENTS(V_CLIENTS.COUNT) := V_CLIENT; -- Adiciona o cliente ao array

    -- Inserir os dados na tabela de clientes
    FOR I IN 1..V_CLIENTS.COUNT LOOP
        INSERT INTO CLIENTES (
            ID,
            NOME,
            TELEFONE
        ) VALUES (
            V_CLIENTS(I).ID,
            V_CLIENTS(I).NOME,
            V_CLIENTS(I).TELEFONE
        );
        DBMS_OUTPUT.PUT_LINE('Cliente '|| V_CLIENTS(I).NOME|| ' inserido com sucesso.');
    END LOOP;
END;
/

-- 9. Insira 3 novos funcionários na tabela funcionarios usando uma plsql table e o comando FOR tradicional.
DECLARE
    TYPE EMP_TABLE IS
        TABLE OF FUNCIONARIOS%ROWTYPE;
    V_EMPS EMP_TABLE;
    V_EMP  FUNCIONARIOS%ROWTYPE; -- Registro temporário para cada funcionário
BEGIN
    -- Inicializando a tabela de funcionários
    V_EMPS := EMP_TABLE();

    -- Adicionando funcionários à tabela
    V_EMP.ID := 201;
    V_EMP.NOME := 'Fernanda';
    V_EMP.CARGO := 'Analista';
    V_EMP.SALARIO := 3000;
    V_EMPS.EXTEND; -- Aumenta o tamanho da tabela para adicionar um novo registro
    V_EMPS(V_EMPS.COUNT) := V_EMP; -- Adiciona o funcionário ao array
    V_EMP.ID := 202;
    V_EMP.NOME := 'Ricardo';
    V_EMP.CARGO := 'Desenvolvedor';
    V_EMP.SALARIO := 4500;
    V_EMPS.EXTEND; -- Aumenta o tamanho da tabela para adicionar um novo registro
    V_EMPS(V_EMPS.COUNT) := V_EMP; -- Adiciona o funcionário ao array
    V_EMP.ID := 203;
    V_EMP.NOME := 'Sofia';
    V_EMP.CARGO := 'Gerente';
    V_EMP.SALARIO := 7000;
    V_EMPS.EXTEND; -- Aumenta o tamanho da tabela para adicionar um novo registro
    V_EMPS(V_EMPS.COUNT) := V_EMP; -- Adiciona o funcionário ao array
    -- Inserir os dados na tabela de funcionários
    FOR I IN 1..V_EMPS.COUNT LOOP
        INSERT INTO FUNCIONARIOS (
            ID,
            NOME,
            CARGO,
            SALARIO
        ) VALUES (
            V_EMPS(I).ID,
            V_EMPS(I).NOME,
            V_EMPS(I).CARGO,
            V_EMPS(I).SALARIO
        );
        DBMS_OUTPUT.PUT_LINE('Funcionário '|| V_EMPS(I).NOME|| ' inserido com sucesso.');
    END LOOP;
END;
/

-- 10. Crie um associative array para calcular a média dos salários dos funcionários agrupados por cargo.
DECLARE
    TYPE AVG_SAL_ASSOC_ARRAY IS
        TABLE OF NUMBER INDEX BY FUNCIONARIOS.CARGO%TYPE;
    V_AVG_SAL AVG_SAL_ASSOC_ARRAY;
    V_CARGO   FUNCIONARIOS.CARGO%TYPE;
BEGIN
    FOR REC IN (
        SELECT
            CARGO,
            AVG(SALARIO) AS AVG_SAL
        FROM
            FUNCIONARIOS
        GROUP BY
            CARGO
    ) LOOP
        V_AVG_SAL(REC.CARGO) := REC.AVG_SAL;
    END LOOP;

    -- Exibir as médias por cargo
    V_CARGO := V_AVG_SAL.FIRST;
    WHILE V_CARGO IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Cargo: '|| V_CARGO|| ', Média Salarial: '|| V_AVG_SAL(V_CARGO));
        
        V_CARGO := V_AVG_SAL.NEXT(V_CARGO);
    END LOOP;
END;
/