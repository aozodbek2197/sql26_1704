-- 1-mashq
SELECT 
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS total_lead_manager,
    COUNT(DISTINCT sm.senior_manager_code) AS total_senior_manager,
    COUNT(DISTINCT m.manager_code) AS total_manager,
    COUNT(DISTINCT e.employee_code) AS total_employee
FROM company c
LEFT JOIN lead_manager lm ON c.company_code = lm.company_code
LEFT JOIN senior_manager sm ON lm.lead_manager_code = sm.lead_manager_code
LEFT JOIN manager m ON sm.senior_manager_code = m.senior_manager_code
LEFT JOIN employee e ON m.manager_code = e.manager_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;
-- 2-mashq
WITH projects_grouped AS (
    SELECT 
        start_date,
        end_date,
        start_date - INTERVAL (ROW_NUMBER() OVER (ORDER BY start_date) - 1) DAY AS grp
    FROM projects
)
SELECT 
    MIN(start_date) AS project_start,
    MAX(end_date) AS project_end
FROM projects_grouped
GROUP BY grp
ORDER BY DATEDIFF(MAX(end_date), MIN(start_date)), project_start;
