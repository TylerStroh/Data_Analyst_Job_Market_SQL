/*
Question: What are the top demanded skills for a Data Analyst position?
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5

/*
Results: This query shows the top 5 skills that are asked for in
Data Analyst positions that are also remote. From these findings we see
SQL is the most asked for skill across the job postings that fit this criteria.
*/