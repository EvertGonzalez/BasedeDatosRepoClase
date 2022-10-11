-- EJERCICIO NUMERO 1
DECLARE
    CURSOR cur_emps IS
    SELECT EMP.SALARY as SALARY, EMP.FIRST_NAME ||' ' || EMP.LAST_NAME as NAMEFULL FROM employees EMP;
BEGIN
    FOR v_emp_record IN cur_emps LOOP
       -- EXIT WHEN cur_emps%ROWCOUNT > 5;
        IF v_emp_record.NAMEFULL = 'Peter Tucker'  THEN

            raise_application_error(-20000, 'no se puede ver el sueldo del jefe');
            
        else
            
            DBMS_OUTPUT.PUT_LINE(v_emp_record.SALARY || ' ' || v_emp_record.NAMEFULL);
        END IF;
        
    END LOOP;
END;



-- EJERCICIO NUMERO 2
--Crear un cursor con parámetros para el parametro id de departamento e  imprima el numero de empleados de ese departamento (utilice la claúsula count)
DECLARE
    CURSOR cur_homeWork (p_department_id NUMBER) IS
    SELECT count(emp.FIRST_NAME) as CANTIDAD FROM Departments DP inner join employees emp on emp.DEPARTMENT_ID = DP.DEPARTMENT_ID where DP.DEPARTMENT_ID = p_department_id;
BEGIN
    FOR v_emp_record IN cur_homeWork(80) LOOP
       -- EXIT WHEN cur_emps%ROWCOUNT > 5;
        /*IF v_emp_record.NAMEFULL = 'Peter Tucker'  THEN

            raise_application_error(-20000, 'no se puede ver el sueldo del jefe');
            
        else
            
            DBMS_OUTPUT.PUT_LINE(v_emp_record.DEPARTMENT_NAME || ' ' || v_emp_record.DEPARTMENT_ID);
        END IF;*/
        DBMS_OUTPUT.PUT_LINE(v_emp_record.CANTIDAD || ' Empleados' );
        
    END LOOP;
END;

-- EJERCICIO NUMERO 3
--Crear un bloque que tenga un cursor de la tabla employees. i. Por cada fila recuperada, si el salario es mayor de 8000  incrementamos el salario un 2% 
--ii. Si es menor de 8000 incrementamos en un 3%
DECLARE
    CURSOR cur_homeWork  IS
    SELECT emp.SALARY, emp.FIRST_NAME ||' '|| emp.LAST_NAME as FULLNAME FROM  employees emp;
BEGIN
    FOR v_emp_record IN cur_homeWork LOOP
      IF(v_emp_record.SALARY>8000) THEN
           DBMS_OUTPUT.PUT_LINE(v_emp_record.SALARY || ' ' || v_emp_record.FULLNAME || ' SALARIO AUMENTADO: ' || (v_emp_record.SALARY +(v_emp_record.SALARY * 0.02)));
      END IF;
      IF(v_emp_record.SALARY<8000) THEN
           DBMS_OUTPUT.PUT_LINE(v_emp_record.SALARY || ' ' || v_emp_record.FULLNAME || ' SALARIO AUMENTADO: ' || (v_emp_record.SALARY +(v_emp_record.SALARY * 0.03)));
      END IF;
        --DBMS_OUTPUT.PUT_LINE(v_emp_record.SALARY || ' ' || v_emp_record.FULLNAME );
        
    END LOOP;
END;



--------------------------------- FUNCIONES---------------------------------
/*
a. Crear una función llamada CREAR_REGION
• A la función se le debe pasar como parámetro un nombre de región y
debe devolver un número, que es el código de región que calculamos
dentro de la función.
• Se debe crear una nueva fila con el nombre de esa REGION
• El código de la región se debe calcular de forma automática. Para ello se
debe averiguar cual es el código de región más alto que tenemos en la
tabla en ese momento, le sumamos 1 y el resultado lo ponemos como el
código para la nueva región que estamos creando
• Debemos controlar los errores en caso que se genere un problema
• La función debe devolver el número/ código que ha asignado a la
región.
• En el script debe colocar la funcion y el bloque para llamar la función


*/

SELECT * FROM regions rgns;

CREATE OR REPLACE FUNCTION CREAR_REGION(P_NOMBRE IN VARCHAR2)
      RETURN NUMBER
      
   AS
   V_IDSALIDA REGIONS.REGION_ID%type;
   RESTRICCION_NULL EXCEPTION;--DECLARA UNA EXCEPCION PARA VALIADAR NULOS
   BEGIN
      IF P_NOMBRE IS NULL THEN RAISE RESTRICCION_NULL; END IF; --VALIDA CAMPOS NULOS, ACTIVA EXCEPCION
        SELECT MAX(rgns.REGION_ID) +1 as maximoValor INTO V_IDSALIDA  FROM regions rgns;
        INSERT INTO regions VALUES   
        ( V_IDSALIDA  
        , P_NOMBRE   
        ); 
        RETURN  V_IDSALIDA;
        EXCEPTION
        WHEN RESTRICCION_NULL THEN
            DBMS_OUTPUT.PUT_LINE('DEBE INTRODUCIR UN VALOR');

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO'||SQLCODE||' -ERROR- '||SQLERRM);
      --RETURN  0;
   
   END;
