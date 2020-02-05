
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

COPY salaries(emp_no, salary, from_date, to_date) 
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

COPY titles(emp_no, title, from_date, to_date) 
FROM '/Users/ashwinpatel/titles.csv' DELIMITER ',' CSV HEADER;
--Salaries table end
Select * from titles

--add foreign keys
ALTER TABLE dept_emp 
ADD CONSTRAINT fk_deptemp FOREIGN KEY (dept_no) REFERENCES dept_emp(dept_no);