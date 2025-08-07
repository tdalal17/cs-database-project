-- Global Computer Solutions (GCS) Database Schema
-- Complete SQL DDL for creating the normalized database structure

-- Drop existing tables if they exist (in reverse order of dependencies)
IF OBJECT_ID('WORK_LOG', 'U') IS NOT NULL
    DROP TABLE WORK_LOG;
    
IF OBJECT_ID('BILL', 'U') IS NOT NULL
    DROP TABLE BILL;
    
IF OBJECT_ID('ASSIGNMENT', 'U') IS NOT NULL
    DROP TABLE ASSIGNMENT;
    
IF OBJECT_ID('TASK_SKILL', 'U') IS NOT NULL
    DROP TABLE TASK_SKILL;
    
IF OBJECT_ID('PROJECT_TASK', 'U') IS NOT NULL
    DROP TABLE PROJECT_TASK;
    
IF OBJECT_ID('PROJECT', 'U') IS NOT NULL
    DROP TABLE PROJECT;
    
IF OBJECT_ID('EMPLOYEE_SKILL', 'U') IS NOT NULL
    DROP TABLE EMPLOYEE_SKILL;
    
IF OBJECT_ID('CUSTOMER', 'U') IS NOT NULL
    DROP TABLE CUSTOMER;
    
IF OBJECT_ID('EMPLOYEE', 'U') IS NOT NULL
    DROP TABLE EMPLOYEE;
    
IF OBJECT_ID('SKILL', 'U') IS NOT NULL
    DROP TABLE SKILL;
    
IF OBJECT_ID('REGION', 'U') IS NOT NULL
    DROP TABLE REGION;

-- Create REGION table
CREATE TABLE REGION (
    c_region_rg CHAR(2) PRIMARY KEY,
    t_regionName_rg VARCHAR(50) NOT NULL
);

-- Create CUSTOMER table
CREATE TABLE CUSTOMER (
    c_customer_cu INTEGER PRIMARY KEY,
    t_name_cu VARCHAR(100) NOT NULL,
    t_phone_cu VARCHAR(20) NOT NULL,
    c_region_cu CHAR(2) NOT NULL,
    FOREIGN KEY (c_region_cu) REFERENCES REGION(c_region_rg)
);

-- Create EMPLOYEE table
CREATE TABLE EMPLOYEE (
    c_employee_em INTEGER PRIMARY KEY,
    t_lastName_em VARCHAR(50) NOT NULL,
    t_firstName_em VARCHAR(50) NOT NULL,
    t_middleInitial_em CHAR(1),
    c_region_em CHAR(2) NOT NULL,
    d_hireDate_em DATE NOT NULL,
    FOREIGN KEY (c_region_em) REFERENCES REGION(c_region_rg)
);

-- Create SKILL table
CREATE TABLE SKILL (
    c_skill_sk VARCHAR(20) PRIMARY KEY,
    t_description_sk VARCHAR(100) NOT NULL,
    n_rateOfPay_sk DECIMAL(10,2) NOT NULL CHECK (n_rateOfPay_sk > 0)
);

-- Create EMPLOYEE_SKILL intersection table
CREATE TABLE EMPLOYEE_SKILL (
    c_employee_es INTEGER,
    c_skill_es VARCHAR(20),
    PRIMARY KEY (c_employee_es, c_skill_es),
    FOREIGN KEY (c_employee_es) REFERENCES EMPLOYEE(c_employee_em),
    FOREIGN KEY (c_skill_es) REFERENCES SKILL(c_skill_sk)
);

-- Create PROJECT table
CREATE TABLE PROJECT (
    c_project_pr INTEGER PRIMARY KEY,
    t_description_pr VARCHAR(200) NOT NULL,
    c_customer_pr INTEGER NOT NULL,
    d_contractDate_pr DATE NOT NULL,
    d_estStartDate_pr DATE,
    d_estEndDate_pr DATE,
    d_actStartDate_pr DATE,
    d_actEndDate_pr DATE,
    n_estBudget_pr DECIMAL(12,2) NOT NULL CHECK (n_estBudget_pr >= 0),
    n_actCost_pr DECIMAL(12,2) CHECK (n_actCost_pr >= 0),
    FOREIGN KEY (c_customer_pr) REFERENCES CUSTOMER(c_customer_cu)
);

-- Create PROJECT_TASK table
CREATE TABLE PROJECT_TASK (
    c_task_pt INTEGER PRIMARY KEY,
    c_project_pt INTEGER NOT NULL,
    t_description_pt VARCHAR(100) NOT NULL,
    d_schedStartDate_pt DATE,
    d_schedEndDate_pt DATE,
    i_quantityRequired_pt INTEGER NOT NULL CHECK (i_quantityRequired_pt > 0),
    FOREIGN KEY (c_project_pt) REFERENCES PROJECT(c_project_pr)
);

-- Create TASK_SKILL intersection table
CREATE TABLE TASK_SKILL (
    c_task_ts INTEGER,
    c_skill_ts VARCHAR(20),
    PRIMARY KEY (c_task_ts, c_skill_ts),
    FOREIGN KEY (c_task_ts) REFERENCES PROJECT_TASK(c_task_pt),
    FOREIGN KEY (c_skill_ts) REFERENCES SKILL(c_skill_sk)
);

-- Create ASSIGNMENT table
CREATE TABLE ASSIGNMENT (
    c_assignment_as INTEGER PRIMARY KEY,
    c_employee_as INTEGER NOT NULL,
    c_task_as INTEGER NOT NULL,
    d_startDate_as DATE,
    d_endDate_as DATE,
    FOREIGN KEY (c_employee_as) REFERENCES EMPLOYEE(c_employee_em),
    FOREIGN KEY (c_task_as) REFERENCES PROJECT_TASK(c_task_pt)
);

-- Create BILL table
CREATE TABLE BILL (
    c_bill_bl INTEGER PRIMARY KEY,
    c_project_bl INTEGER NOT NULL,
    d_billDate_bl DATE NOT NULL,
    n_amount_bl DECIMAL(12,2) NOT NULL CHECK (n_amount_bl >= 0),
    FOREIGN KEY (c_project_bl) REFERENCES PROJECT(c_project_pr)
);

-- Create WORK_LOG table
CREATE TABLE WORK_LOG (
    c_workLog_wl INTEGER PRIMARY KEY,
    c_assignment_wl INTEGER NOT NULL,
    d_weekEnding_wl DATE NOT NULL,
    n_hoursWorked_wl DECIMAL(5,2) NOT NULL CHECK (n_hoursWorked_wl > 0),
    c_bill_wl INTEGER,
    FOREIGN KEY (c_assignment_wl) REFERENCES ASSIGNMENT(c_assignment_as),
    FOREIGN KEY (c_bill_wl) REFERENCES BILL(c_bill_bl)
);
