/*
    <함수 FUNCTION> 
    자바로 따지면 메서드와 같은 존재
    매개변수로 전달된 값들을 읽어서 계산한 결과를 반환해줌.
    
    - 단일행 함수 : N개의 값을 읽어서 N개의 결과값을 리턴해주는 함수(매 행마다 실행되는 함수)
    - 그룹 함수 : N개의 값을 읽어서 1개의 결과를 리턴(하나의 그룹별로 함수 실행후 결과값 반환) 
    
    단일행 함수와 그룹 함수는 함께 사용할 수 없다. : 결과 행의 갯수가 다르기 때문. 
    
*/

-----------------<단일행 함수> ----------------------

/*

    가변길이 타입 VARCHAR2와 고정길이 타입 CHAR의 차이
    - 가변 길이 타입은 입력한 값만큼만 공간을 차지한다.
    - 고정 길이 타입은 값이 있든 없든 해당 크기만큼 공간을 차지한다. 
    
    <문자열과 관련된 함수>
    LENGTH / LENGTHB
    - LENGTH(문자열) : 문자열의 글자수 반환
    - LENGTHB(문자열) : 문자열의 바이트수 반환 
    
    한글: 3BYTE로 취급
    영문, 숫자, 특수문자 : 한글자당 1BYTE 
    
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
-- FROM EMPLOYEE;
FROM DUAL; 
-- 가상테이블(DUMMY TABLE) : 산술연산이나 가상칼럼등 값을 한번만 출력하고 싶을때 사용하는 테이블


-- 사원 이메일, 이메일 길이, 이메일의 바이트 수를 조회하기
SELECT EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
    INSTR 
    - INSTR(문자열, 특정 문자, 찾을 위치의 시작값, 순번): 문자열로부터 특정 문자의 위치값 반환.
    
    찾을위치의 시작값, 순번은 생략가능하며, 결과값은 NUMBER
    
    찾을위치의 시작값 : (1 / -1)
    1 : 앞에서부터
    -1 : 뒤에서부터 
    
*/

SELECT INSTR('AABAACAABBAA', 'B') -- 1 기본값
FROM DUAL; -- 3

SELECT INSTR('AABAACAABBAA', 'B', -1) -- 1기본값
FROM DUAL; -- 10

SELECT INSTR('AABAACAABBAA', 'B', -1, 2) -- 1기본값 
FROM DUAL; -- 9

SELECT INSTR('AABAACAABBAA', 'B', -1, 0) -- 1 기본값
FROM DUAL; -- 범위를 벗어난 순번을 제시했을경우 오류발생.

-- EMAIL 에서 @의 위치를 찾아보기 
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') "@의 위치"
FROM EMPLOYEE;

/*
    <SUBSTR>
    문자열로부터 특정 문자열을 추출하는 함수 
    
    - SUBSTR(문자열, 처음위치, 추출할문자 갯수) 
    
    결과값은 CHARACTER 타입으로 반환
    추출할문자 갯수는 생략가능(생략시에는 문자열 끝까지 추출)
    처음위치는 음수로 제시 가능: 뒤에서부터 N번째 위치에서 추출시작하겠다라는 뜻
    
*/

SELECT SUBSTR('SHOWMETHEMONEY',7) -- THEMONEY
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY',5,2) -- ME
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY',1, 6) -- SHOWME
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY', -1, 6) --Y 
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY',-8, 3) -- THE
FROM DUAL;


-- 주민등록 번호에서 성별부분만 추출해서 남자인지, 여자인지를 체크 
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) AS 성별
FROM EMPLOYEE;

-- 이메일에서 @이전 즉, ID값만 추출 
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) AS "EMAIL, ID"
FROM
EMPLOYEE;


-- 남자 사원들만, 여자사원들만 조회 
SELECT 
    EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN (1, 3); 
-- 주민번호 뒷자리 1, 3인 남자
-- SUBSTR의 반환은 문자형인데, IN 조건엔 정수로 비교하고 있다.
-- 이는, 자동형변환이 된것이기 때문에 가능한것이다.

/*
    <LPAD/RPAD>
    - LPAD/RPAD(문자열, 최종적으로 반환할 문자의 길이(BYTE), 덧붙이고자하는 문자) 
    : 문자열에 덧붙이고자하는 문자를 왼쪽 / 오른쪽에 덧붙여서 최종 N만큼의 문자열을 반환 
    
    결과값 CHARACTER반환
    덧붙이고자하는 문자는 생략가능 : 기본값 ' ' 

*/

