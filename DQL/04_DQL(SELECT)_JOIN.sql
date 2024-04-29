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
            오라클 전용 구문           |       ANSI구문(오라클 + 기타 DBMS) 
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
    연결시키고자하는 칼럼의 길이 "일치하는 행들만" 조인되서 조회. (일치하지 않는 행들은 결과값에서 제외) 
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


-- 전체사원들의 사번, 사원명, 직급코드, 직급명 
SELECT EMP_ID, EMP_NAME, JOB_CODE "직급코드", JOB_NAME "직급명" 
FROM EMPLOYEE , JOB  
WHERE JOB_CODE = JOB_CODE;
-- "column ambiguously defined" : 컬럼명이 애매한 에러. 어떤 테이블의 칼럼인지 명확하게 정의해줘야함.

--> ANSI 구문 
-- FROM 절에 기준 테이블을 "하나" 기술 
-- 그 뒤에 JOIN 절을 만든후 함께 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 함께 기술.
-- 조건? ON / USING으로 생성. 

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
