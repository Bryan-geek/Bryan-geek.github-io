# Install and load required packages
library(shiny)
library(shinythemes)

# Load the loan data from the separate script
source("Data Scripts/loan_data.R")

#Define UI for the first page
ui_page1 <- fluidPage(
  titlePanel(h1("Loans by Product and Month in 2022", style = "text-align:center; font-weight:bold; font-family: Times New Roman, Times, serif; text-decoration-line: underline;")),
  sidebarLayout(
    sidebarPanel(
      (h3("Filters")),
      checkboxInput("filterrm", "Filter by Relationship Manager", value = FALSE),
      selectInput("RM", "Select Relationship Manager:", choices = unique(loan_data$Relationship_Manager)),
      checkboxInput("filtermonth", "Filter by Month", value = FALSE),
      selectInput("Month", "Select Month:", choices = unique(loan_data$month)),
      checkboxInput("filterproduct", "Filter by Product", value = FALSE),
      selectInput("productInput", "Select Product:", choices = unique(loan_data$Product)),
      h3(tableOutput("totalTable")),
      h3(tableOutput("interestTable")),
    ),
    mainPanel(
      (h3("Loan Data and Summaries", style = "text-align:center; font-weight:bold; text-decoration-line: underline; font-weight:bold; font-family: Georgia, Times, serif;")),
      h4(textOutput("selected_rm"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      h4(textOutput("selected_month"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      h4(textOutput("select_product"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      tabsetPanel(
        tabPanel("Loans Info",tableOutput("sumTable")),
        tabPanel("Product Monthly Totals",tableOutput("productTable")),
        tabPanel("R.M. Monthly Totals",tableOutput("produTable")),
        tabPanel("Loans Monthly Totals",tableOutput("summTable"))
      )
    )
  )
)

# Define UI for the second page
ui_page2 <- fluidPage(
  titlePanel(h1("Exploratory Analysis of Loan Data", style = "text-align:center; font-weight:bold; text-decoration-line: underline; font-weight:bold; font-family: Times New Roman, Times, serif;")),
  sidebarLayout(
    sidebarPanel(
      (h3("Filters")),
      helpText("Filters Monthly Distribution by default"),
      selectInput("Mon_th", "Select Month:", choices = unique(loan_data$month)),
      helpText("Filters R.M. Yearly Trend by default"),
      selectInput("R_M", "Select Relationship Manager:", choices = unique(loan_data$Relationship_Manager)),
      helpText("Filters Product Yearly Trend by default"),
      selectInput("product_Input", "Select Product:", choices = unique(loan_data$Product)),
      br(),
      helpText("Filters Monthly Distribution and Annual Performance Analysis for R.M. Performance when enabled"),
      checkboxInput("filterr_m", "Filter by Relationship Manager", value = FALSE),
      helpText("Filters Annual Performance Analysis for Product Performance when enabled"),
      checkboxInput("filterprodu_ct", "Filter by Product", value = FALSE),
    ),
    mainPanel(
      h3("Graphical Representation", style = "text-align:center; font-weight:bold; text-decoration-line: underline; font-weight:bold; font-family: Georgia, Times, serif;"),
      h4(textOutput("selectedrm"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      h4(textOutput("selectedmonth"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      tabsetPanel(
        tabPanel("Monthly Distribution",plotOutput("piePlot")),
        tabPanel("Product Yearly Trend",plotOutput("amountPlot")),
        tabPanel("R.M. Yearly Trend",plotOutput("rmPlot")),
        tabPanel("Loans Yearly Trend",plotOutput("yearPlot"))
      ),
      h2("Annual Perfomance Analysis", style = "text-align:center;"),
      h4(textOutput("selectproduct"), style = "font-weight:bold; font-family: Garamond, Times, sans-serif;"),
      h3("By Loans Disbursed"),
      tabsetPanel(
        tabPanel("R.M. Perfomance",tableOutput("rmTable")),
        tabPanel("Product Perfomance",tableOutput("pro_ductTable"))
      ),
      h3("By Revenue (Interest)"),
      tabsetPanel(
        tabPanel("R.M. Perfomance",tableOutput("rmrevenue")),
        tabPanel("Product Perfomance",tableOutput("productrevenue"))
      )
    )
  )
)


# Define the main UI components for the app
ui <- navbarPage(
  title = h4("Overall Loan Analysis", style = "font-weight:bold; font-family: Garamond, Times, serif;"),
  tabPanel("Page 1", ui_page1),
  tabPanel("Page 2", ui_page2)
)
