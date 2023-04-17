CREATE DATABASE ex_triggers_07
GO
USE ex_triggers_07
GO
CREATE TABLE cliente (
codigo        INT            NOT NULL,
nome        VARCHAR(70)    NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE venda (
codigo_venda    INT                NOT NULL,
codigo_cliente    INT                NOT NULL,
valor_total        DECIMAL(7,2)    NOT NULL
PRIMARY KEY (codigo_venda)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)
GO
CREATE TABLE pontos (
codigo_cliente    INT                    NOT NULL,
total_pontos    DECIMAL(4,1)        NOT NULL
PRIMARY KEY (codigo_cliente)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)
GO
CREATE TABLE TAB
(
codigo_venda    INT                NOT NULL,
codigo_cliente    INT                NULL,
valor_total        DECIMAL(7,2)    NULL
PRIMARY KEY (codigo_venda)
)
GO
INSERT INTO TAB VALUES (1,0,0)
GO
CREATE TRIGGER TVENDD ON VENDA
FOR DELETE, UPDATE
AS
BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('NAO E POSSIVEL DELETAR E ATUALIZAR VENDA',16,1)
END
---------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE CREATC
AS
BEGIN

    DECLARE @I INT
    SET @I = 1
    WHILE(@I <= 10)
    BEGIN
        INSERT INTO cliente VALUES (@I, CONCAT('CLIENTE',CAST(@I AS VARCHAR(02))))
        SET @I = @I + 1 
    END
END
GO
CREATE PROCEDURE CREATV
AS
BEGIN
    DECLARE @RAND INT,
            @I INT,
            @VAL DECIMAL(5,2)
    SET @VAL = 0
    SET @I = 1
    SET @RAND = 0
    WHILE(@I <= 10)
    BEGIN
        SET @RAND = ((RAND()*10)+1)
        SET @VAL = ((RAND()*100)+1)
        INSERT INTO venda VALUES (@I,@RAND,@VAL)
        SET @I = @I + 1 
    END
END
GO
---------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER TUPDATE ON VENDA
INSTEAD OF UPDATE
AS
BEGIN
	SELECT * FROM TAB
END

 

GO
---------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER TINSERT ON VENDA
FOR INSERT
AS
BEGIN
    DECLARE @TOT DECIMAL(4,1),
            @CLICODE INT

 

    SET @TOT = 0
    SET @CLICODE = (SELECT P.codigo_cliente FROM pontos P WHERE P.codigo_cliente = (SELECT codigo_cliente FROM inserted))
    SET @TOT = ((SELECT SUM(V.valor_total) FROM venda V WHERE V.codigo_cliente = 
    (SELECT codigo_cliente FROM inserted))*0.1)

    IF(@CLICODE IS NULL)
    BEGIN
        INSERT INTO pontos VALUES ((SELECT codigo_cliente FROM inserted),@TOT)
    END
    ELSE
    BEGIN
        UPDATE pontos
        SET pontos.total_pontos = @TOT
        WHERE pontos.codigo_cliente = @CLICODE
    END
    IF((SELECT P.total_pontos FROM pontos P WHERE P.codigo_cliente = (SELECT codigo_cliente FROM inserted))>1)
    BEGIN
        PRINT('GANHOU UM PREMIO')
    END

 

    UPDATE TAB
    SET TAB.codigo_cliente = (SELECT codigo_cliente FROM inserted), 
    TAB.valor_total = (SELECT valor_total FROM inserted)
    WHERE TAB.codigo_venda = 1
END
---------------------------------------------------------------------------------------------------------------------------
GO
EXEC CREATC
GO
SELECT * FROM cliente
GO
EXEC CREATV
GO
SELECT * FROM venda
GO
DELETE FROM venda WHERE venda.codigo_venda = 1
GO
UPDATE venda
SET venda.valor_total = 190.79
WHERE
venda.codigo_venda = 1
GO
INSERT INTO venda VALUES (19,1,1400.6)
GO
SELECT * FROM pontos
