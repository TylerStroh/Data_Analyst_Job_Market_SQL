# Introduction
Lets take a look at the data job market! Focusing on Data Analyst roles, this project explores
top-paying jobs, skills that are in demand, and the salaries associated with the skills needed
for a role in data analytics.

Check out the SQL queries used here: [project_sql_folder](/project_sql/)

# Background

Looking into the Data Analyst job market there were a few things I wanted to learn to help give
me a better understanding of what the market had available and the requirments for the postitions as well.

### The questions I wanted answered through SQL queries were:

1. What are the top-paying Data Analyst positions?
2. What skills were required for the top-paying positions?
3. Which skills are most in demand for Data Analyst positions?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used

For my deep dive into the Data Analyst job market I used several key tools:

- **SQL:** The language used to run the queries on the database to find my insights.
- **Visual Studio Code:** Where I saved my code and executed the SQL queries.
- **PostgreSQL:** The database management system used to handle the job posting data.
- **Git & GitHib:** Used for version control and sharing my SQL queries and analysis.

# The Analysis

Each query for this project is designed to look into specific aspects of the Data Analyst job market.
Here is how I approached each question:

### 1. Top Paying Data Analyst Jobs
To help me identify the highest-paying roles, I filtered the jobs by yearly salary and location while focusing
on Data Analyst positions that were remote. This query below highlights the high paying opportunities in the field.

```sql
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
```

Results:

| job_id  | job_title                                           | job_location | job_schedule_type | salary_year_avg | job_posted_date    | company_name                      |
|---------|-----------------------------------------------------|--------------|-------------------|-----------------|--------------------|-----------------------------------|
| 226942  | Data Analyst                                        | Anywhere     | Full-time         | 650000          | 2/20/2023 15:13    | Mantys                            |
| 547382  | Director of Analytics                               | Anywhere     | Full-time         | 336500          | 8/23/2023 12:04    | Meta                              |
| 552322  | Associate Director- Data Insights                   | Anywhere     | Full-time         | 255829.5        | 6/18/2023 16:03    | AT&T                              |
| 99305   | Data Analyst, Marketing                             | Anywhere     | Full-time         | 232423          | 12/5/2023 20:00    | Pinterest Job Advertisements      |
| 1021647 | Data Analyst (Hybrid/Remote)                        | Anywhere     | Full-time         | 217000          | 1/17/2023 0:17     | Uclahealthcareers                 |
| 168310  | Principal Data Analyst (Remote)                     | Anywhere     | Full-time         | 205000          | 8/9/2023 11:00     | SmartAsset                        |
| 731368  | Director, Data Analyst - HYBRID                     | Anywhere     | Full-time         | 189309          | 12/7/2023 15:00    | Inclusively                       |
| 310660  | Principal Data Analyst, AV Performance Analysis     | Anywhere     | Full-time         | 189000          | 1/5/2023 0:00      | Motional                          |
| 1749593 | Principal Data Analyst                              | Anywhere     | Full-time         | 186000          | 7/11/2023 16:00    | SmartAsset                        |
| 387860  | ERM Data Analyst                                    | Anywhere     | Full-time         | 184000          | 6/9/2023 8:01      | Get It Recruit - Information Technology |

Findings:
- With this dataset we find a wide range in salary for the top 10 opportunitys of $184k-$605k. 
- We also find a wide range of companies offering these positions like AT&T, Meta, & SmartAsset showing interest in
Data Analyst jobs across different industries.
- There is a variety in Job Titles as well within the top positions while all being Data Analyst positions
 we find postions such as Principal Data Analyst,
Data Insights, Director of Analytics, etc

### 2. Skills Required For The Top Paying Data Analyst Jobs
After finding the top-paying jobs I wanted to see what skills were required for those opportunities. With this query
using the same filters as the previous query we added the list of all skills that were required for the top positions.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

Results:

![Top Paying Jobs](project_sql\Results\results_query_2.png)
*Bar graph visualizing the results since the table was hard to read. Graph generated by ChatGPT*

Findings:
- Looking at the skills required for the top-paying Data Analyst positions we find some common trends like SQL showing up on 8 times, Python showing up 7 times, Tableau showing up 6 times, and R showing up 4 times.
- We also find a majority of skills only show up 1-2 times showing they would be needed for more specific Data Analyst positions.

### 3. Most In-Demand Skills For Data Analyst Positions
After finding the skills required for the top-paying Data Analyst positions I wanted to see what skills were
required most across all Data Analyst positions using the same filters.