SELECT LPAD(EMAIL, 16)
FROM EMPLOYEE;

SELECT RPAD(EMAIL, 16)
FROM EMPLOYEE;

-- 주민등록번호 조회 : 611211-198123 -> 611211-1*****
SELECT EMP_NAME, EMP_NO, RPAD(SUBSTR(EMP_NO, 1, 8) ,14 , '*') 
FROM EMPLOYEE;
-- 주민번호 뒷자리를 별(*)로 바꾸기 
-- SUBSTR(EMP_NO, 1, 8) : 주민번호 뒷자리 첫번째 자리까지 잘라준다. 
-- SUBSTR(EMP_NO, 1, 8) 반환된 문자열은 8자리이다, 이후 14 자리를 *로 채워준다.


/*
    LTRIM / RTRIM 
    - LTRIM / RTRIM(문자열, 제거시키고자하는 문자) 
    : 문자열에서 왼쪽 또는 오른쪽에서 제거시키고자하는 문자들을 찾아서 제거한 나머지 문자열을 반환 
    
    결과값은 CHRACTER 형태 
    제거시키고자하는 문자 생략가능, 기본값은 ' '

*/

SELECT LTRIM('       K      H       ') -- 왼쪽 공백을 제거한다.
FROM DUAL;

SELECT RTRIM('       K      H       ') -- 오른쪽 공백을 제거한다.
FROM DUAL;

SELECT RTRIM('0001230456000', '0') -- 001230456
FROM DUAL;

SELECT LTRIM('123KH123', '132')-- KH123
FROM DUAL;

/*
    <TRIM> 
    - TRIM(BOTH/LEADING/TRAILING '제거하고자하는문자' FROM '문자열')
    
    결과값은 CHARACTER 
    BOTH/LEADING/TRAILING은 생략가능. (기본값은 BOTH) 
*/

SELECT TRIM('       K    H      ')
FROM DUAL;

-- ZZZZZZZKHZZZZZZZ
SELECT TRIM('Z' FROM 'ZZZZZZZZZKHZZZZZZZZ')
FROM DUAL;

-- ZZZZZZZKHZZZZZZZ
SELECT TRIM(BOTH 'Z' FROM 'ZZZZZZZZZKHZZZZZZZZ') -- BOTH 옵션
FROM DUAL;

-- ZZZZZZZKHZZZZZZZ
SELECT TRIM(LEADING 'Z' FROM 'ZZZZZZZZZKHZZZZZZZZ') -- LEADING 옵션
FROM DUAL;

-- ZZZZZZZKHZZZZZZZ
SELECT TRIM(TRAILING 'Z' FROM 'ZZZZZZZZZKHZZZZZZZZ') -- LEADING 옵션
FROM DUAL;


/*
    LOWER/UPPER/INITCAP 
    
    - LOWER : 다 소문자
    - UPPER : 다 대문자
    - INITCAP : 각 단어의 앞글자만 대문자로 변경 

*/ 

SELECT LOWER('Welcome to C class') , UPPER('Welcome to C class'), INITCAP('welcome to C class')
FROM DUAL;

/*
    
    - CONCAT(문자열1, 문자열2) 
    : 전달받은 문자열 두개를 하나의 문자열로 합쳐서 반환 
    
    결과값은 문자열 
    
*/

SELECT CONCAT(CONCAT('가나다', '라마바'), '사')
FROM DUAL; -- 연결연산자를 통해 문자열 합치기 가능. 가독성은 || 연산자가 좋다.


/*
    REPLACE 
    
    - REPLACE(문자열, 찾을 문자, 바꿀 문자) 
    : 문자열로부터 찾을 문자를 찾아서 바꿀문자로 바꾼 문자열 반환
    찾을 문자자리에는 정규표현식 기술 가능. 
*/

SELECT REPLACE('서울시 강남구 역삼동 역삼', '역삼' , '삼성동')
FROM DUAL;  -- 문자열의 내용중 '역삼'이 나오면 '삼성동' 으로 치환한다.

-- EMPLOYEE 테이블에서 EMAIL 주소 kh.or.kr을 ioi.or.kr로 변경
SELECT REPLACE (EMAIL, 'kh.or.kr', 'ioi.or.kr')
FROM EMPLOYEE;

/*
    <숫자와 관련된 함수> 
    
    ABS 
    - ABS(절대값을 구할 숫자) : 절대값을 구해주는 함수 
    : NUMBER 
*/

