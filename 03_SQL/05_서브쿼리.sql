	
/* **************************************************************************
서브쿼리(Sub Query)
- 쿼리안에서 select 쿼리를 사용하는 것.
- 메인 쿼리 - 서브쿼리

서브쿼리가 사용되는 구
 - select절, from절, where절, having절
 
서브쿼리의 종류
- 어느 구절에 사용되었는지에 따른 구분
    - 스칼라 서브쿼리 - select 절에 사용. 반드시 서브쿼리 결과가 1행 1열(값 하나-스칼라) 0행이 조회되면 null을 반환
    - 인라인 뷰 - from 절에 사용되어 테이블의 역할을 한다.
- 서브쿼리 조회결과 행수에 따른 구분
    - 단일행 서브쿼리 - 서브쿼리의 조회결과 행이 한행인 것.
    - 다중행 서브쿼리 - 서브쿼리의 조회결과 행이 여러행인 것.
- 동작 방식에 따른 구분
    - 비상관(비연관) 서브쿼리 - 서브쿼리에 메인쿼리의 컬럼이 사용되지 않는다.
                메인쿼리에 사용할 값을 서브쿼리가 제공하는 역할을 한다.
    - 상관(연관) 서브쿼리 - 서브쿼리에서 메인쿼리의 컬럼을 사용한다. 
                            메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할때 주로 사용한다.

- 서브쿼리는 반드시 ( ) 로 묶어줘야 한다.
************************************************************************** */
-- 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)를 하는 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회
SELECT
	emp_id
    ,emp_name
    ,job_id
    ,salary
FROM emp
WHERE 1=1
AND job_id = (
				SELECT job_id
				FROM emp
                WHERE emp_id = 120
			)
;

-- 직원_id(emp.emp_id)가 115번인 직원과 같은 업무(emp.job_id)를 하고 같은 부서(emp.dept_id)에 속한 직원들을 조회하시오.
SELECT *
FROM emp
-- pair subquery  
WHERE (job_id,dept_id) = (
							SELECT 
								job_id
								,dept_id
							FROM emp
							WHERE emp_id = 115
						)
;
-- 직원들 중 급여(emp.salary)가 전체 직원의 평균 급여보다 적은 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회. 
SELECT 
	emp_id
    ,emp_name
    ,salary
FROM emp
WHERE 1=1
AND salary < (
				SELECT AVG(salary)
                FROM emp
			)
ORDER BY salary DESC
;
-- 부서직원들의 평균이 전체 직원의 평균(emp.salary) 이상인 부서의 이름(dept.dept_name), 평균 급여(emp.salary) 조회.
-- 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력
SELECT
	D.dept_name "부서이름"
    ,CONCAT("$",FORMAT(AVG(E.salary),2)) "부서 평균 급여"
FROM emp E
	LEFT JOIN dept D
		ON E.dept_id = D.dept_id
GROUP BY dept_name
HAVING AVG(E.salary) >= (
						SELECT AVG(salary)
                        FROM emp
					)
ORDER BY AVG(E.salary) 
;
-- TODO: 직원의 ID(emp.emp_id)가 145인 직원보다 많은 연봉을 받는 직원들의 이름(emp.emp_name)과 급여(emp.salary) 조회.급여가 큰 순서대로 조회
SELECT
	emp_name "이름"
    ,salary "급여"
FROM emp
WHERE 1=1
AND salary > (
				SELECT 
					salary
				FROM emp
                WHERE emp_id = 145
			 )
ORDER BY salary DESC
;

