--[AI Recruitment Analytics Project]


--Count total candidates.
select DISTINCT COUNT (candidate_id) AS total_candidates
from [dbo].[candidates];

--Count candidates by country.
select DISTINCT COUNT (candidate_id) AS total_candidates,country
from [dbo].[candidates]
group by country;

--Find average AI match score.
select CAST(ROUND(AVG(ai_match_score),2)AS INT) AS AVG_SCORE
from [dbo].[applications];

--Find highest interview score.
select MAX(interview_score) AS highest_score
from [dbo].[applications];

--Find recruiters by region.
SELECT COUNT(recruiter_id) AS No_of_recruiters,region
FROM [dbo].[recruiters]
GROUP BY region,recruiter_name;

--Which recruiter hired most candidates?

SELECT * from [dbo].[recruiters];

WITH REC AS (SELECT A.recruiter_id,A.application_status,R.recruiter_name
FROM [dbo].[applications] A INNER JOIN [dbo].[recruiters] R 
ON R.recruiter_id=A.recruiter_id
WHERE A.application_status='Hired'
)
SELECT COUNT(recruiter_id)AS No_of_hires,recruiter_name
FROM REC
GROUP BY recruiter_name;

--Which role gets most applications?

SELECT J.job_id,J.role_name,COUNT(A.application_id) AS no_of_applications
FROM [dbo].[job_postings] J INNER JOIN [dbo].[applications] A
ON J.job_id=A.job_id
GROUP BY J.job_id,J.role_name
ORDER BY COUNT(A.application_id) DESC;

--Find average interview score by department.
SELECT AVG(A.interview_score)AS AVG_INT_SCORE,J.department
FROM [dbo].[applications] A INNER JOIN [dbo].[job_postings] J
ON A.job_id=J.job_id
GROUP BY J.department;

--Find candidates with AI match score > 90.


select A.candidate_id,A.ai_match_score,C.candidate_name
from [dbo].[applications] A INNER JOIN [dbo].[candidates] C
ON A.candidate_id=C.candidate_id
WHERE A.ai_match_score>90;

--Find rejected candidates with high AI score.

select A.candidate_id,A.ai_match_score,C.candidate_name,A.application_status
from [dbo].[applications] A INNER JOIN [dbo].[candidates] C
ON A.candidate_id=C.candidate_id
WHERE A.ai_match_score>70 AND A.application_status='Rejected';   --THIS MENAS THERE IS  NO CANDIDATE WITHH SCORE>90 AND REHECTED 


--Rank recruiters by hiring success.
USE [AI Recruitment Analytics Project];
WITH REC AS (select recruiter_id,application_status
from [dbo].[applications]
WHERE application_status='Hired'
)
SELECT recruiter_id,COUNT(application_status) AS TOTAL_HIRE,
DENSE_RANK () OVER(ORDER BY COUNT(application_status) DESC ) AS SUCCESS_RANK
FROM REC
GROUP BY recruiter_id;


--Calculate hiring conversion rate.


SELECT COUNT (CASE WHEN application_status='Hired' then 1 END)  *100 /COUNT (*) AS HIRING_PERCENTAGE
FROM [dbo].[applications];


--Find correlation between AI score and hiring.
SELECT AVG(ai_match_score) AS AVG_AI_SCORE,application_status
FROM [dbo].[applications]
GROUP BY application_status;

--Build recruitment funnel analysis.

SELECT  application_stage,COUNT(*) AS TOTAL_CANDIDATES,
COUNT(*) *100/SUM(COUNT(*)) OVER () 
AS PERCNtage
FROM [dbo].[applications]
GROUP BY application_stage ORDER by PERCNtage DESC;

--Does AI match score predict hiring success?

SELECT application_status,AVG(ai_match_score) AS AVG_AI_SCORE
FROM [dbo].[applications]
GROUP BY  application_status;

--Which skill category gets hired fastest?

SELECT S.skill_category,COUNT(S.candidate_id) AS COUNT_OF_CANDIDATES,A.application_status
FROM [dbo].[applications] A INNER JOIN [dbo].[candidates] S
ON A.candidate_id=S.candidate_id
WHERE  A.application_status ='Hired'
GROUP BY S.skill_category, A.application_status
ORDER BY COUNT(S.candidate_id) DESC;


--Which country has highest-quality candidates?
SELECT AVG(A.interview_score) AS AVG_INT, AVG(A.ai_match_score) AS AVG_AI_SCORE, (AVG(A.interview_score) + AVG(A.ai_match_score) ) AS QUALITY_SCORE,C.country
FROM [dbo].[applications] A INNER JOIN [dbo].[candidates] C 
ON A.candidate_id=C.candidate_id
GROUP BY C.country
ORDER BY QUALITY_SCORE DESC;


--Which recruiters are underperforming?
SELECT * FROM [dbo].[applications];
SELECT * FROM [dbo].[candidates];
SELECT * FROM[dbo].[interview_feedback];
SELECT * FROM[dbo].[job_postings];
SELECT * FROM [dbo].[recruiters];

SELECT R.recruiter_name,R.hiring_target,COUNT( CASE WHEN A.application_status='Hired' THEN 1 END ) AS NO_OF_HIRES,
COUNT( CASE WHEN A.application_status='Hired' THEN 1 END )*100 /R.hiring_target AS PERCETAGE_ACHIEVED
FROM [dbo].[recruiters] R INNER JOIN [dbo].[applications] A
ON R.recruiter_id=A.recruiter_id
GROUP BY R.recruiter_name,R.hiring_target
ORDER BY PERCETAGE_ACHIEVED DESC ;

--Build executive hiring dashboard KPIs.
SELECT COUNT(candidate_id) AS NO_OF_CANDIADTES, COUNT(job_id) AS TOTAL_JOBS,
AVG(interview_score) AS INT_SCORE,
AVG(ai_match_score) AI_SCORE,
ROUND(COUNT(CASE WHEN application_status='Hired' THEN 1 END),1) AS TOTAL_HIRES,
ROUND(COUNT(CASE WHEN application_status='Hired' THEN 1 END),1) AS TOTAL_HIRES,
CONCAT(ROUND(COUNT (CASE WHEN application_status='Hired' THEN 1 END)*100 /COUNT(*) ,1), '%') AS HIRING_RATE
FROM [dbo].[applications];