SELECT ABS(-10), ABS(-10.9)
FROM DUAL;

/*
    
    ROUND 
    - ROUND(반올림하고자하는수, 반올림할 위치) : 반올림처리해주는 함수
    
    반올림할위치 : 소숫점 기준으로 아래 N번째수에서 반올림하겠다. (생략가능) 기본값은 0
    
*/

SELECT ROUND(123.456)
FROM DUAL; -- 123 

SELECT ROUND(123.456, 1)
FROM DUAL; -- 123.5

SELECT ROUND(123.456 , 2)
FROM DUAL; -- 123.46

SELECT ROUND(123.456, -1)
FROM DUAL; -- 120

SELECT ROUND(123.456, -2) 
FROM DUAL; -- 100


/*
    <CEIL / FLOOR>
    - CEIL(올림처리할숫자) : 소숫점아래의 수를 무조건 올림처리
    - FLOOR(버림처리할숫자) : 소숫점아래의 수를 무조건 버림처리

*/

SELECT CEIL(123.1111), FLOOR(123.999999999)
FROM DUAL;

-- 각 직원별로 근무일수 구하기(현재시간 - 근무날짜)

SELECT EMP_NAME, FLOOR(SYSDATE-HIRE_DATE) || '일' 근무일수 
FROM EMPLOYEE;


/*
    TRUNC 
    - TRUNC(버림처리할 숫자, 위치) : 위치지정이 가능한 버림처리 함수 
    
    위치값은 생력가능. 기본값이 0 
    
*/

SELECT TRUNC(123.786)
FROM DUAL; -- 123 == FLOOR 와 동일 

SELECT TRUNC(123.786, 1)
FROM DUAL; -- 123.7

SELECT TRUNC(123.786, 2)
FROM DUAL; -- 123.78

SELECT TRUNC(123.786, -1)
FROM DUAL; -- 120

/*
    <날짜 관련 함수> 
    
    DATE타입 : 년, 월, 일, 시, 분, 초를 다 가지고 있는 자료형
    
*/

SELECT SYSDATE FROM DUAL;

-- 1. MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월수 반환(결과값 NUMBER) 
-- DATE2가 과거여야한다, DATE2가 좀더 미래일경우 음수값 반환. 
-- 각 직원별 근무일수, 근무개월수 

SELECT 
    EMP_NAME,
    FLOOR(SYSDATE - HIRE_DATE) AS 근무일수,
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS 근무개월수 
FROM EMPLOYEE;

-- 2. ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 개월수를 더한 날짜를 반환
-- 오늘 날짜로부터 5개월 이후
SELECT ADD_MONTHS(SYSDATE, 5)
FROM DUAL;

-- 전체 사원들의 1년 근속일 (== 입사일 기준 1주년 되는날) 
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 12) 근속일
FROM EMPLOYEE; 

-- 3. NEXT_DAY(DATE, 요일(문자/숫자)): 특정날짜에서 가장 가까운 해당 요일을 찾아서 그 날짜를 반환.
SELECT NEXT_DAY(SYSDATE, '수')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '수요일')
FROM DUAL;

-- 일 월 화 수 목 금 토 
-- 1  2  3 4 5 6 7

-- 사용언어 변경하기 
ALTER SESSION SET NLS_LANGUAGE = AMERICAN; -- 미국으로 설정변경
ALTER SESSION SET NLS_LANGUAGE = KOREAN; -- 한국으로 설정변경

SELECT NEXT_DAY(SYSDATE, 'WED')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, 4)
FROM DUAL;

-- 4. LAST_DAY(DATE) : 해당 달의 마지막 날짜를 구해서 반환 
SELECT LAST_DAY(SYSDATE) 
FROM DUAL;

-- 5. EXTRACT : 추출하다. 년도, 월, 일정보를 추출해서 반환. 반환형이 NUMBER
--    EXTRACT(YEAR/MONTH/DAY FROM 날짜) : 날짜에서 년, 월, 일 정보를 추출한다.

SELECT 
    EXTRACT(YEAR FROM SYSDATE) AS 년도, 
    EXTRACT(MONTH FROM SYSDATE)AS 월,
    EXTRACT(DAY FROM SYSDATE) AS 일
FROM DUAL;


/*
    <형변환 함수> 
    NUMBER/DATE => CHARACTER 
    
    - TO_CHAR(NUMBER, 포맷)
    : 숫자형 또는 날짜형 데이터를 문자형 타입으로 반환
*/
-- 숫자를 문자열로 
SELECT TO_CHAR(1234)
FROM DUAL;

