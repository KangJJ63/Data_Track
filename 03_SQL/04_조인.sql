/* ********************************************************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블 (메인정보 테이블)
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블 (추가정보 테이블)
 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
    - 조인 연산에 따른 조인종류
        - Equi join , non-equi join
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - Outer Join
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join
        - 두 테이블의 곱집합을 반환한다. 
******************************************************************************** */        



/* ****************************************
-- INNER JOIN
FROM  테이블a INNER JOIN 테이블b ON 조인조건 

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
SELECT
	E.emp_id
    ,E.emp_name
    ,E.hire_date
    ,D.dept_name
FROM emp E
JOIN dept D  --  INNER는 생략 가능
ON E.dept_id = D.dept_id
;

-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.
SELECT
	E.emp_id
    ,E.emp_name
    ,E.hire_date
    ,D.dept_name
FROM emp E
JOIN dept D  --  INNER는 생략 가능
ON E.dept_id = D.dept_id
AND E.emp_id = 100
-- WHERE E.emp_id = 100
;

-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회
SELECT
	E.emp_id
    ,E.emp_name
    ,E.salary
    ,J.job_title
    ,D.dept_name
FROM emp E
JOIN job J 
	ON E.job_id = J.job_id
JOIN dept D
	ON E.dept_id = D.dept_id
;

-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.
SELECT
	D.dept_name
    ,D.loc
    ,E.emp_name
FROM dept D
JOIN emp E
	ON D.dept_id = E.dept_id
	AND D.dept_id = 30
;

-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 급여 등급 오름차순으로 정렬
SELECT
	E.emp_id
    ,E.emp_name
    ,E.salary
    ,CONCAT("LV",S.grade)
FROM emp E
JOIN salary_grade S
	ON E.salary BETWEEN S.low_sal AND S.high_sal
ORDER BY S.grade
;


-- TODO 직원 id(emp.emp_id)가 200번대(200 ~ 299)인 직원들의  
-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
SELECT
	E.emp_id
    ,E.emp_name
    ,E.salary
    ,D.dept_name
    ,D.loc
FROM emp E
JOIN dept D
ON E.dept_id = D.dept_id
WHERE E.emp_id BETWEEN 200 AND 299
ORDER BY E.emp_id DESC
;
-- TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name),
-- 업무(emp.job_id), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
SELECT
	E.emp_id
    ,E.emp_name
    ,E.job_id
    ,D.dept_name
    ,D.loc
FROM emp E
JOIN dept D 
	ON E.dept_id = D.dept_id
WHERE E.job_id = "FI_ACCOUNT"
ORDER BY E.emp_id DESC
;

-- TODO 커미션을(emp.comm_pct) 받는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name),
-- 급여(emp.salary), 커미션비율(emp.comm_pct), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
SELECT 
	E.emp_id
    ,E.emp_name
	,E.salary
    ,E.comm_pct
    ,D.dept_name
    ,D.loc
FROM emp E
JOIN dept D
	ON E.dept_id = D.dept_id
WHERE E.comm_pct IS NOT NULL
ORDER BY E.emp_id DESC
;
-- TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
-- 그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 
SELECT
	D.dept_id
    ,D.dept_name
    ,D.loc
    ,E.emp_id
    ,E.emp_name
    ,E.job_id
FROM dept D
JOIN emp E
	ON D.dept_id = E.dept_id
	AND D.loc = "New York"
;

-- TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
SELECT
	E.emp_id
    ,E.emp_name
    ,E.job_id
    ,J.job_title
FROM emp E
JOIN job J
	ON E.job_id = J.job_id
;
      
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
SELECT
	E.emp_id
    ,E.emp_name
    ,E.salary
    ,J.job_title
    ,D.dept_name
FROM emp E
JOIN dept D
	ON E.dept_id = D.dept_id
JOIN job J
	ON E.job_id = J.job_id
WHERE E.emp_id = 200
;

-- TODO: 'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 
-- 이름(emp.emp_name), 입사일(emp.hire_date)를 조회 입사일은 'yyyy년 mm월 dd일' 형식으로 출력
SELECT 
	E.emp_id
    ,E.emp_name
    ,DATE_FORMAT(E.hire_date,"%Y년 %m %d일")
FROM emp E
JOIN dept D
	ON e.dept_id = D.dept_id
    AND D.loc = "San Francisco"
;
-- TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬. 
SELECT 
	D.dept_name "dept_name"
    ,CONCAT("$",FORMAT(AVG(E.salary),2)) "s_avg"
FROM dept D
JOIN emp E
	ON D.dept_id = E.dept_id
GROUP BY D.dept_name
ORDER BY s_avg DESC
;

-- TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 
-- 급여(emp.salary), 급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
DESC salary_grade;
SELECT
	E.emp_id
    ,E.emp_name
    ,J.job_title
    ,E.salary
    ,SG.grade
    ,D.dept_name
FROM emp E
	JOIN job J
		ON E.job_id = J.job_id
	JOIN dept D
		ON E.dept_id = D.dept_id
	JOIN salary_grade SG
		ON E.salary BETWEEN SG.low_sal AND SG.high_sal
ORDER BY SG.grade DESC
;
/* ****************************************************
Self 조인
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
**************************************************** */
SELECT *
FROM emp;
-- 직원 ID가 101인 직원의 직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
SELECT
	E1.emp_id
    ,E1.emp_name
    ,E2.emp_name "mgr_name"
