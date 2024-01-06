# Install and load required packages
library(shiny)
library(dplyr)
library(ggplot2)

# Load the loan data and summary tables from the separate script
source("data/loan_data.R")
source("data/summary_tables.R")

server <- function(input, output) {
  # Define server logic for the first page
  output$selected_rm <- renderText({
    if (input$filterrm) {
      paste("Relationship Manager :", input$RM)
    } else {
    }
  })
  output$selected_month <- renderText({
    if (input$filtermonth) {
      paste("Month :", input$Month)
    } else {
    }
  })
  output$select_product <- renderText({
    if (input$filterproduct) {
      paste("Product : ", input$productInput)
    } else {
    }
  })
  
  # Total Loans Disbursed
  filterto_tal <- reactive({
    total_table
  })
  output$totalTable <- renderTable({
    filterto_tal()
  })
  # Total Interest Generated
  filterint_erest <- reactive({
    interest_table
  })
  output$interestTable <- renderTable({
    filterint_erest()
  })
  
  # 1.Product Info
  filtered_summary <- reactive({
    if (input$filterrm) {
      if (input$filterproduct) {
        if (input$filtermonth) {
          filtered_data <- summary_table %>%
            filter(Relationship_Manager == input$RM, Product == input$productInput, month == input$Month)
        } else {
          filtered_data <- summary_table %>%
            filter(Relationship_Manager == input$RM,Product == input$productInput)
        }
      } else {
        if (input$filtermonth) {
          filtered_data <- summary_table %>%
            filter(Relationship_Manager == input$RM, month == input$Month)
        } else {
          filtered_data <- summary_table %>%
            filter(Relationship_Manager == input$RM)
        }
      }
    } else {
      if (input$filterproduct) {
        if (input$filtermonth) {
          filtered_data <- summary_table %>%
            filter(Product == input$productInput, month == input$Month)
        } else {
          filtered_data <- summary_table %>%
            filter(Product == input$productInput)
        }
      } else {
        if (input$filtermonth) {
          filtered_data <- summary_table %>%
            filter(month == input$Month)
        } else {
          filtered_data <- summary_table
        }
      }
    }
    return(filtered_data)
  })
  # Products Info Output
  output$sumTable <- renderTable({
    filtered_summary()
  })
  
  # 2. Product Monthly Totals
  filtered_product <- reactive({
    if (input$filterproduct) {
      if (input$filtermonth) {
        data <- product_table %>%
          arrange(sum_loan_amount) %>%
          filter(month == input$Month,Product==input$productInput)
      } else {
        data <- product_table %>%
          arrange(sum_loan_amount) %>%
          filter(Product==input$productInput)
      }
    } else {
      if (input$filtermonth) {
        data <- product_table %>%
          arrange(sum_loan_amount) %>%
          filter(month == input$Month)
      } else {
        data <- product_table %>%
          arrange(sum_loan_amount)
      }
    }
    return(data)
  })
  # Product Monthly Totals Output
  output$productTable <- renderTable({
    filtered_product()
  })
  
  # 3. R.M. Monthly Totals
  filtered_produ <- reactive({
    if (input$filterrm) {
      if (input$filtermonth) {
        filtered_data <- produ_table %>%
          arrange(sum_loan_amount) %>%
          filter(Relationship_Manager == input$RM, month == input$Month)
      } else {
        filtered_data <- produ_table %>%
          arrange(sum_loan_amount) %>%
          filter(Relationship_Manager == input$RM)
      }
    } else {
      if (input$filtermonth) {
        filtered_data <- produ_table %>%
          arrange(sum_loan_amount) %>%
          filter(month == input$Month)
      } else {
        filtered_data <- produ_table %>%
          arrange(sum_loan_amount)
      }
    }
    return(filtered_data)
  })
  # R.M. Monthly Totals Output
  output$produTable <- renderTable({
    filtered_produ()
  })
  
  # 4. Loan Monthly Totals  
  filtered_summ <- reactive({
    if (input$filtermonth) {
      filtered_data <- summ_table %>%
        arrange(sum_loan_amount) %>%
        filter(month == input$Month)
    } else {
      filtered_data <- summ_table %>%
        arrange(sum_loan_amount)
    }
    return(filtered_data)
  })
  # Loans Monthly Totals Output
  output$summTable <- renderTable({
    filtered_summ()
  })
  
  
  # Define server logic for the second page
  output$selectedrm <- renderText({
    if (input$filterr_m) {
      paste("Relationship Manager  :", input$RM)
    } else {
    }
  })
  output$selectedmonth <- renderText({
    paste("Month:", input$Mon_th)
  })
  output$selectproduct <- renderText({
    if (input$filterprodu_ct) {
      paste("Product:", input$product_Input)
    } else {
    }
  })
  
  # R.M Performance
  # By Loans Disbursed
  filtered_manager <- reactive({
    if (input$filterr_m) {
      data <- manager_performance %>%
        filter(Relationship_Manager == input$R_M)
    } else {
      data <- manager_performance
    }
    return(data)
  })
  # By Loans Disbursed
  output$rmTable <- renderTable({
    filtered_manager()
  })
  # By Revenue
  filtered_revenue <- reactive({
    if (input$filterr_m) {
      data <- revenue_performance %>%
        filter(Relationship_Manager == input$R_M)
    } else {
      data <- revenue_performance
    }
    return(data)
  })
  # By Revenue
  output$rmrevenue <- renderTable({
    filtered_revenue()
  })
  
  # Product Performance
  # By Loans Disbursed
  filtered_pro_duct <- reactive({
    if (input$filterprodu_ct) {
      data <- product_performance %>%
        filter(Product == input$product_Input)
    } else {
      data <- product_performance
    }
    return(data)
  })
  # By Loans Disbursed
  output$pro_ductTable <- renderTable({
    filtered_pro_duct()
  })
  
  # By Revenue
  filtered_product_revenue <- reactive({
    if (input$filterprodu_ct) {
      data <- product_revenue_performance %>%
        filter(Product == input$product_Input)
    } else {
      data <- product_revenue_performance
    }
    return(data)
  })
  # By Revenue
  output$productrevenue <- renderTable({
    filtered_product_revenue()
  })
  
  # 5. Pie Chart
  filtered_produc <- reactive({
    if (input$filterr_m) {
      filtered_data <- products_table %>%
        arrange(sum_amount) %>%
        filter(Relationship_Manager == input$R_M, month == input$Mon_th)
    } else {
      filtered_data <- pro_table %>%
        arrange(sum_amount) %>%
        filter(month == input$Mon_th)
    }
    return(filtered_data)
  })
  # Monthly Distribution
  output$piePlot <- renderPlot({
    ggplot(filtered_produc(), aes(x = "", y = sum_amount, fill = Product)) +
      geom_bar(stat = "identity", width = 1, color = "black", size = 1) +
      coord_polar("y") +
      ggtitle("Pie Chart Representation of Product by Month") +
      theme_void() +
      theme(
        legend.position = "bottom",
        legend.title = element_text(size = 14, face = "bold", hjust = 0.5),
        legend.text = element_text(size = 12)
      )
  })
  
  # 6. Amount Plot
  filtered_prod <- reactive({
    prod_table %>%
      filter(Product == input$product_Input)
  })
  # Product Yearly Trend
  output$amountPlot <- renderPlot({
    ggplot(filtered_prod(), aes(x = factor(date), y = sum_amount,group=Product,color=Product)) +
      geom_line(stat='identity',color='blue') +
      labs(title = "Product Loan Trends by Month", x = "Date", y = "Amount")
  })
  
  # 7. R.M. Plot
  filtered_rel <- reactive({
    rel_table %>%
      filter(Relationship_Manager == input$R_M)
  })
  
  # R.M.Yearly Trend
  output$rmPlot <- renderPlot({
    ggplot(filtered_rel(), aes(x = factor(date), y = sum_amount,group=Relationship_Manager,color=Relationship_Manager)) +
      geom_line(stat='identity',color='blue') +
      labs(title = "R.M. Trends by Month", x = "Date", y = "Amount")
  })
  
  # 8. Year Plot
  filtered_summy<- reactive({
    summy_table
  })
  # Loans Yearly Trend
  output$yearPlot <- renderPlot({
    ggplot(filtered_summy(),aes(x = date, y = sum_amount)) +
      geom_line() +
      labs(title = "Loan Trends by Month", x = "Date", y = "Amount")
  })
}