-- 숫자를 문자열로 반환하며 포맷을 지정해서 출력  
SELECT TO_CHAR(1234, '00000')
FROM DUAL; -- 빈칸을 0으로 채움

SELECT TO_CHAR(1234, '99999')
FROM DUAL; -- 빈칸을 ' ' 으로 채움

SELECT TO_CHAR(1234, 'L99,999')
FROM DUAL; 
-- 9 : 빈칸을 ' '으로 채움
-- L : LOCAL, 지역정보상의 화폐단위

SELECT TO_CHAR(1234, 'L0,000')
FROM DUAL;

-- 각 사원의 월급을 3자리마다 , 로 찍어서 확인
SELECT EMP_NAME,
    TO_CHAR(SALARY, 'L999,999,999,999') AS 급여 
FROM EMPLOYEE;

-- 날짜를 문자열로 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL; -- HH: 12시간 기준

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS')
FROM DUAL; -- HH24: 24시간 기준

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD PM HH24:MI:SS')
FROM DUAL; -- PM HH24 : 24시간 기준, 오후로 출력

SELECT TO_CHAR(SYSDATE, 'MON DY DAY')
FROM DUAL; 

-- 년도를 표시할때 사용하는 포맷
-- (YYYY, RRRR, YY, RR, YEAR) 
SELECT 
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE, 'YY'),
    TO_CHAR(SYSDATE, 'RR'),
    TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

/*
    
    -- YY와 RR의 차이점 
    -- R? (ROUND 반올림)
    -- YY : 앞자리에 20을 붙임
    -- RR : 50년을 기준으로 적으면 20, 크면 19가 붙음. => 89 -> 1989
*/

-- 월로 사용가능한 포맷 
SELECT 
    TO_CHAR(SYSDATE, 'MM'),
    TO_CHAR(SYSDATE, 'MON'),
    TO_CHAR(SYSDATE, 'MONTH'),
    TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

SELECT 
    TO_CHAR(SYSDATE, 'D'),
    TO_CHAR(SYSDATE, 'DD'),
    TO_CHAR(SYSDATE, 'DDD')
FROM DUAL;
-- D : 1주일기준 일요일부터 며칠째인지 알려주는 포맷.
-- DD : 1달기준 현재 요일
-- DDD : 1년기준으로 1월 1일부터 며칠째인지 알려주는 포맷 

-- 사원명, 입사일(YYYY년 MM월 DD일 (DY))로 출력 

SELECT 
    EMP_NAME,
    TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') "입사일"
FROM EMPLOYEE;
-- FORMAT 형식에서 문자열을 넣을때는 쌍따옴표로 감싸준다.

SELECT 
    EMP_NAME,
    TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') "입사일"
FROM EMPLOYEE
WHERE HIRE_DATE >= '2010/01/01';
-- WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010;
-- FORMAT 형식에서 문자열을 넣을때는 쌍따옴표로 감싸준다.

/*
    NUMBER / CHARACTER -> DATE 
    
    - TO_DATE(NUMBER/CHARACTER, '포맷') : 숫자 또는 문자형 데이터를 날짜로 변환 
*/

SELECT TO_DATE(20240426) -- 2024/04/26
FROM DUAL;

SELECT TO_DATE(000101) -- 숫자는 0으로 시작될 수 없어, 0을 다지우게 되어 오류가 발생한다.
FROM DUAL;

SELECT TO_DATE('000101') -- 0으로 시작하는 년도는 홀따옴표로 감싸주어야 한다. 
FROM DUAL;

SELECT TO_DATE('20240426', 'YYYYMMDD')
FROM DUAL;

SELECT TO_DATE('240426 103950', 'YYMMDD HHMISS') -- TO_DATE가 인식할 수 있게 포맷을 부여해줘야한다. 
FROM DUAL;

SELECT TO_DATE('140630','RRMMDD') -- 2014.06.30
FROM DUAL;

SELECT TO_DATE('990611','RRMMDD') -- 1999.06.11
FROM DUAL;

/*
    CHARACTER → NUMBER
    -TO_NUMBER(CHARACTER, 포맷) : 문자형 데이터를 숫자형으로 변환.
    
*/

SELECT '123'+'12345'
FROM DUAL; -- 자동형변환을 거친후 산술연산 수행

SELECT '10,000,000' + '550,000'
FROM DUAL; -- 정수안에 ,가 포함되어 있어 형변환 불가

