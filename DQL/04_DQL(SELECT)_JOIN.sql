/*
    <JOIN>
    
    두개 이상의 테이블에서 데이터를 함께 조회하고자 할때 사용되는 구문
    조회결과는 하나의 결과물(RESULT SET)로 나옴. 
    
    JOIN을 해야하는 이유? 
    관계형 데이터베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있음.
    사원정보는 사원테이블에, 직급정보는 직급테이블, 부서정보는 부서테이블
    => 즉, JOIN구문을 이용해서 여러개 테이블간의 "관계"를 이용하여 함께 조회해야함.
    => 단, 무작정 JOIN을 하는게 아니고 테이블과 테이블간의 "연관관계" 가 있는 칼럼을 통해 JOIN 해야함.
    
    문법상 분류 : JOIN은 크게 "오라클 전용구문"과 ANSI(미국 국립 표준 협회) 구문으로 나뉘어짐 
    
    개념상 분류 :
            오라클 전용 구문               |       ANSI구문(오라클 + 기타 DBMS) 
        ----------------------------------------------------------------------------
            등가조인(EQUAL JOIN)          |      내부조인(INNER JOIN) -> JOIN USING/ON
            포괄조인                      |      외부조인(OUTER JOIN) -> JOIN USING/ON
            (LEFT OUTER JOIN)           |       왼쪽 외부조인(LEFT OUTER JOIN)
            (RIGHT OUTER JOIN)          |       오른쪽 외부조인(RIGHT OUTER JOIN)
                                                전체 외부 조인(FULL OUTER JOIN)
        ----------------------------------------------------------------------------
        카테시안의 곱(CARTESIAN PRODUCT)   |       교차조인(CROSS JOIN)
        ----------------------------------------------------------------------------
                                    자체조인(SELF JOIN)
                                    비등가 조인(NON EQUALJOIN)
                                    다중조인(테이블 3개이상 조인) 
        
    
*/

/*
    1. 등가 조인 (EQUAL JOIN) / 내부조인(INNER JOIN)
    연결시키고자하는 칼럼의 값이 "일치하는 행들만" 조인되서 조회. (일치하지 않는 행들은 결과값에서 제외) 
    => 동등비교 연산자를 사용 (=)
    
    [표현법] 
    오라클 등가조인
    SELECT 조회하고자하는 칼럼명들 
    FROM 조인하고자하는 테이블명들
    WHERE 연결할 컬럼에 대한 조건을 제시 
    
    내부조인[ANSI 구문]
    SELECT 조회하고자하는 칼럼명들 
    FROM 기준으로 삼을 테이블명 1개
    JOIN 연결할 테이블명 1개 제시 [ON/USING] [연결할 칼럼에 대한 조건을 제시 / 연결할 칼럼명 1개만 제시]
    
    
*/

--> 오라클 전용 구문 
-- FROM 절에 조회하고자하는 테이블들을 나열? (,로 나열)
-- 연결할 칼럼? 연관관계에 있는 칼럼들. 

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID; 
-- EMPLOYEE 테이블의 DEPT_CODE
-- DEPARTMENT 테이블의 DEPT_ID가 동일하다면 조회. 
-- 일치 하지 않는 값들을 조회되지 않음.
-- (NULL, D3, D4, D7 행은 조회결과에서 제외)

--> ANSI 구문 
-- FROM 절에 기준 테이블을 "하나" 기술 
-- 그 뒤에 JOIN 절을 만든후 함께 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 함께 기술.
-- 조건? ON / USING으로 생성. 

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


-- 전체사원들의 사번, 사원명, 직급코드, 직급명 
SELECT EMP_ID, EMP_NAME, JOB_CODE "직급코드", JOB_NAME "직급명" 
FROM EMPLOYEE , JOB  
WHERE JOB_CODE = JOB_CODE;
-- "column ambiguously defined" : 컬럼명이 애매한 에러. 어떤 테이블의 칼럼인지 명확하게 정의해줘야함.

SELECT EMP_ID, EMP_NAME, J.JOB_CODE "직급코드", J.JOB_NAME "직급명" 
FROM EMPLOYEE E 
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
-- 별칭을 통해 각 칼럼이 어느 테이블에 속한 칼럼인지 구분

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE); -- ON J.JOB_CODE = E.JOB_CODE을 간단하게 기술하기 위하여 사용.

-- 자연조인(NATURAL JOIN) : 등가조인 중 하나 
-- => 동일한 타입과, 이름을 가진 두 테이블의 칼럼을 자동으로 조인조건으로 지정해주는 조인문
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 조인시 추가적인 조건을 제시하기.

-- WHERE 조건절로 JOB_NAME이 ‘대리’ 인것을 찾도록 한다.
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE
JOIN JOB J ON (EMPLOYEE.JOB_CODE = J.JOB_CODE)
WHERE JOB_NAME = '대리'; 

--------------------------------------------------
--1. 부서가 '인사관리부' 인 사원들의 사번, 사원명, 보너스를 조회 

--> 오라클 전용구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE
    DEPT_CODE = DEPT_ID 
    AND DEPT_TITLE = '인사관리부';

--> ANSI 구문 
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부'; 

