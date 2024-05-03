

-- 1. 

CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

-- 2. 
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

-- 3. 

ALTER TABLE TB_CATEGORY ADD CONSTRAINT TC_PK_NE PRIMARY KEY(NAME);

-- 4. 

ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

ALTER TABLE TB_CLASS_TYPE MODIFY NAME CONSTRAINT TCT_NN_NAME NOT NULL;

--5. 

-- NO
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);

-- NAME
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);

-- 6. 
ALTER TABLE TB_CATEGORY 
RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NAME TO CLASS_TYPE_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NO TO CLASS_TYPE_NO;


-- 7. 

ALTER TABLE TB_CATEGORY 
RENAME COLUMN CATEGORY_NAME TO PK_CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN CLASS_TYPE_NO TO  PK_CLASS_TYPE_NO;

ALTER TABLE TB_CATEGORY
RENAME CONSTRAINT TC_PK_NE TO PK_CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME CONSTRAINT SYS_C008553 TO PK_CLASS_TYPE_NO;

-- 8 

INSERT INTO TB_CATEGORY VALUES('공학' ,'Y');
INSERT INTO TB_CATEGORY VALUES('자연과학' ,'Y');
INSERT INTO TB_CATEGORY VALUES('의학' ,'Y');
INSERT INTO TB_CATEGORY VALUES('예체능' ,'Y');
INSERT INTO TB_CATEGORY VALUES('인문사회' ,'Y');
COMMIT;

-- 9. 
ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY)
REFERENCES TB_CATEGORY(PK_CATEGORY_NAME);


-- 10. 
-- VIEW 만들 수 있는 권한 추가 
GRANT CREATE VIEW TO C##WORKBOOK; -- 관리자 계정

CREATE OR REPLACE VIEW VM_학생일반정보 
AS SELECT STUDENT_NO "학번", STUDENT_NAME "학생이름", STUDENT_ADDRESS "학생 주소" 
FROM TB_STUDENT;

SELECT * FROM VM_학생일반정보;

-- 11. 
CREATE OR REPLACE VIEW VM_지도면담 
AS SELECT STUDENT_NAME "학생이름", DEPARTMENT_NAME "학과이름", NVL(PROFESSOR_NAME, '지도교수없음') "지도교수이름"
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
ORDER BY "학과이름";

SELECT * FROM VM_지도면담;


-- 12. 

CREATE OR REPLACE VIEW VM_학과별학생수
AS SELECT DEPARTMENT_NAME, COUNT(*) "STUDENT_COUNT"
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
GROUP BY DEPARTMENT_NAME;

SELECT * FROM VM_학과별학생수;

SELECT * FROM VM_학생일반정보;

-- 13. 
UPDATE VM_학생일반정보 SET 학생이름 = 학생이름
WHERE 학번 = 'A213046';


-- 14. 
CREATE OR REPLACE VIEW VM_학생일반정보 
AS SELECT STUDENT_NO "학번", STUDENT_NAME "학생이름", STUDENT_ADDRESS "학생 주소" 
FROM TB_STUDENT WITH READ ONLY; 

-- 15. 최근 5년, 2009년 기준
SELECT * 
FROM (SELECT C.CLASS_NO, C.CLASS_NAME , COUNT(*)
FROM TB_CLASS C
JOIN TB_GRADE G ON C.CLASS_NO = G.CLASS_NO
WHERE G.TERM_NO >= 200501
GROUP BY C.CLASS_NO , C.CLASS_NAME
ORDER BY 3 DESC)
WHERE ROWNUM <=3;