-- 형변환 하여 더하기 
SELECT TO_NUMBER('10,000,000', '99,999,999') + TO_NUMBER('550,000', '999,999')
FROM DUAL;

SELECT TO_NUMBER('0123')
FROM DUAL;

-- 문자열(TO_CHAR), 숫자(TO_NUMBER), 날짜(TO_DATE) 형변환 함수들 끝 -- 

-- NULL 처리함수들 
-- NULL : 값이 존재하지 않다를 나타내는 값

-- 1. NVL(칼럼명, 해당 컬럼값이 NULL일경우 반환할 반환값) 

SELECT EMP_NAME, BONUS, NVL(BONUS, 0) 
FROM EMPLOYEE;

-- 보너스 포함된 연봉 구하기 
SELECT EMP_NAME, SALARY, NVL(BONUS, 0) 보너스, 
    (SALARY + SALARY * NVL(BONUS, 0)) * 12 "보너스 포함 연봉" 
FROM EMPLOYEE; -- 사용할 수있는 데이터는 한행의 데이터만 가능하여 '별칭'을 사용할 수 없다.


-- 2. NVL2(컬럼명, 결과값1, 결과값2) 

SELECT 
    EMP_NAME, BONUS, NVL2(BONUS, '보너스 있음', '보너스 없음') AS "보너스 유무"
FROM EMPLOYEE;
-- 자바의 삼항 연산자처럼, NULL일때, 아닐때의 반환값의 타입이 동일해야 한다. 
-- NVL2(BONUS, BONUS, '보너스 없음') -- 오류발생

-- 사원명, 부서코드, 부서코드가 없는경우 부서배치미완료, 부서코드가 있는 경우 부서배치완료값이 뜨도록 조회
SELECT
    EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE, '부서배치완료', '부서배치미완료') AS "부서배치 유무"
FROM EMPLOYEE;

-- 3. NULLIF(비교대상1, 비교대상2) : 동등비교
-- 두 값을 비교하여 동일할경우 NULL 반환
--               동일하지 않을경우 비교대상1 반환

SELECT NULLIF('123', '123')
FROM DUAL; -- 두값이 동일할경우 NULL값 반환

SELECT NULLIF('123', '456')
FROM DUAL; -- 두값이 다른경우 비교대상1 반환
 
SELECT NULLIF(EMP_NAME, '선동일')
FROM EMPLOYEE; -- 두값이 다른경우 비교대상1 반환


------------------------------NULL처리함수 끝 ------------------------------------
-- 선택함수 : DECODE -> SWITCH 문
-- 선택함수의 친구 : CASE WHEN THEN 구문 -> IF 문 

/*
    
    <선택함수>
    
    - DECODE(비교대상칼럼, 조건값1, 결과값1, 조건값2, 결과값2, ....., 기본결과값)
    
    - 자바에서 SWITCH 문과 유사 
    switch(비교대상칼럼) {
        case 조건값1 : 결과값1; break;
        case ...
        [default : 기본결과값;]
        }
    
    기본결과값은 생략시 null 처리된다.
    비교대상칼럼에는 컬럼명, 산술연산결과, 함수의 반환값이 들어갈 수 있음.

*/

-- 사번, 사원명, 주민번호, 성별(남자, 여자) 
SELECT EMP_ID,
        EMP_NAME,
        EMP_NO,
        DECODE(SUBSTR(EMP_NO, 8,1), '1', '남자','2','여자','3','남자', '4','여자', NULL) 성별 -- 앞자리 1이면 남자, 2면 여자 
FROM EMPLOYEE;

-- 직원들의 급여정보를 인상시켜서 조회
-- 직급코드가 J7인 경우 급여를 10% 인상하여 조회
-- 직급코드가 J6인 경우 15% 인상
-- 직급코드가 J5인 경우 20% 인상
-- 그외 직급은 5%인상하여 조회 
-- 사원명, 직급코드, 변경전 급여, 변경후 급여 

SELECT EMP_NAME, JOB_CODE ,SALARY "변경전 급여",DECODE(JOB_CODE, 
                    'J7', SALARY * 1.1 , 
                    'J6' , SALARY * 1.15, 
                    'J5', SALARY * 1.2, 
                    SALARY * 1.05) AS "변경 후 급여"
FROM EMPLOYEE;



