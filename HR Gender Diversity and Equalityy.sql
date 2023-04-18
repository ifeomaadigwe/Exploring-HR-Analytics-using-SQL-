--- On this repository, I would be working on a HR Dataset. the dataset has been uploaded into my desire data-
--- base to be analysed. I have also noticed that some columns are wrongly spelt and must
--- be cleaned or corrected to enable us have a relevant and accurate datastet.eg- annualsalary column


-- To remove the ($)
    
SELECT 
    EmployeeID, 
    name, 
    department, 
    REPLACE("annualsalary($)", '$', '') AS annual_salary 
FROM 
    HRdata4;
    


CREATE TEMPORARY TABLE temp_hr_data AS 
    SELECT 
        EmployeeID, 
        name, 
        department, 
        REPLACE ("annualsalary($)", '$', '') AS annual_salary     
    FROM 
        HRdata4;



--- go through the whole dataset
SELECT *
FROM HRdata4



---1.  What is the gender ratio in our organization?
SELECT 
    EXTRACT(YEAR FROM hire_date) AS hire_year, 
    gender, 
    COUNT(*) AS count, 
    COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY EXTRACT(YEAR FROM hire_date)) AS ratio 
FROM 
    HRdata4 
GROUP BY 
    EXTRACT(YEAR FROM hire_date), 
    gender



--- 2. What is the age distribution of all the employees?
SELECT 
    FLOOR(age / 10) * 10 AS Age_Group, 
    COUNT(*) AS count 
FROM 
    (
        SELECT 
            employeeid, 
            DATEDIFF('year', dob, CURRENT_DATE) AS Age 
        FROM 
            HRdata4 
    ) AS Age_Data 
GROUP BY 
    FLOOR(age / 10) * 10 
    


---3. Retrieve the average salary for all employees by department?
SELECT 
    department, 
    AVG(annual_salary) AS avg_salary 
FROM 
    temp_hr_data 
GROUP BY 
    department;
    


--- 4. How has employee satisfaction changed over time by department?   
SELECT 
    department, 
    strftime('%Y', hiredate) AS hire_year, 
    AVG(employeesatisfaction) AS avg_satisfaction 
FROM 
    HRdata4 
GROUP BY 
    department, 
    hire_year 
ORDER BY 
    hire_year, 
    department;



--b--   
SELECT 
    department, 
    strftime('%Y', hiredate) AS hire_year, 
    AVG(employeesatisfaction) AS avg_satisfaction, 
    AVG(empage) AS avg_age, 
    AVG(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_ratio, 
    AVG(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_ratio, 
    AVG(CASE WHEN jobtitle LIKE '%Manager%' THEN 1 ELSE 0 END) AS manager_ratio 
FROM 
    HRdata4 
GROUP BY 
    department, 
    hire_year 
ORDER BY 
    hire_year, 
    department;



----5. What is the average tenure of employees in the organization?
SELECT AVG(DATEDIFF(CURRENT_DATE, hire_date)) AS avg_tenure
FROM HRdata4;



---6. which job title has the highest total compensation
SELECT jobtitle, SUM(totalcompensation) AS total_compensation
FROM HRdata4
GROUP BY jobtitle
ORDER BY total_compensation DESC
LIMIT 1;



----7.  What is the average performance rating for employees in each department
SELECT department, AVG(performance) AS avg_performance
FROM HRdata4
GROUP BY department;



----8.  What is the average bonus payout for all employees
SELECT AVG(bonus) AS avg_bonus_payout
FROM HRdata4;



----9. Retrieve the average age of employees within each department
SELECT department, AVG(employee_age) AS avg_age
FROM HRdata4
GROUP BY department;



----10. How is marital status distributed each year by department?
SELECT strftime('%Y', hire_date) AS year, department, marital_status, COUNT(*) AS count
FROM HRdata4
GROUP BY year, department, marital_status;



---11. what branch had the most or fewest new hires each year?
SELECT strftime('%Y', hire_date) AS year, branch, COUNT(*) AS count
FROM HRdata4
GROUP BY year, branch
ORDER BY year, count DESC;



---12. Retrieve the job titles with the lowest and highest salary each year?
SELECT strftime('%Y', hire_date) AS year, job_title, MIN(annual_salary) AS lowest_salary, MAX(annual_salary) 
AS highest_salary
FROM HRdata4
GROUP BY year, job_title
ORDER BY year, highest_salary DESC, lowest_salary ASC;



---13. What is the average salary the company pays to each department per year?
SELECT strftime('%Y', hire_date) AS year, department, AVG(annual_salary) AS average_salary
FROM HRdata4
GROUP BY year, department
ORDER BY year, department;


--- 14. Retrieve the top 3 highest paid employees in each department
SELECT d.department, e.name, e.annual_salary
FROM (
  SELECT department, 
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY annual_salary DESC) AS rank
  FROM HRdata4
) AS r
JOIN HRdata4 AS e ON r.department = e.department AND r.rank = 1
JOIN HRdata4 AS d ON e.department = d.department
WHERE r.rank <= 3;



--- 15. What are the most common job titles and job descriptions within the organization?
SELECT job_title, job_description, COUNT(*) as frequency
FROM HRdata4
GROUP BY job_title, job_description
ORDER BY frequency DESC;



---16. which job title had the highest and lowest employee satisfaction score?
SELECT job_title, AVG(employee_satisfaction) AS avg_satisfaction
FROM HRdata4
GROUP BY job_title
ORDER BY avg_satisfaction DESC;


--b--
SELECT job_title, AVG(employee_satisfaction) AS avg_satisfaction
FROM HRdata4
GROUP BY job_title
ORDER BY avg_satisfaction ASC;



----17. Retrieve the department with the lowest performance score
SELECT department, AVG(performance) as avg_performance
FROM HRdata4
GROUP BY department
ORDER BY avg_performance ASC
LIMIT 1;



---18. Retrieve the number of employees who have Managers
SELECT COUNT(*) AS num_employees_with_managers
FROM HRdata4
WHERE manager = 'Y';




