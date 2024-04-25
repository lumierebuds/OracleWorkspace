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


SELECT TO_CHAR(SYSDATE, )
FROM DUAL; 