/*
    <CASE WHEN THEN 구문 >
    - DECODE 선택함수와 비교하면 DECODE는 해당 조건검사시 동등비교만 수행
    - CASE WHEN THEN 구문의 경우 특정 조건을 내 맘데로 제시할 수 있음. 
    
    [표현법]
    CASE [칼럼값} WHEN 조건식1 THEN 결과값1
                 WHEN 조건식2 THEN 결과값2
                 ....
                 ELSE 결과값 
    END:
    
    - 자바의 IF ~ ELSE IF문과 비슷한 구조 
    if(조건식1) {
        결과값1;
    }
    else if(조건식2){
        결과값2;
    }
    else{
        결과값
    }
*/


-- CASE WHEN으로 성별자리를 추출

SELECT EMP_ID, 
    EMP_NAME,
    EMP_NO,
    CASE 
        WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남자'
        WHEN SUBSTR(EMP_NO, 8, 1) = 2 THEN '여자'
        WHEN SUBSTR(EMP_NO, 8, 1) = 3 THEN '남자'
        WHEN SUBSTR(EMP_NO, 8, 1) = 4 THEN '여자'
        ELSE '중성' 
    END AS "성별" 
FROM EMPLOYEE;

-- CASE WHEN에서 단순 특정값에 대해 동등비교만 수행하고 있다면? 
-- CASE 비교값 WHEN 비교값1 THEN 결과값1 .. END;
SELECT EMP_ID, 
    EMP_NAME,
    EMP_NO,
    CASE SUBSTR(EMP_NO, 8, 1)
        WHEN '1' THEN '남자'
        WHEN '2' THEN '여자'
        WHEN '3' THEN '남자'
        WHEN '4' THEN '여자'
        ELSE '중성' 
    END AS "성별"
FROM EMPLOYEE;



-- 사원명, 급여, 급여등급을 조회 (SAL_LEVEL 칼럼 사용금지)
-- 급여등급은 SALARY 값이 400만원 초과인경우 '고급' 
--          SALARY 값이 400만원 이하 350만원 초과일경우 '중급' 
--          SALARY 값이 350만원 이하 200만원 초과일경우 '초급' 
--          그외는 '수습' 
-- CASE WHEN 구문으로 작성해보기

SELECT EMP_NAME, SALARY, CASE 
    WHEN SALARY > 4000000 THEN '고급' 
    WHEN SALARY > 3500000 THEN '중급'
    WHEN SALARY > 2000000 THEN '초급' 
    ELSE '수습' 
    END AS "SAL_LEVEL"
FROM EMPLOYEE;

/* WHERE 절에 CASE WHEN 구문 작성하기*/
SELECT * 
FROM EMPLOYEE
WHERE (CASE WHEN SALARY > 4000000 THEN 1 end) = 1;

/* ORDER BY 절에 CASE WHEN 구문 작성하기*/
-- CASE WHEN + ORDER BY 절 구문으로 행의 순서 고정하기 
-- CASE WHEN 조건1 THEN 1 
--      WHEN 조건2 THEN 2 
--      WHEN 조건3 THEN 3
--      ELSE 4; 

-- EMPLOYEE, EMP_ID 205번인 사원을 항상 1등으로, 210번 사원을 항상 2등처리, 그 외는 정상 출력
SELECT EMP_NAME, EMP_ID, SALARY 
FROM EMPLOYEE
ORDER BY CASE EMP_ID WHEN '205' THEN 1
                     WHEN '210' THEN 2  
                     ELSE 3 END, EMP_NAME;


-- 직급코드 J3인 사원을 항상 1등, J4인 사원을 항상 2등으로 처리, 그외는 SALARY에 내림차순 정렬 
SELECT EMP_NAME, EMP_ID, SALARY , JOB_CODE
FROM EMPLOYEE
ORDER BY CASE JOB_CODE WHEN 'J3' THEN 1
                     WHEN 'J4' THEN 2  
                     ELSE 3 END, SALARY DESC;   
                     

----------------------------<그룹함수> -----------------------------------

-- 그룹함수 : 데이터들의 합(SUM), 평균(AVG)…
/*
    N개의 값을 읽어들여서 1개의 결과를 반환(하나의 그룹별로 함수 실행 결과를 반환) 
*/


-- 1. SUM (숫자타입컬럼) : 컬럼값의 총 합계를 반환. 

-- 전체 사원들의 총 급여합계
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서코드가 D5인 사원들의 총 급여 합계 
SELECT SUM(SALARY) -- , EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D2';
                     


-- 2. AVG(숫자타입컬럼) : 평균반환, 숫자타입 컬럼으로만 사용할 수 있다.

