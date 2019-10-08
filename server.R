shinyServer(function(input, output) {
  
  tab1_data <-  reactive({
    real_account %>%
    left_join(users) %>%
    filter(gender %in% input$Gender) %>%
    group_by(user_id, age_range, gender) %>%
    mutate(n_account = n(), 
           total_transaction = sum(total_num_transactions)) %>%
    group_by(age_range, gender) %>%
    mutate(av_account = mean(n_account), 
           av_transaction = mean(total_transaction))
  })
  
  tab2_data <- reactive({
    real_account %>%
    filter(account_creation_date > "1900-01-01") %>%
    mutate(account_creation_date = year(account_creation_date)) %>%
    group_by(financial_institution, account_creation_date) %>%
    summarise(num_institution = n(), 
              num_transactions = sum(total_num_transactions), 
              num_trans_per_inst = num_transactions/num_institution) %>%
    dplyr::select(-c(num_institution, num_transactions)) %>%
    filter(financial_institution %in% input$institution_chosen)
  })
  
  tab3_data <- reactive({
    real_logins %>%
      dplyr::select(-record_id) %>%
      left_join(dplyr::select(real_account, -c(account_id, 
                                               financial_institution, 
                                               total_num_transactions))) %>%
      filter(account_creation_date > "1900-01-01") %>%
      mutate(time_from_account_creation = (login_date - account_creation_date)) %>%
      filter(time_from_account_creation >=0) %>%
      dplyr::select(-account_creation_date) %>%
      left_join(dplyr::select(users, -salary_range)) %>%
      filter(registration_date > "1900-01-01") %>%
      mutate(time_from_reg = (login_date - registration_date)) %>%
      dplyr::select(-c(login_date, registration_date)) 
  })
  

  
  # ==============================================================================
  #
  # Tab 1 - USERS
  #
  # ==============================================================================  
  
  output$number_of_accounts = renderPlot({
      ggplot(tab1_data()) +
      aes(x = age_range, y = av_account, colour = gender, shape = gender) +
      geom_point(size = 3, alpha = 0.7) +
      scale_y_continuous(breaks = seq(0, 6, 1)) +
      scale_colour_brewer(palette = "Set2") +
      labs(
        title = "Is there user dependant\n number of accounts?\n", 
        x = "\nAge Range", 
        y = "Average number of Accounts\n"
      ) +
      my_theme()
  })
  
  output$number_of_transactions = renderPlot({
      ggplot(tab1_data()) +
      aes(x = age_range, y = av_transaction, colour = gender, shape = gender) +
      geom_point(size = 3, alpha = 0.7) +
      scale_colour_brewer(palette = "Set2") +
      labs(
        title = "Is there user dependant\n number of transactions?\n", 
        x = "\nAge Range", 
        y = "Average number of Transactions\n"
      ) +
      my_theme()
  })
  
  output$number_of_logins = renderPlot({
    real_logins %>%
      left_join(users) %>%
      filter(gender %in% input$Gender) %>%
      group_by(user_id, age_range, gender) %>%
      summarise(total_logins = n()) %>%
      group_by(age_range, gender) %>%
      summarise(av_login = mean(total_logins)) %>%
      ggplot() +
      aes(x = age_range, y = av_login, colour = gender, shape = gender) +
      geom_point(size = 3, alpha = 0.7) +
      scale_colour_brewer(palette = "Set2") +
      labs(
        title = "Is there user dependant\n number of logins?\n", 
        x = "\nAge Range", 
        y = "Average number of Logins\n"
      ) +
      my_theme()
  })
  
  output$users_no_account = renderPlot({
    logins %>%
      filter(user_id %in% unique(users_no_account$user_id)) %>%
      left_join(users) %>%
      filter(gender %in% input$Gender) %>%
      ggplot() +
      aes(x = age_range, fill = gender) +
      geom_bar() +
      scale_fill_brewer(palette = "Set2") +
      labs(
        title = "Who logs in without an account?\n", 
        x = "\nAge Range", 
        y = "Number of Users\n"
      ) +
      my_theme()
  })
  
  
  # ==============================================================================
  #
  # Tab 2 - Institutions
  #
  # ==============================================================================
  
  output$institution = renderPlot({
    tab2_data() %>%
      ggplot() +
      aes(x= account_creation_date, y= num_trans_per_inst, 
          colour = financial_institution, shape = financial_institution, 
                 group = financial_institution) +
      geom_point() +
      geom_line() +
      scale_x_continuous(breaks = c(2010:2019)) +
      scale_colour_brewer(palette = "Set2") +
      labs(
        title = "How many transactions per\nFinancial Institution?\n", 
        x = "\nYear of Account Creation", 
        y = "Number of Transactions\n"
      ) +
      my_theme()
  })

  
  # ==============================================================================
  #
  # Tab 3 - Logins Overtime
  #
  # ==============================================================================
  
  output$logs_overtime = renderPlot({
    tab3_data() %>%
      filter(gender %in% input$Gender, 
             account_type %in% input$Account, 
             age_range %in% input$age) %>%
      ggplot() +
        aes_string(x = input$x_value) +
        geom_histogram(aes(fill = gender), 
                       alpha = 0.5, 
                       binwidth = 1) +
        coord_cartesian(xlim = input$duration) +
        scale_fill_brewer(palette = "Set2") +
        labs(
            title = "When do user log?\n ", 
            x = "\nTime (in Days) from Account Creation\nor User Registration", 
            y = "Number of Logs\n"
      ) +
      my_theme() 
   
  })
  
  
})