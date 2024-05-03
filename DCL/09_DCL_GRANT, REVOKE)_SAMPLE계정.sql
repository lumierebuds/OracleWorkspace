/* 3_1, 3_2. CREATE TABLE, TABLESPACE 권한부여 완료 */
CREATE TABLE TEST(
    TEST_ID NUMBER 
);

-- 테이블 생성권한 부여받으면 테이블 조작(DML)이 가능해진다.
INSERT INTO TEST VALUES (1);

-- 4. 뷰 만들어보기
CREATE VIEW V_TEST
AS SELECT * FROM TEST;


-- 5. SAMPLE 계정에서 KH계정의 테이블에 접근해보기.
SELECT *
FROM C##KH.EMPLOYEE;

-- 6. SAMPLE 계정에서 KH계정의 DEPARTMENT테이블에 데이터 추가하기.
SELECT * 
FROM C##KH.DEPARTMENT; -- SELECT 권한을 부여하지 않는다.

INSERT INTO C##KH.DEPARTMENT VALUES('D0', '전략기획실', 'L2'); 

COMMIT;

-- 7. 테이블 권한 회수된 후 
CREATE TABLE TEST2(
    TEST_ID NUMBER
    );
