library(lubridate)
library(shiny)
library(tidyverse)
library(shinydashboard)


############################################################################
#
#    LOAD FUNCTION
#
############################################################################

source("functions/plot_theme.R")



############################################################################
#
#    LOAD THE DATA
#
############################################################################

account <-  read_delim("data/Accounts_20190606.csv", 
                       delim = "|", 
                       escape_double = TRUE)

logins <-  read_delim("data/Logins_20190606.csv", 
                      delim = "|", 
                      escape_double = TRUE)

users <-  read_delim("data/Users_20190606.csv", 
                     delim = "|", 
                     escape_double = TRUE)

#ACCOUNT
column_names_account <- c( "user_id", "account_id", "account_creation_date", 
                           "account_type", "financial_institution", 
                           "total_num_transactions")
colnames(account) <- column_names_account

account$account_creation_date <- dmy(account$account_creation_date)
account$user_id <- as.character(account$user_id)
account$account_id <- as.character(account$account_id)

#LOGINS
column_names_logins <- c("record_id", "user_id", "login_date")
colnames(logins) <- column_names_logins
logins$user_id <- as.character(logins$user_id)
logins$login_date <- dmy(logins$login_date)


#USERS
column_names_users <- c("user_id", "gender", "age_range", "salary_range", 
                        "registration_date")
colnames(users) <- column_names_users

# changing the date column from character to date
users$registration_date <- dmy(users$registration_date)
users$user_id <- as.character(users$user_id)

############################################################################
#
#    REMOVE OUTLIERS
#
############################################################################

# users without account
users_no_account <- users %>%
  left_join(account, by = "user_id") %>%
  filter(is.na(account_id)) 


# users with many accounts
high_account_n <- users %>%
  left_join(account, by = "user_id") %>%
  filter(!is.na(account_id)) %>%
  group_by(user_id) %>%
  summarise(num_account = n()) %>%
  filter(num_account >= 8)


# removing outliers from account
real_account <- account %>%
  filter(!(user_id %in% unique(high_account_n$user_id))) 

# removing outliers from logins
real_logins <-  logins %>%
  filter(!(user_id %in% unique(high_account_n$user_id)), 
         !(user_id %in% unique(users_no_account$user_id)))







