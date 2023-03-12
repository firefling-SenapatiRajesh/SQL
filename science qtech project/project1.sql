create database employee;
use employee;
alter table emp_record_table
change column PROJECT_ID PROJECT_ID TEXT;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER,DEPT
from emp_record_table;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table
where EMP_RATING<2;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table
where EMP_RATING>4;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table
where EMP_RATING BETWEEN 2 AND 4;

SELECT concat(FIRST_NAME," ",LAST_NAME) AS NAME FROM emp_record_table where dept="Finance";

select m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE, m.EXP, count(e.EMP_ID) as "EMP_COUNT" from emp_record_table
m inner join emp_record_table e on m.EMP_ID=e.MANAGER_ID group by m.EMP_ID order by m.EMP_ID;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table where DEPT="Healthcare" union
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table where DEPT= "Finance";

select m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE, m.DEPT, m.EMP_RATING,max(m.EMP_RATING) over(partition by m.DEPT)
as "MAX_DEPT_RATING"from emp_record_table m order by DEPT;

select distinct(ROLE) from emp_record_table;

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, max(SALARY), min(SALARY) from emp_record_table 
where ROLE IN("PRESIDENT",'LEAD DATA SCIENTIST','SENIOR DATA SCIENTIST','MANAGER', 'ASSOCIATE', 'DATA SCIENTIST','JUNIOR DATA SCIENTIST')
group by ROLE;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, RANK() over(order by EXP) EXP_RANK from emp_record_table;

create view employees_in_various_countries as select EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY,SALARY from emp_record_table
where SALARY>6000;

select EMP_ID, FIRST_NAME, LAST_NAME, EXP from emp_record_table where EMP_ID in(select MANAGER_ID from emp_record_table);

DELIMITER //
create procedure get_experience_details()
begin
	select EMP_ID, FIRST_NAME, LAST_NAME,EXP from emp_record_table where EXP>3;
END //

CALL get_experience_details();

DELIMITER //
create function Employee_Role(EXP int)
returns varchar(40)
deterministic
begin
declare Employee_Role varchar(40);
IF EXP>12 and 16 then set Employee_Role="MANAGER";
elseif EXP>10 AND 12 THEN set Employee_Role='LEAD DATA SCIENTIST';
elseif EXP>5 and 10 then set Employee_Role='SENIOR DATA SCIENTIST';
elseif EXP>2 and 5 then set Employee_Role='ASSOCIATE DATA SCIENTIST';
elseif EXP<2 then set Employee_Role='JUNIOR DATA SCIENTIST';
end if;
return (Employee_Role);
End //

select FIRST_NAME,LAST_NAME,EXP,Employee_Role(EXP) from data_science_team;

CREATE INDEX idx_first_name
on emp_record_table(FIRST_NAME(20));
select * from emp_record_table where FIRST_NAME='Eric';

alter table emp_record_table
drop index idx_first_name;



update emp_record_table set SALARY=select SALARY +(select SALARY*.05*EMP_RATING)
SELECT *FROM emp_record_table;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,SALARY,COUNTRY,CONTINENT,AVG(SALARY) OVER(partition by COUNTRY)AVG_Salary_IN_Country,
avg(SALARY)over(partition by CONTINENT)AVG_Salary_IN_Continent,
count(*) over(partition by COUNTRY)COUNT_IN_COUNTRY,
COUNT(*)OVER(PARTITION BY CONTINENT)COUNT_IN_CONTINENT,
FROM emp_record_table;














