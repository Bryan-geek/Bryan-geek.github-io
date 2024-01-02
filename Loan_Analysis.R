# Install and load required packages
# install.packages(c("shiny", "dplyr", "ggplot2"))

library(shiny)
library(dplyr)
library(ggplot2)

# Create a sample dataframe
set.seed(123)

n <- 200

loan_data <- data.frame(
  loan_id = 1:n,
  product = sample(c("Personal Loan", "Car Loan", "Home Loan"), n, replace = TRUE),
  amount = sample(1000:5000, n, replace = TRUE),
  date = sample(seq(as.Date('2022-01-01'), as.Date('2023-01-01'), by="month"), n, replace = TRUE)
)
loan_data <- loan_data %>%
  arrange(date)
loan_data$month = format(loan_data$date, "%B")
loan_data$Amount <- format(loan_data$amount, big.mark = ",")
View(loan_data)


# Define the Shiny app UI
ui <- fluidPage(
  titlePanel("Loan Amounts by Product and Month in 2022"),
  sidebarLayout(
    sidebarPanel(
      selectInput("productInput", "Select Product:", choices = unique(loan_data$product)),
      selectInput("Month", "Select Month:", choices = unique(loan_data$month))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Bar Graph",plotOutput("amountPlot")),
        tabPanel("Pie Chart",plotOutput("piePlot"))
      ),  
      tabsetPanel(
        tabPanel("Products Info",tableOutput("sumTable")),
        tabPanel("Product Summary",tableOutput("productTable")),
        tabPanel("Monthly Summary",tableOutput("summTable"))
      )
    )
  )
)

summary_table <- loan_data %>%
  #arrange(date) %>%
  group_by(loan_id, product, month) %>%
  summarise(sum_amount = sum(amount))
  #arrange(date)
summary_table$Sum_Amount <- format(summary_table$sum_amount, big.mark = ",")
View(summary_table)

summ_table <- loan_data %>%
  group_by(month) %>%
  summarise(sum_amount = sum(amount))

product_table <- loan_data %>%
  #arrange(month) %>%
  group_by(product, date) %>%
  #arrange(date) %>%
  summarise(sum_amount = sum(amount))
View(product_table)

# Define the Shiny app server logic
server <- function(input, output) {
  filtered_data <- reactive({
    product_table %>%
      arrange(date,product) %>%
      filter(product == input$productInput)
  })
  filtered_summary <- reactive({
    summary_table %>%
      group_by(loan_id, product, month,Sum_Amount) %>%
      filter(product == input$productInput, month == input$Month)
  })
  filtered_summ <- reactive({
    summ_table %>%
      filter(month == input$Month)
  })
  filtered_product <- reactive({
    product_table %>%
      filter(month == input$Month)
  })
  
  output$amountPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = month, y = sum_amount,group=product,color=product)) +
      geom_line() +
      labs(title = "Loan Amounts by Product and Month", x = "Loan ID", y = "Amount")
  })
  output$piePlot <- renderPlot({
    ggplot(filtered_product(), aes(x = "", y = sum_amount, fill = product)) +
      geom_bar(stat = "identity", width = 1, color = "red", size = 1) +
      coord_polar("y") +
      ggtitle("Pie Chart Representation of Product by Month") +
      theme_void() +
      theme(
        legend.position = "bottom",
        legend.title = element_text(size = 14, face = "bold", hjust = 0.5),
        #legend.title = toupper(legend.title),
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
}
#View(summary_table)


# Run the Shiny app
shinyApp(ui, server)

