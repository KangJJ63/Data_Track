/* ***********************************************
단일행 함수: 
	- 행별로 처리하는 함수. 문자/숫자/날짜/변환 함수 
	- 단일행은 select, where절에 사용가능
다중행 함수: 
	- 여러행을 묶어서 한번에 처리하는 함수 => 집계함수, 그룹함수라고 한다.
	- 다중행은 where절에는 사용할 수 없다. (sub query 이용) 
* ***********************************************/

/* ***************************************************************************************************************
# 함수 
- 문자열관련 함수
 char_length(v) - v의 글자수 반환
 concat(v1, v2[, ..]) - 값들을 합쳐 하나의 문자열로 반환
 format(숫자, 소수부 자릿수) - 정수부에 단위 구분자 "," 를 표시하고 지정한 소수부 자리까지만 문자열로 만들어 반환
 upper(v), lower(v) - v를 모두 대문자/소문자 로 변환
 insert(기준문자열, 위치, 길이, 삽입문자열): 위치기준으로 변경. 기준문자열의 위치(1부터 시작)에서부터 길이까지 지우고 삽입문자열을 넣는다.
 replace(기준문자열, 원래문자열, 바꿀문자열): 문자열기준으로 변경. 기준문자열의 원래문자열을 바꿀문자열로 바꾼다.
 left(기준문자열, 길이), right(기준문자열, 길이): 기준문자열에서 왼쪽(left), 오른쪽(right)의 길이만큼의 문자열을 반환한다.
 substring(기준문자열, 시작위치, 길이): 기준문자열에서 시작위치부터 길이 개수의 글자 만큼 잘라서 반환한다. 길이를 생략하면 마지막까지 잘라낸다.
 substring_index(기준문자열, 구분자, 개수): 기준문자열을 구분자를 기준으로 나눈 뒤 개수만큼 반환. 개수: 양수 – 앞에서 부터 개수,  음수 – 뒤에서 부터 개수만큼 반환
 ltrim(문자열), rtrim(문자열), trim(문자열): 문자열에서 왼쪽(ltrim), 오른쪽(rtrim), 양쪽(trim)의 공백을 제거한다. 중간공백은 유지
 trim(방향  제거할문자열  from 기준문자열): 기준문자열에서 방향에 있는 제거할문자열을 제거한다.
								   방향: both (앞,뒤), leading (앞), trailing (뒤)
 lpad(기준문자열, 길이, 채울문자열), rpad(기준문자열, 길이, 채울문자열): 기준문자열을 길이만큼 늘린 뒤 남는 길이만큼 채울문자열로 왼쪽(lpad), 오른쪽(rpad)에 채운다.
													   기준문자열 글자수가 길이보다 많을 경우 나머지는 자른다.
*************************************************************************************************************** */
SELECT
	CHAR_LENGTH('abcdefg') -- 글자수  
;
SELECT
	UPPER('aaaaa')
    ,LOWER("BBBBBB")
;
SELECT
	FORMAT(312001000,0)
;
SELECT
	FORMAT(1020202.982929,3)
;
SELECT
	CONCAT("$",format(1032.229,2))
;
SELECT
	REPLACE("aaaabbcccc","aaa","XXX") -- 변경 함수 (전체 대상, '변경할대상','변경 후')
;
SELECT
	LEFT('1234567890',5) -- 왼쪽 5글자까지만
    ,RIGHT('1234567890',3) -- 오른쪽 3글자까지만
;
SELECT 
	SUBSTR('123456',3,2) -- 3번째부터 2글자
;
SET @a ="         123          " ;
SELECT
	@a "문자"
	,CHAR_LENGTH(@a) "문자 길이"
    ,CHAR_LENGTH(RTRIM(@a)) "오른쪽 공백제거 문자 길이"
    ,CHAR_LENGTH(LTRIM(@a)) "왼쪽 공백제거 문자 길이"
;
SELECT
	LPAD('abc',10,'+') -- 글자수를 10개로 맞춤. 왼쪽여백은  '+'로 채움.
    ,RPAD('TEST',9,'_') -- 글자수를 9개로 맞추고, 여백은 _로 채움
