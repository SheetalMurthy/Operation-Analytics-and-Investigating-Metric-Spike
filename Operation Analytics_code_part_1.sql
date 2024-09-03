create database p3;
show databases;
use p3;

select * from job_data;
# Changing STR type to DATETIME for ds column

ALTER TABLE job_data ADD COLUMN temp_ds DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE job_data SET temp_ds = STR_TO_DATE(ds, '%m/%d/%Y');
ALTER TABLE job_data DROP COLUMN ds;
ALTER TABLE job_data CHANGE COLUMN temp_ds ds DATE;

#Objective: Calculate the number of jobs reviewed per hour for each day in November 2020.
#Your Task: Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.
SELECT avg(jobs_per_day) AS no_jobs_reviewed_per_hour FROM (
SELECT ds, 
count(job_id)/sum(time_spent)*60*60 AS jobs_per_day 
FROM job_data
WHERE month(ds)=11 AND year(ds)=2020
GROUP BY ds) AS table1;

#Objective: Calculate the 7-day rolling average of throughput (number of events per second).
#Your Task: Write an SQL query to calculate the 7-day rolling average of throughput. 
#Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.
SELECT count(event)/sum(time_spent) AS 7_day_rolling_average_of_throughput FROM job_data;
SELECT ds AS date, count(event)/sum(time_spent) AS daily_throughput FROM job_data
GROUP BY ds;

#Objective: Calculate the percentage share of each language in the last 30 days.
#Your Task: Write an SQL query to calculate the percentage share of each language over the last 30 days.
SELECT language, 
round((language_count/(SELECT count(*) FROM job_data))*100,2) AS percentage_of_language 
FROM (
SELECT language, count(*) AS language_count FROM job_data
GROUP BY language) AS table1
GROUP BY language;

#Objective: Identify duplicate rows in the data.
#Your Task: Write an SQL query to display duplicate rows from the job_data table.
SELECT actor_id, count(*) FROM job_data
GROUP BY actor_id
HAVING count(*)>1;