FROM emp E1
JOIN emp E2
	ON E1.mgr_id = E2.emp_id
WHERE E1.emp_id = 101
;

/* ****************************************************************************
외부 조인 (Outer Join)
- 불충분 조인
    - 조인 연산 조건을 만족하지 않는 행도 포함해서 합친다
종류
 left  outer join: 구문상 소스 테이블이 왼쪽
 right outer join: 구문상 소스 테이블이 오른쪽
 full outer join:  둘다 소스 테이블 (Mysql은 지원하지 않는다. - union 연산을 이용해서 구현)

- 구문
from 테이블a [LEFT | RIGHT] OUTER JOIN 테이블b ON 조인조건
- OUTER는 생략 가능.

**************************************************************************** */


-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. dept_name의 내림차순으로 정렬한다.
SELECT
	E.emp_id
    ,E.emp_name
    ,E.salary
    ,D.dept_name
    ,D.loc
FROM emp E
	LEFT JOIN dept D
		ON E.dept_id = D.dept_id
ORDER BY D.dept_name DESC
;


-- 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)

        
-- TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 
--  직원의 ID(emp.emp_id),이름(emp.emp_name), 업무명(job.job_title) 을 조회. 업무명이 없을 경우 '미배정' 으로 조회
SELECT
	E.emp_id
    ,E.emp_name
    ,IFNULL(J.job_title,"미배정")
FROM emp E
	LEFT JOIN job J
		ON J.job_id = E.job_id
WHERE 1=1
AND E.emp_id IN (100,110,120,130,140)
;
-- TODO: 부서 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
SELECT
	D.dept_id "부서 ID"
    ,D.dept_name "부서 이름"
    ,IFNULL(E.tot_cnt,0) "직원 수"
FROM dept D
	LEFT JOIN (
				SELECT 
					dept_id
                    ,COUNT(*) "tot_cnt"
                FROM emp
                GROUP BY dept_id
                ) E
		ON D.dept_id = E.dept_id
ORDER BY E.tot_cnt DESC
;
DESC emp;
-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 모든 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy/mm/dd 형식으로 출력
SELECT
	E1.emp_id "직원 ID" 
    ,E1.emp_name "이름"
    ,E2.emp_name "상사이름"
    ,DATE_FORMAT(E1.hire_date,"%Y/%m/%d") "입사일"
FROM (
	SELECT *
	FROM emp
	WHERE dept_id = 90
) E1
LEFT JOIN emp E2
		ON E1.mgr_id = E2.emp_id
;
-- TODO 2003년~2005년 사이에 입사한 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
-- 상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
DESC emp;
SELECT
	E1.emp_id "직원 ID" 
    ,E1.emp_name "직원 이름"
    ,J.job_title "업무명"
    ,E1.salary "급여"
    ,E1.hire_date "입사일"
    ,E2.emp_name "상사이름"
    ,E2.hire_date "상사 입사일"
    ,D.dept_name "소속부서이름"
    ,D.loc "부서위치"
FROM (
		SELECT 
			emp_id
			,emp_name
			,salary
			,hire_date
            ,dept_id
            ,job_id
            ,mgr_id
		FROM emp
		WHERE YEAR(hire_date) BETWEEN 2003 AND 2005 ) E1
	LEFT JOIN job J
		ON E1.job_id = J.job_id
	LEFT JOIN emp E2
		ON E1.mgr_id = E2.emp_id
	LEFT JOIN dept D
		ON E1.dept_id = D.dept_id