;
SELECT
	LPAD("abcdefg",2,"+") -- 문자길이가 더길면, 자리수만큼만 자름.
;

-- EMP 테이블에서y 직원의 이름(emp_name)을 모두 대문자, 소문자, 이름 글자수를 조회
SELECT
	emp_name
	,UPPER(emp_name) "대문자"
    ,LOWER(emp_name) "소문자"
    ,CHAR_LENGTH(emp_name) "글자수"
FROM emp
ORDER BY 4
;

--  TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary),부서(dept_name)를 조회. 
--  단 직원이름(emp_name)은 모두 대문자, 부서(dept_name)는 모두 소문자로 출력.


-- TODO: 직원 이름(emp_name) 의 자릿수를 15자리로 맞추고 15자가 안되는 이름의 경우  공백을 앞에 붙여 조회. 

    
--  TODO: EMP 테이블에서 이름(emp_name)이 10글자 이상인 직원들의 이름(emp_name)과 이름의 글자수 조회



/* **************************************************************************

- 숫자관련 함수
 abs(값): 절대값 반환
 round(값, 자릿수): 자릿수이하에서 반올림 (양수 - 실수부, 음수 - 정수부, 기본값: 0-0이하에서 반올림이므로 정수로 반올림)
 truncate(값, 자릿수): 자릿수이하에서 절삭-버림(자릿수: 양수 - 실수부, 음수 - 정수부, 기본값: 0)
 ceil(값): 값보다 큰 정수중 가장 작은 정수. 소숫점 이하 올린다. 
 floor(값): 값보다 작은 정수중 가장 작은 정수. 소숫점 이하를 버린다. 내림
 sign(값): 숫자 n의 부호를 정수로 반환(1-양수, 0, -1-음수)
 mod(n1, n2): n1 % n2

************************************************************************** */
SELECT ABS(-10)
;
SELECT 
	SIGN(10)
    ,SIGN(0)
    ,SIGN(-100)
;
SET @num = 98765.123456789;
SELECT 
	ROUND(@num,3) -- 반올림 : round(숫자,자릿수) => 3자리 이하에서 반올림 
	,ROUND(@num,0) -- 정수로 반올림
    ,ROUND(@num,-2) -- 정수 2번째 자리에서 반올림
    ,TRUNCATE(@num,2) -- 2번째 이하 절삭
    ,TRUNCATE(@num,-1) -- 정수 첫번째부터 절삭ㅐ
;

-- TODO: EMP 테이블에서 각 직원에 대해 직원ID(emp_id), 이름(emp_name), 급여(salary) 그리고 15% 인상된 급여(salary)를 조회하는 질의를 작성하시오.
-- (단, 15% 인상된 급여는 올림해서 정수로 표시하고, 별칭을 "SAL_RAISE"로 지정.)



-- TODO: 위의 SQL문에서 인상 급여(sal_raise)와 급여(salary) 간의 차액을 추가로 조회 
-- (직원ID(emp_id), 이름(emp_name), 15% 인상급여, 인상된 급여와 기존 급여(salary)와 차액)



--  TODO: EMP 테이블에서 커미션이 있는 직원들의 직원_ID(emp_id), 이름(emp_name), 커미션비율(comm_pct), 커미션비율(comm_pct)을 8% 인상한 결과를 조회.
-- (단 커미션을 8% 인상한 결과는 소숫점 이하 2자리에서 반올림하고 별칭은 comm_raise로 지정)



