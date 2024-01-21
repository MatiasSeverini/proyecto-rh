# Proyecto rrhh
## Proyecto DA mysql

### Datos: 

Datos de recursos humanos con más de 22000 filas desde el año 2000 hasta 2020.

### Herramientas:

Limpieza y análisis de datos - MySQL Workbench
Visualización de datos - PowerBI

### Resumen de resultados:

- Hay más empleados hombres
- El empleado más joven tiene 20 años y el mayor 57 años.
- Se crearon 5 grupos de edad (18-24, 25-34, 35-44, 45-54, 55-64). Un gran número de empleados tenía entre 25 y 34 años, seguidos por entre 35 y 44, mientras que el grupo más pequeño tenía entre 55 y 64 años.
- Una gran cantidad de empleados trabajan en la sede en lugar de hacerlo de forma remota.
- La duración media del empleo de los empleados despedidos es de unos 7 años.
- La distribución de género entre departamentos está bastante equilibrada, pero en general hay más empleados hombres que mujeres.
- El departamento de Marketing tiene el mayor índice de rotación seguido de Formación. La menor tasa de rotación se da en los departamentos de Investigación y desarrollo, Soporte y Legal.
- Un gran número de empleados proceden del estado de Ohio.
- El cambio neto de empleados ha aumentado a lo largo de los años.
- La antigüedad promedio de cada departamento es de aproximadamente 8 años, siendo Legal y Auditoría la más alta y Servicios, Ventas y Marketing la más baja.

### Limitaciones:

Algunos registros tenían edades negativas y fueron excluidos durante la consulta (967 registros). Las edades utilizadas fueron 18 años y más.
Algunas fechas de término estaban muy lejanas en el futuro y no se incluyeron en el análisis (1599 registros). Los únicos términos utilizados fueron aquellos menores o iguales a la fecha actual.
