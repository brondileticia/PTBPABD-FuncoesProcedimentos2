-- ============================================================================
-- ATIVIDADE DE BANCO DE DADOS - PROCEDURE SALARY HISTOGRAM
-- Disciplina: Programação e Administração de Banco de Dados
-- ============================================================================
-- QUESTÃO 01: Criar procedimento salaryHistogram
-- ============================================================================
--
-- DESCRIÇÃO: Distribui as frequências dos salários dos instrutores em intervalos
--
-- PARÂMETRO DE ENTRADA: @num_intervals (número de intervalos do histograma)
--
-- EXEMPLO: EXEC dbo.salaryHistogram 5;
-- ============================================================================

CREATE PROCEDURE salaryHistogram
    @num_intervals INT
AS
BEGIN
    -- Declaração das variáveis
    DECLARE @min_salary DECIMAL(10,2);
    DECLARE @max_salary DECIMAL(10,2);
    DECLARE @interval_width DECIMAL(10,2);
    DECLARE @i INT = 1;
    
    -- Tabela temporária para armazenar os resultados
    CREATE TABLE #histogram (
        intervalo INT,
        valorMinimo DECIMAL(10,2),
        valorMaximo DECIMAL(10,2),
        total INT
    );
    
    -- Obter o menor e maior salário da tabela instructor
    SELECT @min_salary = MIN(salary), @max_salary = MAX(salary)
    FROM instructor;
    
    -- Calcular a largura de cada intervalo
    SET @interval_width = (@max_salary - @min_salary) / @num_intervals;
    
    -- Loop para criar os intervalos e contar as frequências
    WHILE @i <= @num_intervals
    BEGIN
        DECLARE @lower DECIMAL(10,2);
        DECLARE @upper DECIMAL(10,2);
        DECLARE @count INT;
        
        -- Definir os limites do intervalo atual
        SET @lower = @min_salary + (@i - 1) * @interval_width;
        
        IF @i = @num_intervals
            SET @upper = @max_salary;
        ELSE
            SET @upper = @min_salary + @i * @interval_width - 0.01;
        
        -- Contar quantos instrutores estão neste intervalo
        SELECT @count = COUNT(*)
        FROM instructor
        WHERE salary >= @lower AND salary <= @upper;
        
        -- Inserir na tabela temporária
        INSERT INTO #histogram VALUES (@i, @lower, @upper, @count);
        
        SET @i = @i + 1;
    END
    
    -- Retornar o resultado
    SELECT 
        intervalo,
        valorMinimo,
        valorMaximo,
        total
    FROM #histogram
    ORDER BY intervalo;
    
    -- Limpar a tabela temporária
    DROP TABLE #histogram;
END;

-- ============================================================================
-- TESTE
-- ============================================================================

EXEC dbo.salaryHistogram 5;
