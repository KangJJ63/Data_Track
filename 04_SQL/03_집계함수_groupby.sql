/* **************************************************************************
집계(Aggregation) 함수와 GROUP BY, HAVING
************************************************************************** */
use test;
select salary from emp;
/* ******************************************************************************************
# 집계함수, 그룹함수, 다중행 함수

- 인수(argument)는 컬럼.
  - sum(): 전체합계
  - avg(): 평균
  - min(): 최소값
  - max(): 최대값
  - stddev(): 표준편차
  - variance(): 분산
  - count(): 개수 ==> 행수
        - 인수: 
            - 컬럼명: null을 제외한 값들의 개수.
            -  *: 총 행수 - null과 관계 없이 센다.
  - count(distinct 컬럼명): 고유값의 개수.
  
- count(*) 를 제외한 모든 집계함수들은 null을 제외하고 집계한다. 
	- (avg, stddev, variance는 주의)
	- avg(), variance(), stddev()은 전체 개수가 아니라 null을 제외한 값들의 평균, 분산, 표준편차값이 된다.=>avg(ifnull(컬럼, 0))
- 문자타입/일시타입: max(), min(), count()에만 사용가능
	- 문자열 컬럼의 max(): 사전식 배열에서 가장 마지막 문자열, min()은 첫번째 문자열. 
	- 일시타입 컬럼은 오래된 값일 수록 작은 값이다.

******************************************************************************************* */
select count(distinct job) from emp;

select count(comm_pct), count(emp_id), 
	  avg(comm_pct), avg(ifnull(comm_pct, 0))
from emp;
-- EMP 테이블에서 급여(salary)의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 총직원수를 조회 
select  sum(salary) "총합계",
		round(avg(salary), 2) "평균",            -- null 을 제거하고 계산.
        round(avg(ifnull(salary, 0)), 2) "평균2", -- null을 0으로 바꾼뒤 계산.
        min(salary) "최소값",
        max(salary) "최대값",
        round(stddev(salary), 2) "표준편차",
        round(variance(salary), 2) "분산", 
        count(salary) "급여가 있는 직원",
        count(*) "총행수"
from emp;
-- EMP 테이블에서 가장 최근 입사일(hire_date)과 가장 오래된 입사일을 조회
select  min(hire_date), 
		max(hire_date)
from emp;

select 'a' < 'b';

select cast('2020-10-10' as date) < cast('2022-10-10' as date) "aaa";

-- EMP 테이블의 부서(dept_name) 의 개수를 조회
select  count(dept_name),
		count(ifnull(dept_name, '1')),
        count(*)
from   emp;

-- EMP 테이블에서 job 종류의 개수 조회
select count(distinct job) from emp;

-- TODO:  커미션 비율(comm_pct)이 있는 직원의 수를 조회
SELECT 
	COUNT(comm_pct)
FROM emp
;
-- TODO:  커미션 비율(comm_pct)의 평균을 조회. 
SELECT
	AVG(comm_pct) "커미션 비율"
FROM emp
;
-- TODO: 급여(salary)에서 최고 급여액과 최저 급여액의 차액을 출력
SELECT
	MAX(salary) - MIN(salary) "최고 급여액과 최저 급여액의 차액"
FROM emp
;
-- TODO: 가장 긴 이름(emp_name)이 몇글자 인지 조회.
SELECT 
	MAX(CHAR_LENGTH(emp_name))
FROM emp
;
-- TODO: EMP 테이블의 부서(dept_name)가 몇종류가 있는지 조회. 
SELECT
	COUNT(DISTINCT dept_name)
    
FROM emp
;

/* **************
group by 절
- 특정 컬럼(들)의 값별로 행들을 나누어 집계할 때 기준컬럼을 지정하는 구문.
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균
- 구문: group by 컬럼명 [, 컬럼명]
	- 컬럼: 범주형 컬럼을 사용 - 부서별 급여 평균, 성별 급여 합계
	- select의 where 절 다음에 기술한다.
	- select 절에는 group by 에서 선언한 컬럼들만 집계함수와 같이 올 수 있다.
	
****************/
-- 업무(job)별 급여의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 직원수를 조회
-- 집계 할 때 select 절에 올 수 있는 컬럼 - 그룹으로 묶을때 사용한 컬럼만 가능.
select  job,
	    sum(salary) "합계", 
		round(avg(salary), 2) "평균",
        min(salary) "최소",
        max(salary) "최대",
        round(stddev(salary),2) "표준편차",
        round(variance(salary), 2) "분산",
        count(*) "직원수-행수"
from    emp
group by job; -- 업무별 집계 ==> job컬럼의 값이 같은 행들이 하나의 그룹으로 묶인다.
        

select count(distinct job) from emp;

-- 입사연도 별 직원들의 급여 평균.
select 	round(avg(salary), 2) "평균급여", 
		year(hire_date) "입사년도"
from   emp
group by year(hire_date)
order by 1;

-- 부서명(dept_name) 이 'Sales'이거나 'Purchasing' 인 직원들의 업무별 (job) 직원수를 조회
select job, count(*)
from   emp
where  dept_name in ('Sales', 'Purchasing')
group by job;

-- 부서(dept_name), 업무(job) 별 최대, 평균급여(salary)를 조회.
select  dept_name, 
		job,
        avg(salary)
from    emp
group by dept_name, job;

-- 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.
select  if(salary>=10000, '만달러 이상', '만달러 미만'),
		avg(salary)
from   emp
group by if(salary>=10000, '만달러 이상', '만달러 미만');


