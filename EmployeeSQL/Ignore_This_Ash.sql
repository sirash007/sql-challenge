
-- Load data into departments table
COPY departments(dept_no, dept_name) 
FROM '/Users/ashwinpatel/departments.csv' DELIMITER ',' CSV HEADER;

-- Validate data loaded ok
--Select count(*) from departments  --9 records loaded.
COPY dept_emp(emp_no, dept_no, from_date, to_date) 
FROM '/Users/ashwinpatel/dept_emp.csv' DELIMITER ',' CSV HEADER;

--ALTER TABLE dept_emp ADD COLUMN tbl_index BIGSERIAL PRIMARY KEY; create a primary key

select * from dept_emp

--Do dept_manager
COPY dept_manager(dept_no, emp_no,  from_date, to_date) 
FROM '/Users/ashwinpatel/dept_manager.csv' DELIMITER ',' CSV HEADER;
/*
CREATE TABLE public.dept_manager
(
    dept_no character(4) COLLATE pg_catalog."default",
    from_date date,
    to_date date,
    tbl_index bigint NOT NULL DEFAULT nextval('dept_emp_tbl_index_seq'::regclass),
    emp_no integer,
    CONSTRAINT dept_manager_pkey PRIMARY KEY (tbl_index)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.dept_manager
*/
--load dept_manager
--Select * from dept_manager

-- Create employees table
CREATE TABLE public.employees
(
	emp_no integer,
    birth_date date,
	first_name character(30),
	last_name character(30),
	gender character(1),
    hire_date date,
   -- tbl_index bigint NOT NULL DEFAULT nextval('employee_tbl_index_seq'::regclass),
    CONSTRAINT employee_pkey PRIMARY KEY (emp_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.employees
OWNER to postgres;

--load employees table
COPY employees(emp_no, birth_date, first_name, last_name, gender, hire_date) 
FROM '/Users/ashwinpatel/employees.csv' DELIMITER ',' CSV HEADER;

select * from employees

--Salaries table start
CREATE TABLE public.salaries
(
	emp_no integer,
    salary money,
    from_date date,
	to_date date,
   -- tbl_index bigint NOT NULL DEFAULT nextval('employee_tbl_index_seq'::regclass),
    CONSTRAINT salary_pkey PRIMARY KEY (emp_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.salaries
OWNER to postgres;

COPY salaries2(emp_no, salary, from_date, to_date) 
FROM '/Users/ashwinpatel/salaries.csv' DELIMITER ',' CSV HEADER;
--Salaries table end
Select * from salaries
    
	--Salaries table start
CREATE TABLE public.titles
(
	emp_no integer,
    titles varchar(100),
    from_date date,
	to_date date
  -- tbl_index bigint NOT NULL DEFAULT nextval('titles_tbl_index_seq'::regclass),
  --  CONSTRAINT titles_pkey PRIMARY KEY (tbl_index)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.titles
OWNER to postgres;

COPY titles2(emp_no, title, from_date, to_date) 
FROM '/Users/ashwinpatel/titles.csv' DELIMITER ',' CSV HEADER;
--Salaries table end
Select count(*) from titles2
Select count(*) from titles

--add foreign keys
ALTER TABLE dept_emp 
ADD CONSTRAINT fk_deptemp FOREIGN KEY (dept_no) REFERENCES dept_emp(dept_no);

--dept_manager fix key and add foreign key
ALTER TABLE dept_manager DROP CONSTRAINT dept_manager_pkey;

CREATE UNIQUE INDEX dept_manager ON dept_manager(emp_no)

ALTER TABLE  dept_manager
  ADD CONSTRAINT dept_manager_pkey2
    PRIMARY KEY (emp_no)
ALTER TABLE dept_manager ADD PRIMARY KEY emp_no

ALTER TABLE dept_manager
    ADD CONSTRAINT fk_dept_mgrs FOREIGN KEY (dept_no) REFERENCES departments (dept_no);

ALTER TABLE dept_emp
    ADD CONSTRAINT fk_dept_emp FOREIGN KEY (dept_no) REFERENCES departments (dept_no);

ALTER TABLE dept_emp DROP CONSTRAINT 	dept_emp_pkey;

ALTER TABLE dept_emp
    ADD CONSTRAINT fk_emp_tbl FOREIGN KEY (emp_no) REFERENCES employees (emp_no);

ALTER TABLE dept_manager DROP CONSTRAINT 	dept_manager_pkey2;

ALTER TABLE dept_manager
    ADD CONSTRAINT fk_emp2_tbl FOREIGN KEY (emp_no) REFERENCES employees (emp_no);
--1. List the following details of each employee: employee number, last name, first name, gender, and salary.
Select 
emp.emp_no as "employee number"
,emp.last_name as "last name"
,emp.first_name as "first name"
,emp.gender as gender
,sal.salary as salary
from employees emp  --300,024 employees
left join salaries sal on emp.emp_no = sal.emp_no 
--2. List employees who were hired in 1986.
Select 
emp.emp_no as "employee number"
,emp.last_name as "last name"
,emp.first_name as "first name"
,emp.gender as gender
,emp.hire_date
from employees emp  --300,024 employees
Where emp.hire_date >= '1986-01-01'
and emp.hire_date <= '1986-12-31'
--3. List the manager of each department with the following information: department number, 
--department name, the manager's employee number, last name, first name, and start and end employment dates.

--Frpm dept_emp for each employee get the maximum to date for each employee
Create temp table emp_max_date
(emp_no integer, max_to_date date);
Insert into emp_max_date (emp_no, max_to_date)
Select emp_no,max(to_date) as max_to_date
from dept_emp
group by emp_no;


Select dep.dept_no, dep.dept_name, depmgr.emp_no as "Managers emp number", emp.last_name, emp.first_name, 
emp.hire_date as "start employment date", depemp.max_to_date as "end employment date",
depmgr.to_date
From departments dep
Inner Join dept_manager depmgr on dep.dept_no = depmgr.dept_no
Inner Join employees emp on emp.emp_no = depmgr.emp_no
Inner Join emp_max_date depemp on depemp.emp_no=depmgr.emp_no


--4. List the department of each employee with the following information: employee number, last name, 
--first name, and department name.
Select emp.emp_no, emp.last_name, emp.first_name, de.dept_no, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no

--5. List all employees whose first name is "Hercules" and last names begin with "B."
Select * from employees emp
where first_name = 'Hercules'
and left(last_name,1) = 'B'
--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
Select emp.emp_no, emp.last_name, emp.first_name, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no
where dep.dept_name = 'Sales'


--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
Select emp.emp_no, emp.last_name, emp.first_name, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no
where dep.dept_name in ('Sales', 'Development')

--8. In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
select last_name, count(*) count_of_last_name from employees
group by last_name order by 2 desc



select * from information_schema.tables
where table_schema = 'public'

COPY (
select table_schema,
       table_name,
       ordinal_position as position,
       column_name,
       data_type,
       case when character_maximum_length is not null
            then character_maximum_length
            else numeric_precision end as max_length,
       is_nullable,
       column_default as default_value
from information_schema.columns
where table_schema not in ('information_schema', 'pg_catalog')
order by table_schema, 
         table_name,
         ordinal_position
)
TO
'postgresoutput.csv' DELIMITER ',' CSV HEADER;
		 
		 
COPY (SELECT * FROM tracks WHERE genre_id = 6) TO '/Users/dave/Downblues_tracks.csv' DELIMITER ',' CSV HEADER;