-- TODO: 직원의 ID(emp.emp_id)가 150인 직원과 업무(emp.job_id)와 상사(emp.mgr_id)가 같은 직원들의 
-- id(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 상사(emp.mgr_id) 를 조회
SELECT
	emp_id "직원 ID"
    ,emp_name "이름"
    ,job_id "업무 아이디"
    ,mgr_id "상사 아이디"
FROM emp
WHERE (emp_id,job_id,mgr_id) = (
									SELECT 
										emp_id
                                        ,job_id
                                        ,mgr_id
									FROM emp
                                    WHERE emp_id = 150
								)
;
-- TODO : EMP 테이블에서 직원 이름이(emp.emp_name)이  'John'인 직원들 중에서 
-- 급여(emp.salary)가 가장 높은 직원의 salary(emp.salary)보다 많이 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회.
SELECT
	emp_id "직원 ID"
    ,emp_name "직원 이름"
    ,salary "급여"
FROM emp
WHERE 1=1
AND salary > (
				SELECT MAX(salary)
				FROM emp
                WHERE emp_name = 'John'
			)
;
-- TODO: 급여(emp.salary)가장 많이 받는 직원이 속한 부서의 이름(dept.dept_name), 위치(dept.loc)를 조회.
SELECT 
	dept_name "부서 이름"
    ,loc "위치"
FROM dept
WHERE 1=1
AND dept_id = (
				SELECT 
					dept_id
				FROM emp
                WHERE salary = (
									SELECT MAX(salary)
                                    FROM emp
								)
				)
;
-- TODO: 급여(emp.salary)를 제일 많이 받는 직원들의 이름(emp.emp_name), 부서명(dept.dept_name), 급여(emp.salary) 조회. 
-- 급여는 앞에 $를 붙이고 단위구분자 , 를 출력
SELECT
	E.emp_name "직원 이름"
    ,D.dept_name "부서명"
    ,E.salary "급여"
FROM emp E
	JOIN dept D 
		ON E.dept_id = D.dept_id
WHERE 1=1
AND salary = (
				SELECT MAX(salary)
                FROM emp
			)
;

-- TODO: 30번 부서(emp.dept_id) 의 평균 급여(emp.salary)보다 급여가 많은 직원들의 모든 정보를 조회.

SELECT *
FROM emp
WHERE 1=1
AND salary > (
				SELECT
					AVG(salary)
				FROM emp
                WHERE dept_id = 30
			)
;
-- TODO: 전체 직원들 중 담당 업무 ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여를 받는 직원들의 모든 정보를 조회. 
-- 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 



-- TODO: EMP 테이블에서 업무(emp.job_id)가 'IT_PROG' 인 직원들의 평균 급여보다 더 많은 급여를 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 급여 내림차순으로 조회.



/* ----------------------------------------------
 다중행 서브쿼리
 - 서브쿼리의 조회 결과가 여러행인 경우
 - where절 에서의 연산자
	- in
	- 비교연산자 any : 조회된 값들 중 하나만 참이면 참 (where 컬럼 > any(서브쿼리) )
	- 비교연산자 all : 조회된 값들 모두와 참이면 참 (where 컬럼 > all(서브쿼리) )
------------------------------------------------*/
-- 'Alexander' 란 이름(emp.emp_name)을 가진 관리자(emp.mgr_id)의 부하 직원들의 ID(emp_id), 이름(emp_name), 업무(job_id), 입사년도(hire_date-년도만출력), 급여(salary)를 조회
SELECT
	emp_id
    ,emp_name
    ,job_id
    ,YEAR(hire_date)
    ,salary
FROM EMP
WHERE 1=1
AND mgr_id IN (
	SELECT emp_id
	FROM emp
	WHERE emp_name = "Alexander"
)
;
-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 보다 급여(emp.salary)를 많이 받는 직원의 모든 정보를 조회.

-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 중 급여가 가장 적은 직원보다 급여를 많이 받는 직원의 모든 정보를 조회.
;
SELECT *
FROM emp
WHERE salary > (
				SELECT MIN(salary)
                FROM emp
                WHERE emp_id in (101,102,103)
			)
;

-- TODO : 부서 위치(dept.loc) 가 'New York'인 부서에 소속된 직원의 ID(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id) 를 sub query를 이용해 조회.
SELECT
	emp_id
    ,emp_name
    ,dept_id
FROM emp 
WHERE dept_id IN (
					SELECT 
						dept_id
                    FROM dept
                    WHERE loc = "New York"
					)
;                  
-- TODO : 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는  직원(emp)의 모든 정보를 sub query를 이용해 조회.
SELECT *
FROM emp
WHERE 1=1
AND job_id IN	(
					SELECT job_id
					FROM job
					WHERE max_salary <= 6000
				)
;
-- TODO: 전체 직원들중 부서_ID(emp.dept_id)가 20인 부서의 모든 직원들 보다 급여(emp.salary)를 많이 받는 직원들의 정보를 sub query를 이용해 조회.
SELECT *
FROM emp
WHERE 1=1
AND salary > (
				SELECT MAX(salary)
				FROM emp
				WHERE dept_id = 20
);

/* *************************************************************************************************
상관(연관) 쿼리
- 메인쿼리문 테이블의 값을 where절의 subquery에서 참조한다.
	- 메인 쿼리의 where실행에서 한 행씩 조회 대상인지 검사하면서 subquery가 실행되는데 이때 현재 검사중인 그 행의 컬럼값을 subquery가 사용한다.
* *************************************************************************************************/
-- 부서별(DEPT)에서 급여(emp.salary)를 가장 많이 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 연봉(emp.salary), 소속부서ID(dept.dept_id) 조회
SELECT *
FROM emp
WHERE (dept_id,salary) in (
SELECT 
	D.dept_id
	,MAX(E.salary) "max_sal"
FROM emp E
	JOIN dept D
		ON E.dept_id = D.dept_id
GROUP BY D.dept_id
);

SELECT *
FROM emp E
WHERE salary = (
					SELECT MAX(salary)
                    FROM emp
                    WHERE IFNULL(dept_id,0) = IFNULL(E.dept_id,0) -- dept_id가 Null인경우 포함하기 위해 대체값 변경 
				)
ORDER BY dept_id
;
                
/* **************************************************************************************
EXISTS, NOT EXISTS 연산자 (상관(연관)쿼리와 같이 사용된다)
-- 서브쿼리의 결과를 만족하는 값이 존재하는지 여부를 확인하는 조건. 
-- 조건을 만족하는 행이 여러개라도 한행만 있으면 더이상 검색하지 않는다.

- 보통 데이터테이블의 값이 이력테이블(Transaction TB)에 있는지 여부를 조회할 때 사용된다.
	- 메인쿼리: 데이터테이블
	- 서브쿼리: 이력테이블
	- 메인쿼리에서 조회할 행이 서브쿼리의 테이블에 있는지(또는 없는지) 확인
	
고객(데이터) 주문(이력) -> 특정 고객이 주문을 한 적이 있는지 여부
장비(데이터) 대여(이력) -> 특정 장비가 대여 된 적이 있는지 여부
************************************************************************************* */
 

-- 직원이 한명이상 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
SELECT 
	D.dept_id
    ,D.dept_name
    ,D.loc
FROM dept D
WHERE EXISTS (
				SELECT *
                FROM emp
                WHERE dept_id = D.dept_id
			)
;

-- 직원이 한명도 없는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
SELECT
	D.dept_id
    ,D.dept_name
    ,D.loc
FROM dept D
WHERE NOT EXISTS (
					SELECT *
                    FROM emp
                    WHERE dept_id = D.dept_id
				)