/
DECLARE
  V_Salida varchar2(50);
BEGIN
     V_Salida := CREAR_REGION (P_NOMBRE => 'AMERICA CENTRAL');
     DBMS_OUTPUT.PUT_LINE('El Id Generado es:'||V_Salida);
     EXCEPTION
        WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERRO'||SQLCODE||' -ERROR- '||SQLERRM);
END;
   





---------------------------- FIN FUNCIONES -------------------------------------


--************************* PROCEDIMIENTOS INICIO****************************---

/*a. Construya un procedimiento almacenado que haga las operaciones de una
calculadora, por lo que debe recibir tres parametros de entrada, uno que
contenga la operación a realizar (SUMA, RESTA, MULTIPLICACION,
DIVISION), num1, num2 y declare un parametro de retorno e imprima el
resultado de la operación. Maneje posibles excepciones.
b. Realice una copia de la tabla employee, utilice el siguiente script:
Rellene la tabla employees_copia utilizando un procedimiento almacenado,
el cual no recibirá parametros unicamente ejecutara los inserts en la nueva
tabla, imprima el codigo de error en caso de que ocurra y muestre un
mensaje por pantalla que diga “Carga Finalizada”.
*/

CREATE OR REPLACE PROCEDURE CALCULADORA(P_NUM1 IN NUMBER,
                         P_NUM2 IN NUMBER,
                         P_OPERACION IN VARCHAR2,
                         RESULTADO  OUT VARCHAR2)
                         AS
                         
               
RESTRICCION_NULL EXCEPTION;--DECLARA UNA EXCEPCION PARA VALIADAR NULOS
BEGIN
    IF P_NUM1 IS NULL OR P_NUM2 IS NULL OR P_OPERACION IS NULL THEN RAISE RESTRICCION_NULL; END IF; --VALIDA CAMPOS NULOS, ACTIVA EXCEPCION
        IF(P_OPERACION = '+') THEN
            RESULTADO:= P_NUM1+P_NUM2;
        END IF;
         IF(P_OPERACION = '-') THEN
            RESULTADO:= P_NUM1-P_NUM2;
        END IF;
         IF(P_OPERACION = '*') THEN
            RESULTADO:= P_NUM1*P_NUM2;
        END IF;
         IF(P_OPERACION = '/') THEN
            RESULTADO:= P_NUM1/P_NUM2;
        END IF;
        
    EXCEPTION
        WHEN RESTRICCION_NULL THEN
            DBMS_OUTPUT.PUT_LINE('NO SE PERMITEN VALORES NULOS');
                       
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO'||SQLCODE||' -ERROR- '||SQLERRM);


END;



--************************ PROCEDIMIENTOS FINAL ******************************--/

DECLARE
  V_Numero1 number;
  V_Numero2 number;
  V_Operador varchar2(10);
  V_Salida varchar2(50);
BEGIN
V_Numero1:=10;
V_Numero2:=5;
V_Operador:='+';
     CALCULADORA (P_NUM1 => V_Numero1,P_NUM2 => V_Numero2,P_OPERACION => V_Operador,RESULTADO => V_Salida);
     DBMS_OUTPUT.PUT_LINE('El Resultado es :'||V_Salida);
     EXCEPTION
        WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR EN EL BLOQUE'||SQLCODE||' -ERROR- '||SQLERRM);
END;



CREATE OR REPLACE PROCEDURE CLONACION_TABLAS(RESULTADO  OUT VARCHAR2)
                         AS
                         
               
BEGIN
        INSERT INTO EMPLOYEES_COPIA 
        SELECT * FROM EMPLOYEES;
        RESULTADO:='CARGA FINALIZADA';
    EXCEPTION
                          
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO'||SQLCODE||' -ERROR- '||SQLERRM);


END;


DECLARE
   V_Salida varchar2(50);
BEGIN
     CLONACION_TABLAS (RESULTADO => V_Salida);
     DBMS_OUTPUT.PUT_LINE('El Resultado es :'||V_Salida);
     EXCEPTION
        WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR EN EL BLOQUE'||SQLCODE||' -ERROR- '||SQLERRM);
END;

SELECT * FROM EMPLOYEES_COPIA;

CREATE TABLE
EMPLOYEES_COPIA
 (EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY,
FIRST_NAME VARCHAR2(20 BYTE),
LAST_NAME VARCHAR2(25 BYTE),
EMAIL VARCHAR2(25 BYTE),
PHONE_NUMBER VARCHAR2(20 BYTE),
HIRE_DATE DATE,
JOB_ID VARCHAR2(10 BYTE),
SALARY NUMBER(8,2),
COMMISSION_PCT NUMBER(2,2),
MANAGER_ID NUMBER(6,0),
DEPARTMENT_ID NUMBER(4,0)
 );