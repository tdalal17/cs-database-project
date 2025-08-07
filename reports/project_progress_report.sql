-- Project Progress Report
-- Shows project details, tasks, status, and progress

SELECT 
    p.c_project_pr AS ProjectID,
    p.t_description_pr AS ProjectDescription,
    c.t_name_cu AS CustomerName,
    pt.c_task_pt AS TaskID,
    pt.t_description_pt AS TaskDescription,
    pt.d_schedStartDate_pt AS ScheduledStartDate,
    pt.d_schedEndDate_pt AS ScheduledEndDate,
    CASE
        WHEN a.d_endDate_as IS NOT NULL THEN 'Completed'
        WHEN a.d_startDate_as IS NOT NULL AND a.d_endDate_as IS NULL THEN 'In Progress'
        ELSE 'Not Started'
    END AS TaskStatus,
    COUNT(DISTINCT e.c_employee_em) AS EmployeesAssigned,
    SUM(wl.n_hoursWorked_wl) AS TotalHoursWorked
FROM 
    PROJECT p
JOIN 
    CUSTOMER c ON p.c_customer_pr = c.c_customer_cu
JOIN 
    PROJECT_TASK pt ON p.c_project_pr = pt.c_project_pt
LEFT JOIN 
    ASSIGNMENT a ON pt.c_task_pt = a.c_task_as
LEFT JOIN 
    EMPLOYEE e ON a.c_employee_as = e.c_employee_em
LEFT JOIN 
    WORK_LOG wl ON a.c_assignment_as = wl.c_assignment_wl
GROUP BY 
    p.c_project_pr,
    p.t_description_pr,
    c.t_name_cu,
    pt.c_task_pt,
    pt.t_description_pt,
    pt.d_schedStartDate_pt,
    pt.d_schedEndDate_pt,
    CASE
        WHEN a.d_endDate_as IS NOT NULL THEN 'Completed'
        WHEN a.d_startDate_as IS NOT NULL AND a.d_endDate_as IS NULL THEN 'In Progress'
        ELSE 'Not Started'
    END
ORDER BY 
    p.c_project_pr, 
    pt.d_schedStartDate_pt;
