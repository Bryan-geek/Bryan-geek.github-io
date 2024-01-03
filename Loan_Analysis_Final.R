# Install and load required packages
# install.packages(c("shiny", "dplyr", "ggplot2"))

library(shiny)
library(dplyr)
library(ggplot2)

# Create a sample dataframe
set.seed(123)

relationship_managers <- c("John Doe", "Jane Smith", "Robert Johnson")
# Function to generate interest rates based on loan amount
generate_interest_rate <- function(amount) {
  if (amount <= 2000) {
    return(runif(1, min = 3, max = 6))
  } else {
    return(runif(1, min = 4, max = 9))
  }
}
# Function to generate default rates
generate_default_rate <- function() {
  return(runif(1, min = 0.01, max = 0.10))
}

n <- 300
loan_data <- data.frame(
  loan_id = 1:n,
  Relationship_Manager = sample(relationship_managers, n, replace = TRUE),
  Product = sample(c("Personal Loan", "Asset Finance", "Mortgage", "Secured Loan", "Unsecured Loan"), n, replace = TRUE),
  amount = sample(1000:100000, n, replace = TRUE),
  period = sample(1:5, n, replace = TRUE),
  date = sample(seq(as.Date('2022-01-01'), as.Date('2022-12-01'), by="month"), n, replace = TRUE)
)

# Assigning interest rates based on loan amount
loan_data$interest_rate <- sapply(loan_data$amount, generate_interest_rate)

# Assigning default rates
loan_data$default_rate <- sapply(1:n, function(loan_id) {
  generate_default_rate()
})

# Calculate total interest after period
calculate_total_interest <- function(amount, interest_rate, period) {
  # Assuming simple interest formula: interest = principal * rate * time
  interest <- amount * (interest_rate / 100) * period
  return(interest)
}

# Applying the function to create a new column for total interest
loan_data$total_interest <- mapply(
  calculate_total_interest,
  loan_data$amount,
  loan_data$interest_rate,
  loan_data$period
)

# Calculate total loan after period
calculate_total_loan <- function(amount, total_interest) {
  total_loan <- amount + total_interest
  return(total_loan)
}

loan_data$total_loan <- mapply(
  calculate_total_loan,
  loan_data$amount,
  loan_data$total_interest
)

#Format date
loan_data = loan_data %>%
  arrange(date)
loan_data$month = format(loan_data$date, "%B")
#View(loan_data)


# Define the Shiny app UI
ui <- fluidPage(
  titlePanel(h3("Loans Analysis by Product and Month in 2022", style = "text-align:center;font-weight:bold")),
  sidebarLayout(
    #sidebarPanel(
    #  
    #),
    sidebarPanel(
      checkboxInput("filtermonth", "Filter by Month", value = FALSE),
      checkboxInput("filterproduct", "Filter by Product", value = FALSE),
      selectInput("RM", "Select Relationship Manager:", choices = unique(loan_data$Relationship_Manager)),
      selectInput("productInput", "Select Product:", choices = unique(loan_data$Product)),
      selectInput("Month", "Select Month:", choices = unique(loan_data$month))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Product Trend",plotOutput("amountPlot")),
        tabPanel("Monthly Distribution",plotOutput("piePlot")),
        tabPanel("Loans Year Trend",plotOutput("yearPlot"))
      ),  
      tabsetPanel(
        tabPanel("Products Info",tableOutput("sumTable")),
        tabPanel("Product Monthly Totals",tableOutput("productTable")),
        tabPanel("Product Year Totals",tableOutput("produTable")),
        tabPanel("Loans Monthly Totals",tableOutput("summTable"))
      )
    )
  )
)
#Create summary tables
summary_table <- loan_data %>%
  group_by(Relationship_Manager, loan_id, Product, month, period, total_interest, total_loan) %>%
  summarise(loan_amount = sum(amount)) 

summ_table <- loan_data %>%
  group_by(month) %>%
  summarise(sum_amount = sum(amount))

summy_table <- loan_data %>%
  group_by(date) %>%
  summarise(sum_amount = sum(amount))

product_table <- loan_data %>%
  group_by(Product, month) %>%
  summarise(sum_amount = sum(amount))

produ_table <- loan_data %>%
  group_by(Product) %>%
  summarise(sum_amount = sum(amount))

prod_table <- loan_data %>%
  group_by(Product, date, month) %>%
  summarise(sum_amount = sum(amount))


#View(product_table)

# Define the Shiny app server logic
server <- function(input, output) {
  filtered_prod <- reactive({
    prod_table %>%
      filter(Product == input$productInput)
  })
  filtered_summary <- reactive({
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
    return(filtered_data)
  })
    
  filtered_summ <- reactive({
    summ_table %>%
      arrange(sum_amount) %>%
      filter(month == input$Month)
  })
  filtered_summy<- reactive({
    summy_table
  })
  
  filtered_product <- reactive({
    if (input$filterproduct) {
      data <- product_table %>%
        arrange(sum_amount) %>%
        filter(month == input$Month,Product==input$productInput)
    } else {
      data <- product_table %>%
        arrange(sum_amount) %>%
        filter(month == input$Month)
    }
  })
  
  filtered_produc <- reactive({
    product_table %>%
      arrange(sum_amount) %>%
      filter(month == input$Month)
  })
  filtered_produ <- reactive({
    produ_table %>%
      filter(Product == input$productInput)
  })
  
  output$amountPlot <- renderPlot({
    ggplot(filtered_prod(), aes(x = factor(date), y = sum_amount,group=Product,color=Product)) +
      geom_line(stat='identity',color='blue') +
      labs(title = "Loan Trends by Product and Month", x = "Date", y = "Amount")
  })
  output$yearPlot <- renderPlot({
    ggplot(filtered_summy(),aes(x = date, y = sum_amount)) +
      geom_line() +
      labs(title = "Loan Trends by Month", x = "Date", y = "Amount")
  })
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
  output$sumTable <- renderTable({
      filtered_summary()
  })
  output$summTable <- renderTable({
      filtered_summ()
  })
  output$productTable <- renderTable({
    filtered_product()
  })
  output$produTable <- renderTable({
    filtered_produ()
  })
}

# Run the Shiny app
shinyApp(ui, server)