/* ***************************************************************************************************************
- 날짜관련 함수
 
 now(): 현재 datetime
 curdate(): 현재 date
 curtime(): 현재 time
 year(날짜), month(날짜), day(날짜): 날짜 또는 일시의 년, 월, 일 을 반환한다.
 hour(시간), minute(시간), second(시간), microsecond(시간): 시간 또는 일시의 시, 분, 초, 밀리초를 반환한다.
 date(), time(): datetime 에서 날짜(date), 시간(time)만 추출한다.
 
 날짜 연산
 adddate/subdate(DATETIME/DATE/TIME,  INTERVAL 값  단위)
 	- 날짜에서 특정 일시만큼 더하고(add) 빼는(sub) 함수.
    - 단위: MICROSECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER(분기-3개월), YEAR
 
 datediff(날짜1, 날짜2): 날짜1 – 날짜2한 일수를 반환
 timediff(시간1, 시간2): 시간1-시간2 한 시간을 계산해서 반환 (뺀 결과를 시:분:초 로 반환)
 dayofweek(날짜): 날짜의 요일을 정수로 반환 (1: 일요일 ~ 7: 토요일)

 date_format(일시, 형식문자열): 일시를 원하는 형식의 문자열로 반환
*************************************************************************************************************** */
-- 실행시점의 일/시를 조회 함수
SELECT
	NOW()
    ,CURDATE()
    ,CURTIME()
;
-- 날짜 타입에서 년 월 일 조회
SELECT
	YEAR(CURDATE())
    ,MONTH(CURDATE())
    ,DAY(CURDATE())
;

-- 시간 타입에서 시 분 초 조회
SELECT
	HOUR(CURTIME())
    ,MINUTE(CURTIME())
    ,SECOND(CURTIME())
    ,MICROSECOND(CURTIME())
;

-- 특정 기간 만큼 전,후의 일시를 조회
-- 오늘 기준 3일 후
SELECT
	ADDDATE(CURDATE(),INTERVAL 3 DAY)
;
SELECT 
	ADDDATE(NOW(),INTERVAL 3 DAY)
;
-- 오늘 기준 일주일 전
SELECT
	SUBDATE(CURDATE(),INTERVAL 7 DAY)
    ,ADDDATE(CURDATE(), INTERVAL -7 DAY)
;

-- 2년전 날짜
SELECT
	SUBDATE(NOW(),INTERVAL 2 YEAR)
    ,ADDDATE(NOW(),INTERVAL -2 YEAR)
;
-- 2년 5개월 후의 날짜
SELECT
	adddate(CURDATE(),INTERVAL '2-5' YEAR_MONTH)
;

-- 35시간 25분 전
SELECT
	SUBDATE(NOW(),INTERVAL "35:25" HOUR_MINUTE)
;

SET @val = "2023-10-10 12:30:20";
SELECT
	DATEDIFF(CURDATE(),@val) -- 두 날짜의 일수 차이 
    ,TIMEDIFF(NOW(),@val) -- 차이를 시간:분:초 로 나타냄
;

SELECT 
	DAYOFWEEK(NOW()) -- 1-7 : 일 ~ 토
    ,DAYOFWEEK('2000-10-23')
    ,DAYOFWEEK(@val)
;
SELECT 
	DATE_FORMAT(NOW(),"%Y년 %m월 %d일 %H시 %i분 %s초 %W %p")
;

-- TODO: EMP 테이블에서 부서이름(dept_name)이 'IT'인 직원들의 '입사일(hire_date)로 부터 10일전', 입사일, '입사일로 부터 10일 후' 의 날짜를 조회. 
-- select adddate(hire_date, interval -10 day), hire_date, adddate(hire_date, interval 10 day)


-- TODO: 부서가 'Purchasing' 인 직원의 이름(emp_name), 입사 6개월전과 입사일(hire_date), 6개월후 날짜를 조회.


-- TODO ID(emp_id)가 200인 직원의 이름(emp_name), 입사일(hire_date)를 조회. 입사일은 yyyy년 mm월 dd일 형식으로 출력.


--  TODO: 각 직원의 이름(emp_name), 근무 개월수 (입사일에서 현재까지의 달 수)를 계산하여 조회. 근무개월수 내림차순으로 정렬.
SELECT 
	emp_name "직원 이름"
    ,hire_date "고용 일자"
   ,PERIOD_DIFF(DATE_FORMAT(CURDATE(),"%Y%m"),DATE_FORMAT(hire_date,"%Y%m")) as months
FROM emp
ORDER BY months DESC
;




