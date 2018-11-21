# Monthly Active Users (MAU) Project

This project was created to provide an understanding of my SQL, analysis and visualization skills when appplied to calculate the daily active users and churn rate.

## Requirement

### Part one
* Get acquainted to the data structure

### Part two:
* Create a data model on top of the current structure to manipulate the data

### Part three:
* Analyze and visualize Monthly Active Users and churn over time: create an analysis that is ready to share with an internal stakeholder that helps them understand the relationship between monthly active users and churn.

## Getting Started

These instructions will get this project up and running on a local machine.
This solution was tested and developed on a macOS system.

### Prerequisites

1) Install Python 3.7 available on https://www.python.org/downloads/release/python-371/
2) Install [Tableau Reader](https://www.tableau.com/products/reader) to be able to open this dashboard. It is free.

### Preparing for the exercise

There was a lot of search in terms of the best way to do the ETL on this project. Considering that most of the ETL tools are paid I tried Talend Open Studio. It is not an easy GUI and after some consideration I decided this would take long to prepare. So decided to create a python script that runs a SQL file with commands to process the data. Could have opted only for the SQL itself, but Python always give the opportunity, in the future, of producing a lot of different insights and visuals with Panda, NumPy, Matplotlib and so on.

I created this script with Spyder, a software that comes with Anaconda-Navigator, as it is a good IDE and allows me to run my code inside it, instead of having to use the terminal.

Whilst creating this I used DBeaver to test all the queries and produced results. Opted for this software as it is easy to use, similar to SQL Server (which I have used plenty before) and it has been reliable, so far, as I use it on a daily basis.

For the visualizations I used one of the tools I work daily and localy, Tableau and the reason being that as I have a key for the Desktop version anything I do, since connecting to Zapier Refshift to create visuals affects no one else but me. Also is a powerful tool.

### Methodologies

* Using the table provided in Zapier database ```source_data.tasks_used_da``` I started creating a copy of it in my schema ```csilvestre``` as this is the only schema I can write to.
* Noticed when doing this that all the requests are at a user level, so didn't import ```account_id```.

### All the following relate to tables in ```csilvestre``` schema

* Created a ```date_dimension``` table to have a series of dates (as not all users used tasks every day. This will allow to create the 'missing' records per user/day. Created a few extra columns that are not needed, but in a future could be used for visualization and perhaps a different way to calculate rates.

* For all the users already in ```tasks_used_da_cs``` I checked if their ```sum_tasks_used``` was bigger than 0 for each ```full_date```, if so that user is set to active. (Used boolean as it is the most efficient way to report a status on Redshift (and other data warehouses as well).

* After this populated the ```active_user``` and ```churned_user``` following the definitions mentioned a bit below. 

* For visuals:
   - Connected directly to Redshift from Tableau. There are churn rates calculated for daily and weekly. Cohorts to view user lifeline/engagement with Zapier.
  - First used task for each user - This is used for the cohort.
  - Compared the data daily and weekly.

### How to 'execute' this project

1) ##### Python script
On the Terminal / cmd line please navigate to the provided folder and write the following command:

```
python zapier.py
```

Wait for the script to finish running - you will receive a 'Execution finished.' message. Once you see this message feel free to close the Terminal / CMD line.
This process is creating all the tables and transformations needed in order to deliver this project.

2) ##### Visualization
As a reminder, please install [Tableau Reader](https://www.tableau.com/products/reader) to be able to open this dashboard. It is free.
This was built at a day, user_id level and then the use of Level Of Detail (LOD) with Tableau allows to fix specific dates for users - which allowed the cohort being built. For the aggregations it will just sum the different measures for the related period.

### Definitions used
Active user - A user is considered active on any day where they have at least one task executed in the prior 28 days.
Churned user -  A user is considered to be churn the 28 days following their last being considered active. A user is no longer part of churn if they become active again.
Churn Rate - Total Churned users / (Total Active users + Total Churned users) (for the period)

### 'Interesting' 11 day forecasting:
* This has been done just to explore a bit the power of Tableau (please bare in mind that this is a poor trend as it doesn't have access to a lot of data to work on its precision).

##### Forecasting:
Time series:	full_date
Measures:	TotalActiveUsers, Churn Rate, TotalChurnedUsers

Forecast forward:	11 days (1 Jun 2017 - 11 Jun 2017)
Forecast based on:	1 Feb 2017 - 31 May 2017
Seasonal pattern:	None
Trend: 100%
Quality: Poor

##### Total Active Users
<table>
  <tr>
    <th>Initial</th>
    <th>Change from Initial</th>
  </tr>
  <tr>
    <td>2 Jun 2017</td>
    <td>2 Jun 2017 - 11 Jun 2017</td>
  </tr>
  <tr>
    <td>174,973	±	0.6%</td>
    <td>0.7%</td>
  </tr>
</table>


##### Total Churned Users
<table>
  <tr>
    <th>Initial</th>
    <th>Change from Initial</th>
  </tr>
  <tr>
    <td>2 Jun 2017</td>
    <td>2 Jun 2017 - 11 Jun 2017</td>
  </tr>
  <tr>
    <td>33,866	±	4.0%</td>
    <td>-8.2%</td>
  </tr>
</table>


##### Churn Rate
<table>
  <tr>
    <th>Initial</th>
    <th>Change from Initial</th>
  </tr>
  <tr>
    <td>2 Jun 2017</td>
    <td>2 Jun 2017 - 11 Jun 2017</td>
  </tr>
  <tr>
    <td>16.22%	±	4.4%</td>
    <td>-7.8%</td>
  </tr>
</table>

### Comments / Recommendations
* These are all provided inside the dashboard, as you move along the Story.

## Tools used

* [DBeaver](https://dbeaver.io/) (open source, used for a direct connection to Redshift Database and test the queries)
* [Tableau Desktop](https://www.tableau.com/products/desktop) (paid software, used for visualizations and a direct connection to Redshift)
* [Anaconda-Navigator](https://www.anaconda.com/download/) (open source, used the tool Spyder for Python development and testing)
