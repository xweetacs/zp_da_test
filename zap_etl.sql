DROP TABLE IF EXISTS date_dimension;
CREATE TABLE IF NOT EXISTS date_dimension
(
   full_date DATE ENCODE RAW,
   year SMALLINT ENCODE lzo,
   month SMALLINT ENCODE lzo,
   month_name CHAR(3) ENCODE lzo,
   day_of_mon SMALLINT ENCODE lzo,
   day_of_week_num SMALLINT ENCODE lzo,
   day_of_week NVARCHAR(9) ENCODE lzo,
   week_of_year SMALLINT ENCODE lzo
 )
DISTSTYLE KEY
 DISTKEY (full_date)
 SORTKEY (full_date);

INSERT INTO date_dimension
SELECT date AS full_date,
DATE_PART(year,date) AS year,
DATE_PART(mm,date) AS month,
TO_CHAR(date, 'Mon') AS month_name,
DATE_PART(day,date) AS day_of_mon,
DATE_PART(dow,date) AS day_of_week_num,
TO_CHAR(date, 'Day') AS day_of_week,
DATE_PART(week,date) AS week_of_year
FROM
(SELECT trunc(dateadd(day, 1, min(date)-1)) date
   FROM source_data.tasks_used_da
   GROUP BY date
   HAVING MAX(date) >= date 
);

DROP TABLE IF EXISTS tasks_used_da_cs;
CREATE TABLE IF NOT EXISTS tasks_used_da_cs
(
   full_date DATE   ENCODE RAW
   ,user_id BIGINT   ENCODE lzo
   ,active_user BOOLEAN ENCODE RAW
   ,churn_user BOOLEAN ENCODE RAW
   ,sum_tasks_used BIGINT   ENCODE lzo
)
DISTSTYLE KEY
 DISTKEY (user_id)
 SORTKEY (
   user_id
   , full_date
   );

-- all users are active on the day where they have tasks used
INSERT INTO tasks_used_da_cs
SELECT date, user_id, 1 AS active_user, 0 as churn_user, SUM(sum_tasks_used) AS total_tasks_used
FROM source_data.tasks_used_da
GROUP BY 1,2,3,4
HAVING SUM(sum_tasks_used) > 0;


--check per user 1st and last tasks
DROP TABLE IF EXISTS #users_boundary_dates;
CREATE TABLE #users_boundary_dates AS 

SELECT user_id,
	min(full_date) AS first_task_date,
	max(full_date) AS last_task_date
FROM tasks_used_da_cs tu
group by 1;


-- create remaining date records, since they first day using zapier until they last used + 28 days to inactive + 27 days to churn
insert into tasks_used_da_cs
select dt.full_date, user_id,0,0,0
from date_dimension dt
join #users_boundary_dates au
on dt.full_date between au.first_task_date and DATEADD(day,55,au.last_task_date)
where NOT EXISTS (select 1 from tasks_used_da_cs ca where ca.user_id = au.user_id and ca.full_date = dt.full_date);


update tasks_used_da_cs
set active_user = x.active_user
from (
		select dtask.full_date, dtask.user_id,
			case when sum(da.sum_tasks_used) >= 1 then 1 else 0 end as active_user
		from tasks_used_da_cs dtask
		join tasks_used_da_cs da
		on da.full_date between DATEADD(day,-28,dtask.full_date) and dtask.full_date 
			and dtask.user_id = da.user_id
		group by 1,2
) x
where x.user_id = tasks_used_da_cs.user_id and x.full_date = tasks_used_da_cs.full_date;

update tasks_used_da_cs
set churn_user = x.churn_user
from (select * from
		(select dtask.full_date, dtask.user_id,
			case when sum(da.sum_tasks_used) >= 1 then 1 else 0 end as churn_user
		from tasks_used_da_cs dtask
		join tasks_used_da_cs da
		on da.full_date NOT BETWEEN DATEADD(day,-28,dtask.full_date)
								and DATEADD(day,-55,dtask.full_date) 
			and dtask.user_id = da.user_id
		group by 1,2
		) y
		where NOT EXISTS (select 1 from tasks_used_da_cs ca where ca.user_id = y.user_id and ca.full_date = y.full_date and ca.active_user=1)
) x where x.user_id = tasks_used_da_cs.user_id and x.full_date = tasks_used_da_cs.full_date 