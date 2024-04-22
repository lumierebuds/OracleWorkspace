-- 한줄 주석
/*
    여러줄 주석
*/
-- DBA_USERS : 현재 오라클서버의 모든 계정정보를 보관하는 "테이블" 
SELECT * FROM DBA_USERS; -- 명령문 한줄 실행시 CTRL + ENTER

-- 계정 생성
-- 일반 사용자계정을 생성할 수 있는 권한은 오직 관리자 계정에 있다. 
-- 사용자 계정 생성방법
-- [표현법] 
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
--CREATE USER C##KH IDENTIFIED BY KH; -- 21 version: C## 붙여준다.

-- 생성된 사용자 계정에 권한부여
-- 부여할 권한 ? DB에 접속할 수 있는 권한(CREATE SESSION), 데이터를 관리(CREATE TABLE, INSERT TABLE, DELETE TABLE ...)
-- [표현법] GRANT 권한1, 권한2, ... TO 계정명;

GRANT CONNECT, RESOURCE TO C##KH;

GRANT UNLIMITED TABLESPACE TO C##KH;
