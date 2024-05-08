
SET SERVEROUTPUT ON; 

-- 1.
DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    FOR EMP IN (SELECT * FROM EMPLOYEE)
    LOOP
        IF EMP.BONUS IS NOT NULL THEN 
            SAL := NVL((EMP.SALARY + EMP.SALARY * EMP.BONUS) * 12, 0);
        ELSE 
            SAL := NVL(EMP.SALARY * 12, 0); 
        END IF; 
        
        DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || ' 사원의 연봉은 ' || SAL);

    END LOOP;
END; 
/ 

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
        INTO EMP
    FROM EMPLOYEE    
    WHERE EMP_ID = &사번;
     
   
    IF EMP.BONUS IS NOT NULL THEN 
        SAL := NVL((EMP.SALARY + EMP.SALARY * EMP.BONUS) * 12, 0);
    ELSE 
        SAL := NVL(EMP.SALARY * 12, 0); 
    END IF; 
        
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || ' 사원의 연봉은 ' || SAL);
END; 
/ 

-- 2. FOR LOOP 
BEGIN 
    FOR DAN IN 2..9
    LOOP
        FOR NUM IN 1..9 
        LOOP
            IF MOD(DAN, 2) = 0 THEN
               DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || NUM || ' = ' || (DAN * NUM));
            END IF;
        END LOOP; 
    END LOOP;
END;
/
-- 2. WHILE LOOP 
DECLARE 
    DAN NUMBER := 2;
    NUM NUMBER := 1; 
BEGIN 
    WHILE DAN <10
    LOOP
        WHILE NUM < 10
        LOOP
            IF MOD(DAN, 2) = 0 THEN 
            DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || NUM || ' = ' || (DAN * NUM));
            END IF;
            NUM := NUM + 1; 
        END LOOP;
    DAN := DAN+1;
    NUM := 1;
    
    END LOOP;
END;
/