--2. 부서가 '총무부'가 아닌 사원들의 사원명, 급여, 입사일 조회 

--> 오라클 전용구문
SELECT EMP_NAME, SALARY, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_TITLE != '총무부' AND DEPT_CODE = DEPT_ID;

--> ANSI 구문 
SELECT EMP_NAME, SALARY, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부';

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명을 조회 

--> 오라클 전용구문
SELECT EMP_ID , EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE BONUS IS NOT NULL AND DEPT_CODE = DEPT_ID;

--> ANSI 구문 
SELECT EMP_ID , EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 4. 아래의 두 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명(LOCAL_NAME) 조회하기
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION; 

--> 오라클 전용구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID ,LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE DEPARTMENT.LOCATION_ID = LOCATION.LOCAL_CODE;


--> ANSI 구문 
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT D 
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
-- 등가조인/내부조인 : 일치하지 않는 행들은 제외하고 조회처리함.
-----------------------------------------------------

/*
    2. 포괄조인 / 외부조인
    
    테이블간의 JOIN시에 "일치하지 않는 행도" 포함시켜서 조회 가능 
    단 반드시 LEFT/RIGHT를 지정해줘야한다. => 어떤 테이블 기준으로 (왼/오른쪽) 일치하지 않는 행을 포함할것이냐를 물어보는것
    
    일치하는행 + 기준이되는 테이블의 일치하지 않는 행도 포함시켜서 조회해줌. 
    
*/

-- 전체 사원들의 사원명, 급여, 부서명 
-- 1) LEFT OUTER JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
--                       즉, 왼편에 기술된 테이블의 데이터는 일치하지 않는 행도 항상 포함시켜서 조회해줌. 

-- ANSI 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;


-- 오라클 전용 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM  EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); 
-- 기준으로 삼을 테이블의 칼럼명이 아닌 반대 테이블에 컬렴멍에 (+)를 붙여준다.


-- 2) RIGHT OUTER JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
--                       오른편에 기술된 테이블의 데이터는 무조건 조회되게 한다.

-- ANSI 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 오라클 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID; 


-- 3) FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회 
-- 일치하는 행 + 왼쪽기준 일치하지 않는 행 + 오른쪽 기준 일치하지 않는 행들

-- ANSI 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 오라클 전용 구문은 사용불가 
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

/*
    
    3. 카테시안의 곱(CARTESIAN PRODUCT) / 교차조인(CROSS JOIN)
    
    모든 테이블의 각 행들이 서로서로 매핑된 데이터가 조회됨. (곱집합) 
    두 테이블의 행들이 모두 곱해진 행들의 조합 출력.

    => 각 테이블의 행의 갯수가 N, M개일때, 카테시안의 곱의 결과는 N * M 행 
    => 모든 경우의 수를 다 따져서 조회할때 사용
    => 방대한 데이터가 출력되므로 과부하 발생할 수 있다. 
*/

-- 사원명, 부서명
-- 오라클구문 
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;

-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; 


/*
    
    4. 비등가 조인(NON EQUAL JOIN)
    '='를 사용하지 않는 조인문 => 다른 비교연산자를 써서 조인( >, < , BETWEEN A AND B)...
    => 지정한 칼럼값들이 일치하는 경우가 아니라 "범위" 에 포함되는 경우를 조건식으로 제시할때 사용한다.

*/

-- 사원명, 급여, 급여등급(SAL_LEVEL) 
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
-- WHERE EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL; 
-- WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ANSI 
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);


/*
    5. 자체조인 (SELF JOIN)
    
    - 같은 테이블끼리의 조인 A JOIN A 
    - 자체 조인의 경우 각 테이블에 반드시 "별칭"을 붙여줘야함.
    
    언제? 
    - 연속적인 데이터구조를 다룰때 혹은 계층적인 구조의 데이터를 다룰때 사용. 
    
    연속적인 데이터 ? 
    게시판 데이터에서 현재글, 이전글, 다음글 정보등을 조회할 때 사용.
    
    계층적인 데이터 ? 
    부장 - 팀장 - 과장 - 대리 - 사원등 계급(계층) 이 나눠져 있는 데이터 
    1개의 상위요소는 N개의 하위요소를 포함하고 있음. 
    
    계층형 구조의 데이터 관리방법 
    
    1) 하나의 테이블에서 관리
        - 하나의 테이블에서 상위요소값과 하위요소값을 하나의 컬럼으로 저장시킨다. (EMPLOYEE테이블에서 MANAGER_ID) 
        - 조직도를 관리시, 댓글정보, 카테조리저장 및 관리시 많이 사용되는 데이터 관리기법 
    
    2) 계층형 데이터 분할관리 
        - 상위요소만 존재하는 테이블, 하위요소만 존재하는 테이블을 별도로 만들어서 각 테이블로 분할시켜놓은 구조 
        - 데이터 중복을 줄이고, 유연하게 설계가 가능.
        - 계층구조 적을때 사용.

*/

-- 각 사원의 사번, 사원명, 사수사번, 사수명 
--> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E, EMPLOYEE M 
WHERE E.MANAGER_ID = M.EMP_ID;