SELECT FLOOR(AVG(SALARY))
FROM EMPLOYEE;

-- 3. MIN(ANY 타입 칼럼) : 컬럼값 중 가장 작은 값 반환
-- 전체 사원들중 최저급여,
-- 가장 작은 이름(),
-- 가장 작은 이메일, 
-- 가장 작은 입사날짜(가장 과거) 

SELECT MIN(SALARY), 
       MIN(EMP_NAME),
       MIN(EMAIL),
       MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 4. MAX(ANY 타입 칼럼)
SELECT MAX(SALARY), 
       MAX(EMP_NAME),
       MAX(EMAIL),
       MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. COUNT (* / 컬럼 / DISTINCT 컬럼) : 조회된 행의 갯수를 세서 반환.
-- COUNT(*) : 조회결과로 나온 행의 갯수를 모두 세서 반환 
-- COUNT(칼럼이름) : 컬럼값이 NULL이 아닌 행의 갯수만 세서 반환 
-- COUNT(DISTINCT 컬럼이름) : 제시한 해당 컬럼값에 중복값이 있는경우 한개로 처리한다. 그리고 NULL도 포함시키지 않는다.

SELECT COUNT(*) 
FROM EMPLOYEE;

-- 여사원 사원의 수?
SELECT COUNT(*) 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) =2;

-- 부서배치가 완료된 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;


-- 부서배치가 완료된 여자사원의 수 
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2;


SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL AND SUBSTR(EMP_NO, 8, 1) = 2;


-- 현재 사원들이 속해있는 부서의 개수 
SELECT COUNT(DISTINCT DEPT_CODE) -- 중복된 부서코드는 없애고, NULL값은 세지않는다.
FROM EMPLOYEE;


-- 현재 사용되고 있는 직급의 갯수 == 사원들의 직급의 종류 갯수 
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 직원명, 부서코드, 생년월일, 나이를 조회
-- (생년월일 : 주민번호에서 추출하여 00년 00월 00일로 출력되게 하며,
-- 나이는 주민번호에서 추출하여 날짜 데이터로 변환한 다음 계산) -> (현재년도 - 태어난 년도)
SELECT EMP_NAME, DEPT_CODE, 
        TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6)), 'RRRR"년" MM"월" DD"일"') "생년월일", -- 데이트 자료형 값을 문자열 값으로
        FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO, 1, 6))) / 365) "만나이", -- 만나이 
        EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) 나이 -- 나이
FROM EMPLOYEE;


------------------------------<윈도우 함수> ---------------------------------
/*
    - 윈도우 함수(WINDOW FUNCTION) == 분석함수, 순위함수 
    WINDOW? SQL에서 RESULT SET을 특정부분으로 분할하거나, 관찰하는 논리적인 개념 
    WINDOW(창)을 통해 데이터를 "관찰" 또는 "분석"하고 "순위"를 매기는 함수들이 WINDOW FUNCTION이라고 부름
    조회결과 혹은 통계결과를 확인시 사용.
    
    SELECT가 완료된 후, ORDER BY 절 실행 전에 실행됨.
    
    실행순서
    1. FROM 
    2. WHERE 
    3. SELECT 
    4. WINDOW FUNCTION 
    5. ORDER BY 
    
    1. 순위를 매기는 함수 
    - RANK() OVER ([그룹화 기준] 정렬기준)
    - DENSE_RANK() OVER ([그룹화 기준] 정렬기준)
    - ROW_NUMBER() OVER ([그룹화 기준] 정렬기준)
*/

-- 1. RANK() OVER ([PARTITION BY 칼럼] ORDER BY 칼럼 [ASC/DESC])
-- 공동 1위가 3명 존재할 경우 그 다음 순위를 4위로 정함.
-- 정렬기준 ? ORDER BY 정렬기준 칼럼이름 [ASC/DESC] NULLSFIRST/NULLSLAST는 기술불가.
-- PARTITION ? 데이터를 분할하는 행위. 칼럼기준으로 데이터를 분할하기 위한 예약어. 
--             그룹화된 데이터안에서 순위를 매길 수 있음

-- 사원들의 급여가 높은 순서대로 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위 
FROM EMPLOYEE;
-- 급여를 기준으로 순위를 부여한다. 

-- 2. DENSE_RANK() OVER(그룹화기준 정렬기준) : 공동 1위가 3명이라고 했을때 다음 순위는 2위로 하겠다.
-- DENSE == 밀집된, 즉 밀집된 랭킹 부여 
-- 사원들의 급여가 높은 순서대로 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위 -- 급여를 기준으로 순위를 부여한다.
FROM EMPLOYEE;

