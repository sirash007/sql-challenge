--1. List the following details of each employee: employee number, last name, 
--first name, gender, and salary.
--1 Start
Select 
emp.emp_no as "employee number"
,emp.last_name as "last name"
,emp.first_name as "first name"
,emp.gender as gender
,sal.salary as salary
from employees emp  --300,024 employees
Inner join salaries sal on emp.emp_no = sal.emp_no 

-- 1 end 

--2. List employees who were hired in 1986.

--2. start
Select distinct
emp.emp_no as "employee number"
,emp.last_name as "last name"
,emp.first_name as "first name"
,emp.gender as gender
,emp.hire_date
from employees emp  --300,024 employees
Where emp.hire_date >= '1986-01-01'
and emp.hire_date <= '1986-12-31'

--2. end


--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, 
--first name, and start and end employment dates.
--3 Start
--From dept_emp for each employee get the maximum to date for each employee
Create temp table emp_max_date
(emp_no integer, max_to_date date);
Insert into emp_max_date (emp_no, max_to_date)
Select emp_no,max(to_date) as max_to_date
from dept_emp
group by emp_no;


Select dep.dept_no, dep.dept_name, depmgr.emp_no as "Managers emp number", emp.last_name, emp.first_name, 
emp.hire_date as "start employment date", 
--depemp.max_to_date as "end employment date",
depmgr.to_date  as "end employment date"
From departments dep
Inner Join dept_manager depmgr on dep.dept_no = depmgr.dept_no
Inner Join employees emp on emp.emp_no = depmgr.emp_no
Inner Join emp_max_date depemp on depemp.emp_no=depmgr.emp_no

--3 End


--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

--4. start
--use the temp table in 3 above to get the max employment date for each employee
Select emp.emp_no, emp.last_name, emp.first_name, de.dept_no, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no
--4. end
--5. List all employees whose first name is "Hercules" and last names begin with "B."
--5 start

Select * from employees emp
where first_name = 'Hercules'
and left(last_name,1) = 'B'


--5 end

--6. List all employees in the Sales department, 
--including their employee number, last name, first name, and department name.
--6 start

Select emp.emp_no, emp.last_name, emp.first_name, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no
where dep.dept_name = 'Sales'
--6 end


--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

--7 Start

Select emp.emp_no, emp.last_name, emp.first_name, dep.dept_name
from employees emp
Inner Join emp_max_date depemp on depemp.emp_no=emp.emp_no
inner join dept_emp de on de.emp_no = emp.emp_no and de.to_date = depemp.max_to_date
inner join departments dep on dep.dept_no = de.dept_no
where dep.dept_name in ('Sales', 'Development')

--7 End

--8. In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
--8 Start
select last_name, count(*) count_of_last_name from employees
group by last_name order by 2 desc


--8 end