--> ANSI 구문 
SELECT E.EMP_ID 사번,
      E.EMP_NAME 사원명,
      E.MANAGER_ID 사수사번,
      M.EMP_NAME 사수명
FROM EMPLOYEE E 
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);
-------------------------------------------------------------
-----실습문제용 스크립트 ------
CREATE TABLE PARENTCATEGORY (
    PARENT_CATEGORY_ID INT PRIMARY KEY,
    PARENT_CATEGORY_NAME VARCHAR(100) NOT NULL
);

CREATE TABLE CHILDCATEGORY (
    CHILD_CATEGORY_ID INT PRIMARY KEY,
    CHILD_CATEGORY_NAME VARCHAR(100) NOT NULL,
    PARENT_CATEGORY_ID INT,
    FOREIGN KEY (PARENT_CATEGORY_ID) REFERENCES PARENTCATEGORY(PARENT_CATEGORY_ID)
);
-- 부모 카테고리 데이터 추가
INSERT INTO PARENTCATEGORY (PARENT_CATEGORY_ID, PARENT_CATEGORY_NAME) VALUES (1, '전자제품');
INSERT INTO PARENTCATEGORY (PARENT_CATEGORY_ID, PARENT_CATEGORY_NAME) VALUES (2, '의류');
INSERT INTO PARENTCATEGORY (PARENT_CATEGORY_ID, PARENT_CATEGORY_NAME) VALUES (3, '책');

-- 자식 카테고리 데이터 추가
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (101, '스마트폰', 1);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (102, '노트북', 1);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (103, '태블릿', 1);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (104, '데스크탑', 1);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (105, '냉장고', 1);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (106, '세탁기', 1);

INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (107, '티셔츠', 2);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (108, '청바지', 2);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (109, '외투', 2);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (110, '정장', 2);

INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (111, '소설', 3);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (112, '논술', 3);
INSERT INTO CHILDCATEGORY (CHILD_CATEGORY_ID, CHILD_CATEGORY_NAME, PARENT_CATEGORY_ID) VALUES (113, '코믹', 3);

COMMIT;
---------------------------------------------------------------------------------------------------------------

-- 부모 카테고리와 자식 카테고리의 카테고리 아이디와 상품명
SELECT pc.PARENT_CATEGORY_ID,
       pc.PARENT_CATEGORY_NAME,
       cc.CHILD_CATEGORY_ID,
       cc.CHILD_CATEGORY_NAME
FROM PARENTCATEGORY pc 
JOIN CHILDCATEGORY cc ON pc.PARENT_CATEGORY_ID = cc.PARENT_CATEGORY_ID;


/*
    <START WITH ~ CONNECT BY ~ ORDER SIBLINGS BY> 
    
    - 계층형 구조데이터를 쉽고 깔끔하게 조회할 수 있도록 오라클에서 지원하는 문법. 
    - SELF JOIN보다 쉽게 데이터를 조회해 올 수 있음. (별칭부여나, JOIN문이 필요없음) 
    
    [표현법]
    5. SELECT 칼럼...
    1. FROM 계층형데이터모델
    4. WHERE 조건식
    2. START WITH 조건 
    3. CONNECT BY PRIOR 상위칼럼 = 하위칼럼
    6. [ORDER SIBLINGS BY 정렬기준]
    
    START WITH ? 시작조건 (상위요소로 사용할 행을 지정) 
    CONNECT BY PRIOR 상위칼럼 = 하위칼럼? 상위타입과 하위타입의 관계를 규정 조건식을 기술
    [ORDER SIBLINGS BY 정렬기준] -> START WITH 구문에서만 사용가능하며, 계층구조를 정렬시 사용
    SIBLINGS => SIBLINGS(형제, 자매). 즉 같은 형제(계층)간의 정렬을 의미함.
*/

-- 1) 계층형데이터모델에서 계층형 쿼리문 사용하기 
SELECT LEVEL,EMP_ID, EMP_NAME, MANAGER_ID -- LEVEL? START WITH 구문에서 사용할수 있는 칼럼. 계층의 레벨을 표시해줌
FROM EMPLOYEE
START WITH EMP_ID = 200
CONNECT BY PRIOR EMP_ID = MANAGER_ID
ORDER SIBLINGS BY EMP_ID DESC; -- 계층구조 정렬

-- 2) 계층형 데이터 분할 모델에서 계층형 쿼리문 사용하기 
SELECT 
    pc.PARENT_CATEGORY_ID,
    PARENT_CATEGORY_NAME,
    CHILD_CATEGORY_NAME
FROM PARENTCATEGORY pc
LEFT JOIN CHILDCATEGORY cc  ON pc.PARENT_CATEGORY_ID = cc.PARENT_CATEGORY_ID;


/*
    <다중 JOIN> 
    
    3개 이상의 테이블을 조인 => 조인 순서가 중요 
    
*/

-- 사번, 사원명, 부서명, 직급명
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE;

-->> ANSI 구문
SELECT EMP_ID,
       EMP_NAME,
       DEPT_TITLE,
       JOB_NAME
FROM EMPLOYEE E 
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING(JOB_CODE); 
    
    

