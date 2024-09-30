--PACKAGE CRIACAO

SET SERVEROUTPUT ON

EXECUTE PKG_PACOTE.CALCULA_REAJUSTE(1500);

ALTER PACKAGE PKG_PACOTE COMPILE;
ALTER PACKAGE PKG_PACOTE COMPILE BODY;

DROP PACKAGE PKG_PACOTE;

-- PRIVILÉGIO DE ACESSO (PARA QUALQUER PESSOA ACESSAR, CASO SEJA PARA UMA PESSOA
-- ESPECÍFICA ACESSAR, TROCAR PUBLIC PELO NOME ESPECÍFICO
GRANT EXECUTE ON PKG_PACKAGE TO PUBLIC;

/* exercício 1:
criar um pacote pl-sql com nome "calculadora" que contenha um procedimento
para calcular o valor do novo salário mínimo que deverá ser de 25% em cima do 
atual, que é de r$1320,00*/

-- Especificação (Specification)
CREATE OR REPLACE PACKAGE PKG_CALCULADORA IS
    PROCEDURE CALCULA_NOVO_SAL_MIN;
END PKG_CALCULADORA;
/

-- Corpo (Body)
CREATE OR REPLACE PACKAGE BODY PKG_CALCULADORA IS
    PROCEDURE CALCULA_NOVO_SAL_MIN IS
        V_SAL_ATUAL NUMBER := 1320.00;
        V_SAL_REAJ NUMBER(7,2);
    BEGIN
        V_SAL_REAJ := V_SAL_ATUAL * 1.25;
        DBMS_OUTPUT.PUT_LINE('SALÁRIO MÍNIMO ATUAL - R$: ' || V_SAL_ATUAL);
        DBMS_OUTPUT.PUT_LINE('SALÁRIO MÍNIMO REAJUSTADO - R$: ' || V_SAL_REAJ);
    END CALCULA_NOVO_SAL_MIN;
END PKG_CALCULADORA;
/
-- REPOSTA EXERCÍCIO 1 : SAÍDA NA TELA
SET SERVEROUTPUT ON;

BEGIN
    PKG_CALCULADORA.CALCULA_NOVO_SAL_MIN;
END;
/

/* EXERCÍCIO 2:
CRIAR NO PACOTE CALCULADORA UMA FUNÇÃO PARA CALCULAR O VALOR EM REAIS DE
45 DOLARES, SENDO QUE O VALOR DO CAMBIO A SER CONSIDERADO É DE 5,04*/

CREATE OR REPLACE PACKAGE PKG_CALCULADORA IS
    PROCEDURE CALCULA_NOVO_SAL_MIN;
    FUNCTION CONVERTE_DOLAR_PARA_REAL RETURN NUMBER;
END PKG_CALCULADORA;
/

CREATE OR REPLACE PACKAGE BODY PKG_CALCULADORA IS

    PROCEDURE CALCULA_NOVO_SAL_MIN IS
        V_SAL_ATUAL NUMBER := 1320.00;
        V_SAL_REAJ NUMBER(7,2);
    BEGIN
        V_SAL_REAJ := V_SAL_ATUAL * 1.25;
        DBMS_OUTPUT.PUT_LINE('SALÁRIO MÍNIMO ATUAL - R$: ' || V_SAL_ATUAL);
        DBMS_OUTPUT.PUT_LINE('SALÁRIO MÍNIMO REAJUSTADO - R$: ' || V_SAL_REAJ);
    END CALCULA_NOVO_SAL_MIN;

    FUNCTION CONVERTE_DOLAR_PARA_REAL RETURN NUMBER IS
        V_VALOR_DOLAR NUMBER := 45;
        V_CAMBIO NUMBER := 5.04;
        V_VALOR_EM_REAIS NUMBER;
    BEGIN
        V_VALOR_EM_REAIS := V_VALOR_DOLAR * V_CAMBIO;
        RETURN V_VALOR_EM_REAIS;
    END CONVERTE_DOLAR_PARA_REAL;

END PKG_CALCULADORA;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
BEGIN
    -- Chama o procedimento para calcular o reajuste do salário mínimo
    PKG_CALCULADORA.CALCULA_NOVO_SAL_MIN;
    
    -- Chama a função para calcular o valor em reais de 45 dólares
    V_RESULTADO := PKG_CALCULADORA.CONVERTE_DOLAR_PARA_REAL;
    DBMS_OUTPUT.PUT_LINE('45 dólares em reais: R$' || V_RESULTADO);
END;
/
-- Especificação (Specification)
CREATE OR REPLACE PACKAGE PKG_PACOTE IS
    PROCEDURE CALCULA_REAJUSTE(P_SAL_ATUAL IN NUMBER);
END PKG_PACOTE;
/

-- Corpo (Body)
CREATE OR REPLACE PACKAGE BODY PKG_PACOTE IS
    PROCEDURE CALCULA_REAJUSTE(P_SAL_ATUAL IN NUMBER) IS
        V_SAL_REAJ NUMBER(7,2);
    BEGIN
        V_SAL_REAJ := P_SAL_ATUAL * 1.25;
        DBMS_OUTPUT.PUT_LINE('SALÁRIO ATUAL - R$: ' || P_SAL_ATUAL);
        DBMS_OUTPUT.PUT_LINE('SALÁRIO REAJUSTADO - R$: ' || V_SAL_REAJ);
    END CALCULA_REAJUSTE;
END PKG_PACOTE;
/