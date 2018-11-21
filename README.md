# Monthly Active Users (MAU) Project

This project was created to provide an understanding of my SQL, analysis and visualization skills when appplied to calculate the daily active users and churn rate.

## Requirement

### Part one - get acquainted to the data structure

### Part two:
# Create a data model on top of the current structure to manipulate the data
* Active user: A user is considered active on any day where they have at least one task executed in the prior 28 days.
* Churn: A user is considered to be churn 28 days after their last being considered active. A user is no longer part of churn if he becomes active again.

### Part three:
Analyze and visualize Monthly Active Users and churn over time: create an analysis that is ready to share with an internal stakeholder that helps them understand the relationship between monthly active users and churn.

## Getting Started

These instructions will get this project up and running on a local machine.
This solution was tested on both macOS and Windows systems.

### Prerequisites
1) Install Python 3.7 available on https://www.python.org/downloads/release/python-371/
2) The packages needed for the project are installed with this distribution.
3) To be able to visualize the data please install Tableau Reader available on https://www.tableau.com/products/reader. This is free.
4) If using Windows make sure Python is in the PATH.

### Preparing for the exercise

There was a lot of search in terms of the best way to do the ETL on this project. Considering that most of the ETL tools are paid I tried Talend Open Studio. It is not an easy GUI and after some consideration I decided this would take long to prepare. So decided to create a python script that runs a SQL file with commands to process the data. Could have opted only for the SQL file, but decided to also show a bit of python skills, even if as this level they are pretty basic.

I created this script with Spyder, that is a software that comes with Anaconda-Navigator but can be open in any text editor and edited. The same applies to compiling and executing, can be done in Spyder or just in the Terminal / cmd line.

Whilst creating this I used DBeaver to test all the queries and produced results. Opted for this software as it is easy to use, similar to SQL Server (which I have used plenty before) and it has been reliable, so far, as I use it on a daily basis.

For the visualizations, despite using Looker daily, Looker is a paid tool and not as easy as Tableau to connect to an external datasource. So, my option here was to go for Tableau.

### How to proceed

On the Terminal / cmd line please navigate to the provided folder and write the following command:

```
python zapier.py
```

Wait for the script to finish running. This is creating all the tables and transformations needed in order to deliver this project.
Once you see the message 'All Done,' feel free to close the Terminal / cmd line.

## Visualization




### Comments / Recommendations





## Tools used

* [DBeaver](https://dbeaver.io/) (open source, used for a direct connection to Redshift Database and test the queries)
* [Tableau Desktop](https://www.tableau.com/products/desktop) (paid software, used for visualizations and a direct connection to Redshift)
* [Anaconda-Navigator](https://www.anaconda.com/download/) (open source, used the tool Spyder for Python development and testing)