/* *************************************************************************************
함수 - 조건 처리함수
ifnull (기준컬럼(값), 기본값): 기준컬럼(값)이 NULL값이면 기본값을 출력하고 NULL이 아니면 기준컬럼 값을 출력
if (조건수식, 참, 거짓): 조건수식이 True이면 참을 False이면 거짓을 출력한다.
************************************************************************************* */
DESCRIBE emp;
SELECT 
	IFNULL('a','default') 
;
SELECT
	IFNULL(NULL,'XX')
;
SELECT IFNULL(comm_pct,"X")
FROM emp
;



-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)을 조회. 부서가 없는 경우 '부서미배치'를 출력.


-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션 (salary * comm_pct)을 조회. 커미션이 없는 직원은 0이 조회되록 한다.



/***********************************************
함수 - 타입변환함수
cast(값 as 변환할타입)
convert(값, 변환할타입)

변환가능 타입
  - BINARY: binary 데이터로 변환 (blob)
  - SIGNED: 부호있는 정수(64bit)
  - UNSIGNED: 부호없는 정수(64bit)
  - DECIMAL: 실수
  - CHAR: 문자열 타입 
  - DATE: 날짜 
  - TIME: 시간
  - DATATIME: 날짜시간 타입
	- 정수를 날짜, 시간타입으로 변환할 때는 양수만 가능. (음수는 NULL 반환)
***********************************************/
SELECT
	'10'+'10'
;
-- 시간을 정수형태로 변환   
SELECT
	CAST(NOW() AS SIGNED)
;
SELECT 
	CONVERT(CURDATE(),SIGNED)
;

-- 숫자를 날짜로 변환
SELECT 
	CAST(20231231 AS DATE)
    ,CONVERT(20231231 ,DATE)
;

SELECT
	CONVERT('2023-01-01' , DATE)
;

SELECT *
FROM emp
WHERE 1=1
AND hire_date = CONVERT('2003-06-17',DATE)
;

-- 숫자를 문자열로 변환
SELECT
	CAST(2000 AS CHAR)
;

/* *************************************
CASE 문
case문 동등비교
case 컬럼 when 비교값 then 출력값
              [when 비교값 then 출력값]
              [else 출력값]
              end
              
case문 조건문
case when 조건 then 출력값
       [when 조건 then 출력값]
       [else 출력값]
       end

************************************* */
SELECT
  CASE WHEN "IT" then "전산실"
			WHEN 'Finance'THEN "회계부"
            WHEN "Sales" THEN "영업부"
            -- ELSE dept_name END -- "부서"
            ELSE IFNULL(dept_name,'미배치') END "부서" 
FROM emp;




-- EMP테이블에서 급여와 급여의 등급을 조회하는데 급여 등급은 10000이상이면 '1등급', 10000미만이면 '2등급' 으로 나오도록 조회
SELECT 
	CASE WHEN salary >= 10000 
		THEN "1등급"
		ELSE '2등급' 
	END "급여등급"
FROM emp;

SELECT
  	IF(salary >= 10000,"1등급","2등급") "급여 등급"
FROM emp
;

-- TODO: EMP 테이블에서 업무(job)이 'AD_PRES'거나 'FI_ACCOUNT'거나 'PU_CLERK'인 직원들의 ID(emp_id), 이름(emp_name), 업무(job)을 조회.  
-- 업무(job)가 'AD_PRES'는 '대표', 'FI_ACCOUNT'는 '회계', 'PU_CLERK'의 경우 '구매'가 출력되도록 조회


-- TODO: EMP 테이블에서 부서이름(dept_name)과 급여 인상분을 조회.
-- 급여 인상분은 부서이름이 'IT' 이면 급여(salary)에 10%를 'Shipping' 이면 급여(salary)의 20%를 'Finance'이면 30%를 나머지는 0을 출력



-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 인상된 급여를 조회한다. 
-- 단 급여 인상율은 급여가 5000 미만은 30%, 5000이상 10000 미만는 20% 10000 이상은 10% 로 한다.

