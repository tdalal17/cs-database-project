-- Project Financial Summary Report
-- This report provides a financial overview of all projects, including budget vs. actual costs
-- It combines data from PROJECT, CUSTOMER, BILL, ASSIGNMENT, and WORK_LOG tables

SELECT 
    p.c_project_pr AS ProjectID,
    p.t_description_pr AS ProjectDescription,
    c.t_name_cu AS CustomerName,
    c.c_region_cu AS CustomerRegion,
    p.d_contractDate_pr AS ContractDate,
    p.d_estStartDate_pr AS EstimatedStartDate,
    p.d_estEndDate_pr AS EstimatedEndDate,
    p.d_actStartDate_pr AS ActualStartDate,
    p.d_actEndDate_pr AS ActualEndDate,
    
    -- Schedule metrics
    CASE 
        WHEN p.d_actEndDate_pr IS NULL THEN 'In Progress'
        WHEN p.d_actEndDate_pr <= p.d_estEndDate_pr THEN 'On Time'
        ELSE 'Delayed'
    END AS ScheduleStatus,
    
    CASE
        WHEN p.d_actEndDate_pr IS NULL THEN NULL
        ELSE DATEDIFF(day, p.d_estEndDate_pr, p.d_actEndDate_pr)
    END AS DaysVariance,
    
    -- Financial metrics
    p.n_estBudget_pr AS EstimatedBudget,
    p.n_actCost_pr AS ActualCost,
    SUM(b.n_amount_bl) AS TotalBilled,
    
    -- Performance metrics
    CASE 
        WHEN p.n_actCost_pr IS NULL THEN NULL
        WHEN p.n_actCost_pr <= p.n_estBudget_pr THEN 'Under Budget'
        ELSE 'Over Budget'
    END AS BudgetStatus,
    
    CASE
        WHEN p.n_actCost_pr IS NULL THEN NULL
        ELSE (p.n_actCost_pr - p.n_estBudget_pr) / p.n_estBudget_pr * 100
    END AS BudgetVariancePercent,
    
    COUNT(DISTINCT a.c_assignment_as) AS TotalAssignments,
    COUNT(DISTINCT a.c_employee_as) AS TotalEmployees,
    SUM(wl.n_hoursWorked_wl) AS TotalHoursWorked
FROM 
    PROJECT p
JOIN 
    CUSTOMER c ON p.c_customer_pr = c.c_customer_cu
LEFT JOIN 
    BILL b ON p.c_project_pr = b.c_project_bl
LEFT JOIN 
    PROJECT_TASK pt ON p.c_project_pr = pt.c_project_pt
LEFT JOIN 
    ASSIGNMENT a ON pt.c_task_pt = a.c_task_as
LEFT JOIN 
    WORK_LOG wl ON a.c_assignment_as = wl.c_assignment_wl
GROUP BY 
    p.c_project_pr,
    p.t_description_pr,
    c.t_name_cu,
    c.c_region_cu,
    p.d_contractDate_pr,
    p.d_estStartDate_pr,
    p.d_estEndDate_pr,
    p.d_actStartDate_pr,
    p.d_actEndDate_pr,
    p.n_estBudget_pr,
    p.n_actCost_pr
ORDER BY 
    p.d_contractDate_pr DESC;
