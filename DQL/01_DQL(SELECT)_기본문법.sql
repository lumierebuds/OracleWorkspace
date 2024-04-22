
-- DQL(DATA QUERY LANGUAGE) : 데이터를 조작할때 사용하는 문법들. 

/*
    <SELECT>
    데이터를 조회하거나 검색할때 사용하는 명령어 
    
    - RESULT SET : SELECT 구문을 통해 조회된 데이터의 결과물을 의미함.
                   조회된 행들의 집합
    (표현법) 
    SELECT 조회하고자하는 컬럼명1, 컬럼명2, ...
    FROM 테이블명; 
    
*/

--SELECT EMP_ID, EMP_NAME, EMP_NO
--FROM EMPLOYEE;


select emp_id, emp_name, emp_no
from employee;
-- 명령어, 키워드, 칼럼명, 테이블명은 대소문자로 써도 무방.
-- 단, 관례상 대문자로 쓰는것을 권장함.

-- employee 테이블에 모든 사원의 모든 컬럼 정보를 조회 

SELECT * FROM EMPLOYEE;

-- 실습문제 ---

-- 1. JOB 테이블의 모든 컬럼 조회
SELECT * FROM JOB; 

-- 2. JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

-- 3. DEPARTMENT 테이블의 모든 컬럼 조회 
SELECT * FROM DEPARTMENT;

-- 4. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
SELECT EMP_NAME, EMAIL,PHONE, HIRE_DATE FROM EMPLOYEE;

-- 5. EMPLOYEE 테이블의 입사일, 직원명, 급여 컬럼만 조회
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;


/*
    <컬럼 값에 산술연산>
    조회하고자 하는 컬럼들을 나열하는 SELECT 절에 산술연산을 기술해서 결과를 조회할 수 있다.
    
    
*/

-- EMPLOYEE 테이블로부터 직원명, 월급, 연봉 == (월급 * 12) 
SELECT EMP_NAME, SALARY, SALARY * 12 
FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 직원명, 월급, 보너스, 보너스가 포함된 연봉(월급+ 월급 * 보너스) * 12
SELECT EMP_NAME, SALARY, BONUS, (SALARY + SALARY * BONUS) * 12 
FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(퇴사일(오늘날짜) - 입사일) 조회 
-- DATE 타입끼리 산술연산 가능. (DATE => 년, 월, 일, 시, 분, 초)
-- 오늘날짜 : SYSDATE 
-- 시, 분, 초단위로 연산을 수행한 후 "일"을 반환해주기 때문에 소숫점이 더럽다. 
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

/*
    <컬럼명에 별칭 부여하기> 
    [표현법] 
    컬럼명 AS 별칭, 컬럼명 AS "별칭", 컬럼명 "별칭", 컬럼명 별칭 
    (AS가 없어도 된다.) 
*/ 

SELECT EMP_NAME AS 사원명, HIRE_DATE "입사일", SYSDATE - HIRE_DATE AS "근무일수",
(SALARY + SALARY * BONUS) * 12 "보너스가 포함된 연봉" /*DBMS는 공백문자가 존재하면 쌍따옴표로 추가해준다.*/
FROM EMPLOYEE;


/*
    <리터럴>
    임의로 지정한 문자열('')을 SELECT절에 기술하면
    실제 테이블에 존재하는 것처럼 데이터 조회가 가능하다.
  
*/
-- EMPLOYEE 테이블로부터 사번, 사원명, 급여, 급여단위(원)을 조회 
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "급여단위(원)" 
FROM EMPLOYEE;


/*
    <DISTINCT> 
    조회하고자 하는 컬럼에 중복된 값을 딱 한번만 조회하고자 할때 사용.
    컬럼명 앞에 기술
    
    [표현법] 
    DISTINCT 컬럼명 
*/

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- DEPT_CODE와 JOB_CODE를 묶어서 중복값을 판단.
SELECT DISTINCT DEPT_CODE, JOB_CODE 
FROM EMPLOYEE;