```sql
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
```

Results:
| skills   | demand_count |
|----------|--------------|
| sql      | 7291         |
| excel    | 4611         |
| python   | 4330         |
| tableau  | 3745         |
| power bi | 2609         |

Findings:
- We find the top 5 skills asked for across all Data Analyst positions that were remote.
- SQL is the most required skill showing up 7291 times showing to be the most beneficial skill to learn to be a Data Analyst.

### 4. Skills Associated With Higher Salaries
Now that we have found which skills were most in demand and skills that were asked for at higher salaries I wanted to see what the average salary was for each skill across Data Analyst positions that were remote.

```SQL
SELECT 
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

Results:
| skills        | avg_salary |
|---------------|------------|
| pyspark       | 208172     |
| bitbucket     | 189155     |
| couchbase     | 160515     |
| watson        | 160515     |
| datarobot     | 155486     |
| gitlab        | 154500     |
| swift         | 153750     |
| jupyter       | 152777     |
| pandas        | 151821     |
| elasticsearch | 145000     |
| golang        | 145000     |
| numpy         | 143513     |
| databricks    | 141907     |
| linux         | 136508     |
| kubernetes    | 132500     |
| atlassian     | 131162     |
| twilio        | 127000     |
| airflow       | 126103     |
| scikit-learn  | 125781     |
| jenkins       | 125436     |
| notion        | 125000     |
| scala         | 124903     |
| postgresql    | 123879     |
| gcp           | 122500     |
| microstrategy | 121619     |

Findings:
- For the top 25 skills we find an average salary with the range of $121k-$208k
- Looking at this list we find a lot of skills that we were not finding before in other queries but we did
find the SQL tool postgresql on the list with an average salary of $123k

### 5. Most Optimal Skills To Learn
To make sure our findings are reliable and have accurate data we look at some of our other queries and refine the searches
to also only include skills that show up more than 10 time to help us find the most optimal skills to learn to get a
Data Analyst job.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC
LIMIT 25
```
Results:

| skill_id | skills     | demand_count | avg_salary |
|----------|------------|--------------|------------|
| 0        | sql        | 398          | 97237      |
| 181      | excel      | 256          | 87288      |
| 1        | python     | 236          | 101397     |
| 182      | tableau    | 230          | 99288      |
| 5        | r          | 148          | 100499     |
| 183      | power bi   | 110          | 97431      |
| 7        | sas        | 63           | 98902      |
| 196      | powerpoint | 58           | 88701      |

Findings:
- For the skills in high demand they are in a similar range for average salary ranging from $87k-$101k
- To land a Data Analyst position it would be beneficial to learn these skills listed since they are the skills in most demand.

# What I learned

Throughout this SQL project I gained a knowlege on many SQL tools:

- I learned how to combine tables with JOIN's to show results across multiple tables to give a better understanding of the data.
- I utilized GROUP BY by learning aggregate functions such as COUNT and AVG to show the data through a different view point.
- I also learned how to use the README tool and learned the functions to properly show the findings I gathered in my queries.

# Conclusions

### Insights
From the analysis we were able to find some interesting insights for each query:

1. **Top Paying Data Analyst Jobs**: The highest paying jobs for Data Analyst positions offered a high range of salaries with
the highest being $650k!
2. **Skills Required For The Top Paying Data Analyst Jobs**: Across the highest paying jobs for Data Analyst positions the skills that were needed the most were SQL, Python, R, and Tableau.
3. **Most In-Demand Skills For Data Analyst Positions**: When looking at all Data Analyst positions we found the most in-demand
skills were SQL, Excel, Python, Tableau, and Power BI.
4. **Skills Associated With Higher Salaries**: When looking at the average salaries associated with each skill we find a wide range 
in salaries with pyspark being the highest with a salary of $208k. Also with a SQL tool showing up towards the bottom of the list.
5. **Most Optimal Skills To Learn**: When looking at demand count and average salary together we find the most optimal skills to learn are SQL, Excel, Python, Tableau,  R, and Power BI. All with demand counts over 100 and all with salaries within a similar range to each other.

### Closing Thoughts

Throughout this project I learned to enhance my SQL skills to help provide valuable insights about 2023 Data Analyst job market. Since I am looking to land a role in Data Analytics looking through this data helped give me a better understanding of what else I should take time to learn to help be a better fit for one of these positions since the Data Analyst job market can be competitive.


