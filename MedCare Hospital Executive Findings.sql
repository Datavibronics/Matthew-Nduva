CREATE DATABASE medcare_hospital;
USE medcare_hospital;
CREATE TABLE medcare_hospital_clean_data (
    PatientID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    Age INT,
    Gender VARCHAR(20),
    City VARCHAR(50),
    InsuranceType VARCHAR(50),
    Department VARCHAR(50),
    Diagnosis VARCHAR(100),
    TreatmentType VARCHAR(50),
    LengthOfStay INT,
    TreatmentCost DECIMAL(12,2),
    InsuranceCoverage DECIMAL(12,2),
    OutOfPocketCost DECIMAL(12,2),
    SatisfactionScore INT,
    FollowUpCompleted VARCHAR(10),
    ChronicCondition VARCHAR(10),
    PreviousAdmissions INT,
    Readmitted VARCHAR(10),
    Year INT,
    Month INT,
    Quarter VARCHAR(10),
    AgeGroup VARCHAR(20),
    CostCategory VARCHAR(20),
    ReadmissionFlag INT,
    StayCategory VARCHAR(20),
    SatisfactionCategory VARCHAR(20),
    RiskIndicator VARCHAR(20),
    AdmissionWeekday VARCHAR(20)
);

select*
from medcare_hospital_clean_data;

-- Total patients treated by MedCare Hospital

SELECT
    COUNT(*) AS TotalPatients
FROM medcare_hospital_clean_data;

-- Total treatment cost across all patients

SELECT
    ROUND(SUM(TreatmentCost),2) AS TotalTreatmentCost
FROM medcare_hospital_clean_data;

-- Average treatment cost per patient

SELECT
    ROUND(AVG(TreatmentCost),2) AS AvgTreatmentCost
FROM medcare_hospital_clean_data;

-- Average hospital stay

SELECT
    ROUND(AVG(LengthOfStay),2) AS AvgLengthOfStay
FROM medcare_hospital_clean_data;

-- Percentage of patients readmitted

SELECT
    ROUND(
        SUM(ReadmissionFlag) * 100.0 / COUNT(*),
        2
    ) AS ReadmissionRate
FROM medcare_hospital_clean_data;

-- Overall patient satisfaction

SELECT
    ROUND(AVG(SatisfactionScore),2) AS AvgSatisfaction
FROM medcare_hospital_clean_data;

-- Patient volume by department

SELECT
    Department,
    COUNT(*) AS TotalPatients
FROM medcare_hospital_clean_data
GROUP BY Department
ORDER BY TotalPatients DESC;

-- Which departments experience the highest readmissions

SELECT
    Department,
    COUNT(*) AS TotalPatients,
    SUM(`Readmission Flag`) AS ReadmittedPatients,
    ROUND(
        SUM(`Readmission Flag`) * 100.0 / COUNT(*),
        2
    ) AS ReadmissionRate
FROM medcare_hospital_clean_data
GROUP BY Department
ORDER BY ReadmissionRate DESC;
select*
from medcare_hospital_clean_data;

-- Total cost by department

SELECT 
Department,
    ROUND(SUM(TreatmentCost),2) AS TotalCost
FROM medcare_hospital_clean_data
GROUP BY Department
ORDER BY TotalCost DESC;

-- Department stay duration

SELECT
    Department,
    ROUND(AVG(LengthOfStay),2) AS AvgStay
FROM medcare_hospital_clean_data
GROUP BY Department
ORDER BY AvgStay DESC;

-- Which age groups are most likely to return

SELECT
    AgeGroup,
    COUNT(*) AS Patients,
    SUM(`Readmission Flag`) AS Readmissions,
    ROUND(
        SUM(`Readmission Flag`) * 100.0 / COUNT(*),
        2
    ) AS ReadmissionRate
FROM medcare_hospital_clean_data
GROUP BY AgeGroup
ORDER BY ReadmissionRate DESC;

-- Diagnoses associated with the most readmissions

SELECT
    Diagnosis,
    SUM(`Readmission Flag`) AS Readmissions
FROM medcare_hospital_clean_data
GROUP BY Diagnosis
ORDER BY Readmissions DESC
LIMIT 10;

-- Financial impact of readmitted patients

SELECT
    ROUND(SUM(TreatmentCost),2) AS ReadmissionCost
FROM medcare_hospital_clean_data
WHERE Readmitted = 'Yes';

-- Relationship between satisfaction and readmission

SELECT
    `Satisfactory Category`,
    COUNT(*) AS Patients,
    ROUND(
        AVG(`Readmission Flag`) * 100,
        2
    ) AS ReadmissionRate
FROM medcare_hospital_clean_data
GROUP BY `Satisfactory Category`
ORDER BY ReadmissionRate DESC;

-- Insurance groups most affected

SELECT
    InsuranceType,
    COUNT(*) AS Patients,
    ROUND(
        AVG(`Readmission Flag`) * 100,
        2
    ) AS ReadmissionRate
FROM medcare_hospital_clean_data
GROUP BY InsuranceType
ORDER BY ReadmissionRate DESC;

-- Risk segmentation

SELECT
    `Risk Indicator`,
    COUNT(*) AS Patients
FROM medcare_hospital_clean_data
GROUP BY `Risk Indicator`;

-- Readmission trend over time

SELECT
    Year,
    Month,
    SUM(`Readmission Flag`) AS Readmissions
FROM medcare_hospital_clean_data
GROUP BY Year, Month
ORDER BY Year, Month;