/*
    <WHERE>
    조회하고자 하는 테이블에 특정 조건을 제시해서, 그 조건에 만족하는 
    데이터들만 조회하고자 할때 기술하는 구문. 
    
    [표현법] 
    SELECT 칼럼명들.. 
    FROM 테이블명 
    WHERE 조건식; => 조건에 해당하는 행들을 뽑아내겠다. 
    
    쿼리문 실행순서 
    FROM -> WHERE -> SELECT 
    
    -- 조건식에는 다양한 연산자들 사용가능.
    동등비교연산자
    자바? == || !=
    오라클 ? = || !=, ^=, <> (일치하지 않는가?) 



*/

-- EMPLOYEE 테이블로부터 급여가 400만원 이상인 사람만 조회(모든 칼럼) 
SELECT * 
FROM EMPLOYEE
WHERE SALARY >= 4000000;


-- EMPLOYEE 테이블로부터 부서코드가 D9인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블로부터 부서코드가 D9가 아닌 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D9';
--WHERE DEPT_CODE ^= 'D9';
WHERE DEPT_CODE <> 'D9';

---- 실습문제 --- 

-- 1. EMPLOYEE 테이블에서 급여가 300만원 이상인 사원들의 이름, 급여, 입사일을 조회하시오.
SELECT EMP_NAME, SALARY, HIRE_DATE 
FROM EMPLOYEE
WHERE SALARY >= 3000000;


-- 2. EMPLOYEE 테이블에서 직급코드가 J2인 사원들의 이름, 급여, 보너스를 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE JOB_CODE = 'J2';


-- 3. EMPLOYEE 테이블에서 현재 재직중인 사원들의 사번, 이름, 입사일 조회 
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN = 'N';

-- 4. EMPLOYEE 테이블에서 연봉이(보너스미포함) 5000만원 이상인 사람들의 이름, 급여, 연봉, 입사일을 조회 
SELECT EMP_NAME , SALARY, SALARY * 12 AS "연봉" , HIRE_DATE 
FROM EMPLOYEE
--WHERE 연봉 >= 50000000; -- SELECT의 실행순서가 마지막이므로 조건식에서는 사용할 수 없는 값이다. 
WHERE SALARY * 12 >= 50000000; 

/*
    <논리 연산자> 
    여러 개의 조건을 엮을때 사용
    
    AND : 자바의 && 역할을 하는 연산자, ~~이면서, 그리고
    OR  : 자바의 || 역할을 하는 연산자. ~~이거나, 또는 
    
*/

-- EMPLOYEE 테이블에서 부서코드가 D9이면서 급여가 500만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;


-- EMPLOYEE 테이블에서 부서코드가 D6이거나 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- EMPLOYEE 테이블에서 급여가 350만원 이상이고, 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE
FROM EMPLOYEE
-- WHERE SALARY >=3500000 AND SALARY <= 6000000; 
WHERE SALARY BETWEEN 3500000 AND 6000000; 

/*  
    <BETWEEN AND> 
    몇 이상 몇 이하인 범위에 대한 조건을 제시할때 사용.
    
    [표현법] 
    비교대상 칼럼명 BETWEEN A AND B; -> A 이상 B 이하 
*/

-- 급여가 350만원 미만이거나 600만원 초과인 사람들의 이름, 사번, 급여
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 6000000; 
-- NOT 연산자로 350만원 이상, 600만원 초과인 결과가 아닐 수 있도록 조건을 준다.
-- 오라클의 NOT 은 자바의 논리부정연산자와 같은 역할을 한다. 

-- 입사일이 '90/01/01' ~ '03/01/01'인 사원들의 모든 컬럼 조회 
SELECT * 
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';
-- 그대로 리터럴 값을 제시하면 된다. 

-- 입사일이 '90/01/01' ~ '03/01/01'이 아닌 사원들의 모든 컬럼 조회 
SELECT * 
FROM EMPLOYEE
WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '03/01/01';