-- 3. ROW_NUMBER() : 공동순위가 없는 고유한 번호를 부여하는 함수 
SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) 순위 
FROM EMPLOYEE; -- 고유한 식별자가 필요할때 사용한다. 


-- PARTITION BY 
-- DEPT_CODE(부서)별로 데이터를 그룹화한후 SALARY기준 내림차순 정렬을 시킨후 고유한 순위를 부여 
SELECT EMP_NAME, DEPT_CODE, SALARY, ROW_NUMBER() OVER (PARTITION BY DEPT_CODE ORDER BY SALARY DESC)
FROM EMPLOYEE;
-- DEPT_CODE 별 순위를 만드는 것이다.

-- EMPLOYEE 테이블에서 사원의 이름, 직급코드, 봉급, 보너스 미포함 연봉을 구한후 
-- 직급별로 그룹화하여 그룹화된 소그룹 내에서 연봉을 많이 받는 사원부터 고유한 순서를 매기시오.
SELECT EMP_NAME, JOB_CODE, SALARY, (SALARY * 12) "보너스 미포함 연봉",
        ROW_NUMBER() OVER(PARTITION BY JOB_CODE ORDER BY (SALARY * 12) DESC) "순위"
FROM EMPLOYEE; 


-- 윈도우 함수 + ORDER BY절
SELECT EMP_ID, EMP_NAME, SALARY, ROW_NUMBER() OVER (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE
ORDER BY EMP_ID ASC;
-- ORDER BY 절은 RESULT SET 집합결과가 다 만들어진 후 실행되기 때문에 마지막에 실행된다. 
-- 사용시기가 겹치는 WINDOW 함수와 함께 사용하지 않는다. 

/*
    그룹내 행의 순서를 가져오는 함수 
    4. LAG(LEAD AND GET): 현재행 기준 앞의 행의 값을 가져올때 사용함. 
    5. LEAD : 현재행 기준 뒤의 행의 값을 가져올때 사용함. 
    
    [표현법] 
    LAG/LEAD(가져올 칼럼, 가져올 행번호, 행이 없는 경우 기본값) OVER ([PARTITION BY 칼럼] ORDER BY 칼럼)

    
*/

-- 조회결과내에서 월급기준으로 내림차순 정렬한 후, 이전행의 월급 가져오기
SELECT 
    EMP_NAME, DEPT_CODE, SALARY, LAG(SALARY) OVER (ORDER BY SALARY DESC) "이전 직원 월급"
FROM EMPLOYEE;

-- 다음행 가져오기 
SELECT 
    EMP_NAME, DEPT_CODE, SALARY , LEAD(SALARY) OVER (ORDER BY SALARY DESC) "다음 직원 월급"
FROM EMPLOYEE;

-- 전전사람의 가져오기 
SELECT 
    EMP_NAME, DEPT_CODE, SALARY , LAG(SALARY , 2, 0) OVER (ORDER BY SALARY DESC) "전전 직원 월급"
FROM EMPLOYEE;

-- 조회결과내에서 DEPT_CODE별로 그룹화시켜준후 내림차순 정렬을 시킨후 각 소그룹별 다음사람의 월급 가져오기
SELECT 
    EMP_NAME, DEPT_CODE, SALARY , LEAD(SALARY) OVER (PARTITION BY DEPT_CODE ORDER BY SALARY DESC)
FROM EMPLOYEE;


/*
    [실습] 
    직원의 사원번호, 이름, 직급코드, 월급을 조회한후 
    조회결과내에서 직급코드별로 그룹화하여 소그룹내에서 전직원의 월급을 가져오기 
    단, 가져올 데이터가 없는 경우 0원으로 표시하며 소그룹내에서는 사원번호 기준으로 오름차순 정렬 
*/

-- LAG에 NVL 을 이용한 방법 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, NVL(LAG(SALARY) OVER (PARTITION BY JOB_CODE ORDER BY EMP_ID ASC), 0)
FROM EMPLOYEE;

-- LAG 함수를 활용한 방법 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, LAG(SALARY,1,0) OVER (PARTITION BY JOB_CODE ORDER BY EMP_ID ASC)
FROM EMPLOYEE;

-- 특정 컬럼값을 명확히 부여해서 찾는것을 권장한다.
SELECT EMPLOYEE.*, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;





