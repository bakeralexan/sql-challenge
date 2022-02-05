Database: employee_db

DROP DATABASE IF EXISTS employee_db;

CREATE DATABASE employee_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
CREATE TABLE departments (
    dept_no VARCHAR(255)  NOT NULL ,
    dept_name VARCHAR(255)  NOT NULL ,
    PRIMARY KEY (
        dept_no
    )
);
SELECT * FROM departments;

CREATE TABLE dept_employee (
    emp_no INTEGER  NOT NULL ,
    dept_no VARCHAR(255)  NOT NULL 
);
SELECT * FROM dept_employee;

CREATE TABLE dept_manager (
    dept_no VARCHAR(255)  NOT NULL ,
    emp_no INTEGER  NOT NULL 
);
SELECT * FROM dept_manager;

CREATE TABLE employees (
    emp_no INTEGER  NOT NULL ,
    emp_title_id VARCHAR(255)  NOT NULL ,
    birth_date DATE  NOT NULL ,
    first_name VARCHAR(255)  NOT NULL ,
    last_name VARCHAR(255)  NOT NULL ,
    sex VARCHAR(20)  NOT NULL ,
    hire_date DATE  NOT NULL ,
    PRIMARY KEY (
        emp_no
    )
);
SELECT * FROM employees;

CREATE TABLE salaries (
    emp_no INTEGER  NOT NULL ,
    salary INTEGER  NOT NULL 
);
SELECT * FROM salaries 

CREATE TABLE titles (
    title_id VARCHAR(255)  NOT NULL ,
    title VARCHAR(255)  NOT NULL ,
    PRIMARY KEY (
        title_id
    )
);
SELECT * FROM titles;

ALTER TABLE dept_employee ADD CONSTRAINT fk_dept_employee_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_employee ADD CONSTRAINT fk_dept_employee_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.
CREATE VIEW employee_list AS
SELECT salaries.emp_no,
	salaries.salary, 
	employees.first_name,
	employees.last_name,
	employees.sex
FROM employees
LEFT JOIN salaries
ON employees.emp_no = salaries.emp_no;
SELECT * FROM employee_list;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
CREATE VIEW hired_1986_list AS
SELECT 
	employees.first_name,
	employees.last_name,
	employees.hire_date
FROM employees
WHERE employees.hire_date BETWEEN '1986-01-01' AND '1986-12-31';
SELECT * FROM hired_1986_list;

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
CREATE VIEW manager_list AS
SELECT dept_manager.dept_no,
departments.dept_name, 
dept_manager.emp_no,
employees.last_name, 
employees.first_name 
FROM dept_manager
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no
INNER JOIN employees ON dept_manager.emp_no = employees.emp_no;
SELECT * FROM manager_list;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
CREATE VIEW dept_employee_list AS
SELECT
dept_employee.emp_no, 
employees.last_name, 
employees.first_name, 
departments.dept_name 
FROM dept_employee
INNER JOIN employees ON dept_employee.emp_no = employees.emp_no
INNER JOIN departments ON dept_employee.dept_no = departments.dept_no;
SELECT * FROM dept_employee_list;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
CREATE VIEW hercules_list AS
SELECT
employees.last_name, 
employees.first_name,
employees.sex
FROM employees
WHERE employees.first_name = 'Hercules' AND employees.last_name LIKE 'B%';
SELECT * FROM hercules_list;

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE VIEW sales_list AS
SELECT * FROM dept_employee_list WHERE dept_name = 'Sales';
SELECT * FROM sales_list;

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW sales_develop_list AS
SELECT * FROM dept_employee_list WHERE dept_name = 'Sales' OR dept_name = 'Development';
SELECT * FROM sales_develop_list;

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
CREATE VIEW last_name_frequency AS
SELECT last_name, COUNT(last_name) AS Frequency
FROM employees
GROUP BY last_name 
ORDER BY COUNT(last_name)  DESC;
SELECT * FROM last_name_frequency;

CREATE TABLE frequency();
SELECT * INTO frequency
FROM last_name_frequency;
SELECT * FROM frequency;