-- TODO: 부서별(dept_name) 직원수를 조회
SELECT
	dept_name
    ,COUNT(*)
FROM emp
GROUP BY dept_name
;
-- TODO: 업무별(job) 직원수를 조회. 직원수가 많은 것부터 정렬.
SELECT
	job
    ,COUNT(*) "cnt"
FROM emp
GROUP BY job
ORDER BY cnt DESC
;
-- TODO: 부서명(dept_name), 업무(job)별 직원수, 최고급여(salary)를 조회. 부서이름으로 오름차순 정렬.
SELECT 
	dept_name
    ,job
	,COUNT(*) "cnt"
    ,MAX(salary) "max_salary"
FROM emp
GROUP BY dept_name
		,job
ORDER BY job
;
-- TODO: EMP 테이블에서 입사연도별(hire_date) 총 급여(salary)의 합계을 조회. 
-- (급여 합계는 정수부에 자리구분자 , 를 넣고 $를 붙이시오. ex: $2,000,000)
SELECT
	YEAR(hire_date) "year"
    ,CONCAT('$',FORMAT(SUM(salary),0)) "sum_salary"
FROM emp
GROUP BY YEAR(hire_date)
ORDER BY year;
;
-- TODO: 같은해 입사해서 같은 업무를 한 직원들의 평균 급여(salary)을 조회
SELECT
	YEAR(hire_date)
    ,job
    ,FORMAT(AVG(salary),2) "salary_avg"
FROM emp
GROUP BY YEAR(hire_date) 
		,job
;

-- TODO: 부서별(dept_name) 직원수 조회하는데 부서명(dept_name)이 null인 것은 제외하고 조회.
SELECT
	dept_name
	,COUNT(*)
FROM emp
WHERE 1=1
AND dept_name IS NOT NULL
GROUP BY dept_name
;
-- TODO 급여 범위별 직원수를 출력. 급여 범위는 5000 미만, 5000이상 10000 미만, 10000이상 20000미만, 20000이상. 
-- case 문 이용
SELECT
	CASE 
			WHEN salary >= 20000 THEN "20000이상"
            WHEN salary >= 10000 THEN  "10000이상"
            WHEN salary >= 5000 THEN "5000이상"
            ELSE "5000미만" END "급여 범위"
	,COUNT(*)
FROM emp
WHERE 1=1
GROUP BY CASE 
			WHEN salary >= 20000 THEN "20000이상"
            WHEN salary >= 10000 THEN  "10000이상"
            WHEN salary >= 5000 THEN "5000이상"
            ELSE "5000미만" END
			;	

SELECT 
	salary_grp "급여 범위"
    ,COUNT(rn) "직원 수"
FROM (
	SELECT
		1 "rn"
		,CASE WHEN salary >= 20000 THEN "20000이상"
				WHEN salary >= 10000 THEN  "10000이상"
				WHEN salary >= 5000 THEN "5000이상"
				ELSE "5000미만" END "salary_grp"
	FROM emp
) A
GROUP BY salary_grp
;
SELECT
	job
    ,COUNT(*) "직원 수"
FROM emp
GROUP BY job WITH ROLLUP  -- 마지막 행에 총 값을 붙여줌. 
;

/* **************************************************************
having 절
- group by 로 나뉜 그룹을 filtering 하기 위한 조건을 정의하는 구문.
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  
		- 연산자는 where절의 연산자를 사용한다. 
		- 피연산자는 집계함수(의 결과)
		
** where절은 행을 filtering한다.
   having절은 group by 로 묶인 그룹들을 filtering한다.		
************************************************************** */

-- 직원수가 10 이상인 부서의 부서명(dept_name)과 직원수를 조회
SELECT 
	dept_name
    ,COUNT(*)
FROM emp
GROUP BY  dept_name
HAVING COUNT(*) >= 10
;
-- 직원수가 10명 이상인 부서의 부서명과 그 부서 직원들의 평균 급여를 조회.
SELECT
	dept_name
    ,AVG(salary) "평균 급여"
FROM emp
GROUP BY dept_name
HAVING COUNT(*) >= 10
;
-- TODO: 20명 이상이 입사한 년도와 (그 해에) 입사한 직원수를 조회.
SELECT
	YEAR(hire_date)
    ,COUNT(*)
FROM emp
GROUP BY YEAR(hire_date)
HAVING COUNT(*) >= 20
;
-- TODO: 평균 급여가(salary) $5000 이상인 부서의 이름(dept_name)과 평균 급여(salary), 직원수를 조회
SELECT
	dept_name
    ,FORMAT(AVG(salary),2) "평균 급여"
    ,COUNT(*) "직원수"
FROM emp
GROUP BY dept_name
HAVING AVG(salary) >= 5000
;
-- TODO: 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
SELECT 
	dept_name "부서 이름"
    ,FORMAT(AVG(salary),2) "평균 급여"
    ,FORMAT(SUM(salary),2) "총 급여"
FROM emp
GROUP BY dept_name
HAVING AVG(salary) >= 5000
AND SUM(salary) >= 50000
;
-- TODO  커미션이 있는 직원들의 입사년도별 평균 급여를 조회. 단 평균 급여가 $9,000 이상인 년도분만 조회.
SELECT
	YEAR(hire_date)
    ,FORMAT(AVG(salary),2) "평균 급여"
FROM emp
WHERE comm_pct IS NOT NULL
GROUP BY YEAR(hire_date)
HAVING AVG(salary) >= 9000
;


