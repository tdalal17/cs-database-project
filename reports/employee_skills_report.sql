-- Employee Skills Utilization Report
-- This report shows how effectively employee skills are being utilized across projects
-- It combines data from EMPLOYEE, EMPLOYEE_SKILL, SKILL, ASSIGNMENT, PROJECT_TASK, and WORK_LOG tables

SELECT 
    e.c_employee_em AS EmployeeID,
    e.t_lastName_em + ', ' + e.t_firstName_em AS EmployeeName,
    r.t_regionName_rg AS Region,
    s.c_skill_sk AS SkillID,
    s.t_description_sk AS SkillDescription,
    s.n_rateOfPay_sk AS HourlyRate,
    COUNT(DISTINCT a.c_assignment_as) AS TotalAssignments,
    COUNT(DISTINCT pt.c_project_pt) AS ProjectsInvolved,
    SUM(wl.n_hoursWorked_wl) AS TotalHoursWorked,
    SUM(wl.n_hoursWorked_wl * s.n_rateOfPay_sk) AS TotalBillableAmount
FROM 
    EMPLOYEE e
JOIN 
    REGION r ON e.c_region_em = r.c_region_rg
JOIN 
    EMPLOYEE_SKILL es ON e.c_employee_em = es.c_employee_es
JOIN 
    SKILL s ON es.c_skill_es = s.c_skill_sk
LEFT JOIN 
    ASSIGNMENT a ON e.c_employee_em = a.c_employee_as
LEFT JOIN 
    PROJECT_TASK pt ON a.c_task_as = pt.c_task_pt
LEFT JOIN 
    TASK_SKILL ts ON pt.c_task_pt = ts.c_task_ts AND s.c_skill_sk = ts.c_skill_ts
LEFT JOIN 
    WORK_LOG wl ON a.c_assignment_as = wl.c_assignment_wl
GROUP BY 
    e.c_employee_em,
    e.t_lastName_em + ', ' + e.t_firstName_em,
    r.t_regionName_rg,
    s.c_skill_sk,
    s.t_description_sk,
    s.n_rateOfPay_sk
ORDER BY 
    TotalBillableAmount DESC;
