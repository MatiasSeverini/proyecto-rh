CREATE DATABASE recursos_humanos;

USE recursos_humanos;

SELECT * FROM rrhh;

ALTER TABLE rrhh
	CHANGE COLUMN Id emp_id VARCHAR(20) NULL;

ALTER TABLE `recursos_humanos`.`rrhh` 
	CHANGE COLUMN `Locació` `Locación` TEXT NULL DEFAULT NULL ;

ALTER TABLE `recursos_humanos`.`rrhh` 
	CHANGE COLUMN `Fecha_contratato` `Fecha_contrato` TEXT NULL DEFAULT NULL ;
    
ALTER TABLE `recursos_humanos`.`rrhh` 
	CHANGE COLUMN `Puesto` `Departamento` TEXT NULL DEFAULT NULL ;

DESCRIBE rrhh;

SELECT Fecha_nacimiento from rrhh;

SET sql_safe_updates = 0;

UPDATE rrhh 
	SET Fecha_nacimiento = CASE 
        WHEN Fecha_nacimiento LIKE '%/%' THEN date_format(STR_TO_DATE(Fecha_nacimiento, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN Fecha_nacimiento LIKE '%-%' THEN date_format(STR_TO_DATE(Fecha_nacimiento, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL 
    END;
    
ALTER TABLE rrhh
	MODIFY COLUMN Fecha_nacimiento DATE;
    
UPDATE rrhh 
	SET Fecha_contrato = CASE 
        WHEN Fecha_contrato LIKE '%/%' THEN date_format(STR_TO_DATE(Fecha_contrato, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN Fecha_contrato LIKE '%-%' THEN date_format(STR_TO_DATE(Fecha_contrato, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL 
    END;
    
ALTER TABLE rrhh
	MODIFY COLUMN Fecha_contrato DATE;

update rrhh
	SET fechadetermino = DATE(str_to_date(fechadetermino, '%Y-%m-%d%H:%i:%s UTC'))
	WHERE fechadetermino IS NOT NULL AND fechadetermino !='';

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE rrhh
	MODIFY COLUMN fechadetermino DATE;

ALTER TABLE rrhh ADD COLUMN Edad Int;

UPDATE rrhh 
	SET Edad = timestampdiff(YEAR, fecha_nacimiento, CURDATE());	
    
SELECT 
	MIN(Edad) as Joven,
    MAX(Edad) as Adulto
FROM rrhh;

-- PREGUNTAS

-- 1. ¿Cuál es la distribución por género de los empleados de la empresa?
SELECT Genero, count(*) as count
FROM rrhh
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY Genero; 
-- 2. ¿Cuál es la distribución por edades de los empleados de la empresa?
SELECT 
	min(Edad) as Joven,
    max(Edad) as Mayor
FROM rrhh
WHERE Edad >= 18 and fechadetermino = '0000-00-00';
SELECT 
	CASE 
		WHEN Edad >= 18 and Edad <=24 THEN '18-24'
        WHEN Edad >= 25 and Edad <=34 THEN '25-34'
        WHEN Edad >= 35 and Edad <=44 THEN '35-44'
        WHEN Edad >= 45 and Edad <=54 THEN '44-54'
        WHEN Edad >= 55 and Edad <=64 THEN '55-64'
        ELSE '65+'
	END AS grupo_edad, genero,
    count(*) AS count
FROM rrhh
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY grupo_edad, genero
order by grupo_edad, genero;

-- 3. ¿Cuántos empleados trabajan en la sede en comparación con ubicaciones remotas?
SELECT Locación, count(*) AS count
FROM rrhh
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY Locación;

-- 4. ¿Cuál es la duración promedio del empleo para los empleados que han sido despedidos?
SELECT
	round(avg(datediff(fechadetermino, Fecha_contrato))/365,0) AS avg_promedio
FROM rrhh
WHERE fechadetermino <= curdate() and fechadetermino <> '0000-00-00' AND Edad >= 18;
-- 5. ¿Cómo varía la distribución de género entre departamentos y puestos de trabajo?
SELECT Departamento, Genero, count(*) AS count
FROM rrhh 
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY Departamento, Genero 
ORDER BY Departamento;

-- 6. ¿Cuál es la distribución de los puestos de trabajo en toda la empresa?
SELECT Titulo, count(*) AS count 
FROM rrhh
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY Titulo
ORDER BY Titulo DESC;

-- 7. ¿Qué departamento tiene la tasa de rotación más alta?
SELECT Departamento,
	cuenta_total,
    cuenta_terminada,
    cuenta_terminada/cuenta_total as tasa_terminacion
FROM (
	SELECT Departamento, 
    count(*) AS cuenta_total,
    sum(CASE WHEN fechadetermino <> '0000''00''00' 
		AND fechadetermino <= curdate() THEN 1 ELSE 0 END) AS cuenta_terminada
	FROM rrhh
	WHERE Edad >= 18 
    GROUP BY Departamento 
	) AS subquery
    ORDER BY tasa_terminacion DESC;
-- 8. ¿Cuál es la distribución de empleados en todas las ubicaciones por ciudad y estado?
SELECT estado, COUNT(*) AS count
FROM rrhh 
WHERE Edad >= 18 and fechadetermino = '0000-00-00'
GROUP BY Estado
ORDER BY count DESC;
-- 9. ¿Cómo ha cambiado el recuento de empleados de la empresa a lo largo del tiempo según las fechas de contratación y plazo?
SELECT 
	year,
    Contrato,
    Terminaciones,
    Contrato - Terminaciones AS cambio_neto, 
    round((Contrato - Terminaciones)/Contrato *100,2) AS porcentaje_cambio_neto
FROM(
	SELECT 
		YEAR(Fecha_contrato) AS year,
		count(*) as Contrato,
		SUM(CASE WHEN fechadetermino <> '0000-00-00' and fechadetermino <= curdate() THEN 1 ELSE 0 END) AS Terminaciones
        FROM rrhh
        WHERE Edad >=18
        GROUP BY YEAR(Fecha_contrato)
        ) AS subquery 
ORDER BY year ASC;
-- 10. ¿Cuál es la distribución de la tenencia para cada departamento?

SELECT departamento, ROUND(AVG(DATEDIFF(CURDATE(), fechadetermino)/365),0) as avg_tenure
FROM rrhh
WHERE fechadetermino <= CURDATE() AND fechadetermino <> '0000-00-00' AND Edad >= 18
GROUP BY departamento;




