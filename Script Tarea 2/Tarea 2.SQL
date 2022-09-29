DECLARE
   nombre varchar2(50);
   apellido1 varchar2(50);
   apellido2 varchar2(50);
   salidaBloque varchar2(100);
 BEGIN
 nombre:='evert';
 apellido1:='gonzalez';
 apellido2:='lopez';
   select UPPER(SUBSTR(nombre,1, 1))|| '.' ||  UPPER(SUBSTR(apellido1,1, 1))|| '.' ||UPPER(SUBSTR(apellido2,1, 1)) into salidaBloque from dual;
   DBMS_OUTPUT.PUT_LINE (salidaBloque);
END;


-- ejercicio 2

--Debemos hacer un bloque PL/SQL anónimo, donde declaramos una variable 
--NUMBER la variable puede tomar cualquier valor. Se debe evaluar el valor y 
--determinar si es PAR o IMPAR • Como pista, recuerda que hay una función en SQL denominada MOD, que 
-- permite averiguar el resto de una división. Por ejemplo MOD(10,4) nos 
--devuelve el resto de dividir 10 por 4.
--select MOD(10,2) from dual;
--SELECT TRUNC  (ABS(dbms_random.value(10, 20)))
--FROM dual;
DECLARE
   numero number;
   --salidaBloque varchar2(100);
 BEGIN
    
  SELECT MOD(TRUNC(ABS(dbms_random.value(0, 100))),2)  into numero FROM dual;
  
  if (numero=0) then
   DBMS_OUTPUT.PUT_LINE ('Numero Par');
   
  else
    DBMS_OUTPUT.PUT_LINE ('Numero Impar');
  end if;
   --DBMS_OUTPUT.PUT_LINE (numero);
END;

-- Ejercicio numero 3

--Crear un bloque PL/SQL que devuelva al salario máximo del departamento 100 y lo 
--deje en una variable denominada salario_maximo y la visualice


DECLARE
   salarioMaximo number;
   --salidaBloque varchar2(100);
 BEGIN
 
  select MAX(EP.SALARY) into salarioMaximo from  employees EP WHERE EP.DEPARTMENT_ID =100 ;
   DBMS_OUTPUT.PUT_LINE (salarioMaximo);
END;


--select * from DEPARTMENTS DP ;
--select * from JOBS JB;
--select * from employees EP;


--select MAX(EP.SALARY) from employees EP WHERE EP.DEPARTMENT_ID =100 ;

--select MAX(EP.SALARY) from employees EP INNER JOIN JOBS JB ON JB.JOB_ID = EP.JOB_ID  WHERE EP.DEPARTMENT_ID =100 

--Ejercicio numero 4
--Crear una variable de tipo DEPARTMENT_ID y ponerla algún valor, por ejemplo 10. 
--Visualizar el nombre de ese departamento y el número de empleados que tiene. 
--Crear dos variables para albergar los valores. 


DECLARE
   numeroDepartamento EMPLOYEES.EMPLOYEE_ID%TYPE;
   nombreDepartamento DEPARTMENTS.DEPARTMENT_NAME%TYPE;
   cantidadEmpleadoDepar number;
  BEGIN
  numeroDepartamento:=100;
  select DP.DEPARTMENT_NAME , count(DP.DEPARTMENT_NAME) valores  into nombreDepartamento  ,cantidadEmpleadoDepar from  employees EP INNER JOIN  DEPARTMENTS DP ON EP.DEPARTMENT_ID = DP.DEPARTMENT_ID WHERE EP.DEPARTMENT_ID =numeroDepartamento group by DP.DEPARTMENT_NAME;
   DBMS_OUTPUT.PUT_LINE (' Nombre del Departamento: '  ||nombreDepartamento ||', Cantidad de Empleados '  ||cantidadEmpleadoDepar );
END;


-- Ejercicio Numero 5

--Mediante dos consultas recuperar el salario máximo y el salario mínimo de la 
--empresa e indicar su diferencia

--select MAX(EP.SALARY) maximo, MIN(EP.SALARY) minimo from  employees EP ;
DECLARE
   salarioMaximo number;
   salarioMinimo number;
   diferencia number;
  -- salidaBloque varchar2(100);
 BEGIN
 
 -- select MAX(EP.SALARY) maximo, MIN(EP.SALARY) minimo into salarioMaximo,salarioMinimo from  employees EP ;
  --select MIN(EP.SALARY),salarioMaximo  into salarioMinimo from  employees EP ;
  
  select MAX(EP.SALARY)  into  salarioMaximo   from  employees EP ;
  select MIN(EP.SALARY)  into  salarioMinimo   from  employees EP ;
  diferencia:=salarioMaximo-salarioMinimo;
   DBMS_OUTPUT.PUT_LINE ('El Salario Maximo es: '||salarioMaximo||' El Salario Mnimo es: '||salarioMinimo|| ' La Diferencia es es: '||diferencia );
END;

 