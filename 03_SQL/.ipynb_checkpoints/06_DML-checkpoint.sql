-- AUTO COMMIT => 데이터를 변경(I,U,D) 쿼리문 실행시 쿼리결과를 바로 적용
-- manual commit  => 변경사항 시 자동으로 적용하지 않겠다는 것. 적용명령 수행시 적용.
-- SET AUTOCOMMIT = 1;
SET AUTOCOMMIT = 0; 


/* *********************************************************************
INSERT 문 - 행 추가
구문
 - 한행추가 :
   - INSERT INTO 테이블명 (컬럼 [, 컬럼]) VALUES (값 [, 값[])
   - 모든 컬럼에 값을 넣을 경우 컬럼 지정구문은 생략 할 수 있다.

 - 조회결과(select)를 INSERT 하기 (subquery 이용)
   - INSERT INTO 테이블명 (컬럼 [, 컬럼])  SELECT 구문
	 - INSERT할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
	 - 모든 컬럼에 다 넣을 경우 컬럼 설정은 생략할 수 있다.
************************************************************************ */
INSERT INTO dept(dept_id,dept_name,loc)
VALUES (300,"연구소","서울")
;
INSERT INTO emp
VALUES (550,'홍길동','FI_ACCOUNT',100,'2020-10-20',30000,0.1,500)
;

SHOW KEYS
FROM emp;


SELECT *
FROM dept
ORDER BY dept_id DESC
;


/* *********************************************************************
UPDATE : 테이블의 컬럼의 값을 수정
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값]
[WHERE 제약조건]

 - UPDATE: 변경할 테이블 지정
 - SET: 변경할 컬럼과 값을 지정
 - WHERE: 변경할 행을 선택. 
************************************************************************ */

-- 직원 ID가 200인 직원의 급여를 5000으로 변경
UPDATE emp
SET salary = 5000
WHERE emp_id = 200
;
SELECT *
FROM emp
WHERE emp_id = 200
;
-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.
UPDATE emp
SET salary = salary * 1.1
WHERE emp_id = 200
;

-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로, 상사_id는 100 변경.
UPDATE emp
SET comm_pct = 0.2, salary = salary + 3000, mgr_id = 100
WHERE dept_id = 100
;

SELECT *
FROM emp
WHERE dept_id = 100
;

-- 부서 ID가 100인 직원의 커미션 비율을 null 로 변경.
UPDATE emp
SET comm_pct = NULL
WHERE dept_id = 100
;


-- TODO: 부서 ID가 100인 직원들의 급여를 100% 인상
UPDATE emp
SET salary = salary * 2
WHERE dept_id = 100
;


-- TODO: IT 부서의 직원들의 급여를 3배 인상

UPDATE emp
SET salary = salary * 3
WHERE  dept_id = (
					SELECT dept_id
					FROM dept
					WHERE dept_name = "IT"
				 )
;


-- TODO: EMP 테이블의 모든 데이터를 MGR_ID는 NULL로 HIRE_DATE 는 현재일시로 COMM_PCT는 0.5로 수정.
;
UPDATE emp
SET mgr_id = NULL, hire_date = CURDATE(),comm_pct = 0.5
;
/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택
************************************************************************ */

-- 전체 행 삭제
USE hr_join;
DELETE
FROM emp
;
SELECT @@AUTOCOMMIT;
SET @@AUTOCOMMIT = 0;
SELECT *
FROM emp
;
ROLLBACK;
-- 부서테이블에서 부서_ID가 200인 부서 삭제
DELETE
FROM emp
WHERE dept_id = 200
;

SELECT *
FROM emp
WHERE dept_id = 200
;
-- 부서테이블에서 부서_ID가 10인 부서 삭제
SELECT *
FROM emp
WHERE dept_id = 10
;

-- TODO: 부서 ID가 없는 직원들을 삭제
DELETE
FROM emp
WHERE dept_id IS NULL
;

-- TODO: 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제.
DELETE
FROM emp
WHERE job_id = "SA_MAN"
AND salary < 12000
;

-- TODO: comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제

DELETE
FROM emp
WHERE comm_pct IS NULL
AND job_id = "IT_PROG"
;
