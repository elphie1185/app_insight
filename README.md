# Client project - App insight

## Project_scope

The client would like to better understand how their users interact with their app and who they are. 
Any insights was feedback to the client as well as ways to improve app usage. 


To illustrate this the dashboard answers the following data sets were provided: 
  - User data, including gender and age range
  - Account data, including financial institutions and type of accounts
  - Logins data


## Tools

The dashboard was created in R using shinydashboard. The results presented using R markdown and CSS.
The following libraries were used: 
- library(lubridate)
- library(shiny)
- library(tidyverse)
- library(shinydashboard)
- library(MASS)
- library(caret)



## Dashboard
### User insights

The first tab of the dashboard presents user insight. 
- Who are the user of the app?
- How do they interact with the app?
- Who are the users who register and then not use it?

![](/screenshots/Screenshot%202019-10-08%20at%2017.53.09.png)



### Financial Institutions Insights

In this section we are looking into the ease of use of the app with different financial institutions. 
Which are the institutions were the number of transactions decline? And is this the result of an interactivity issue? 


![](/screenshots/Screenshot%202019-10-08%20at%2017.53.35.png)

### Over Time Use
 
How do user behaviour changes over time? Who interacts with the app and when?

![](/screenshots/Screenshot%202019-10-08%20at%2017.54.04.png)


## Authors
Delphine Rabiller
