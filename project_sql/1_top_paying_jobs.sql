/*
Question: What are the top paying data analyst jobs?
  -focusing on remote jobs that have salaries specified
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

/*
Results: This query shows the top 10 highest paying job listings that were made for data analyst positions
that were also remote including the company names of each listing as well.
*/
