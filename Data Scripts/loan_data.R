# Install and load required packages
library(dplyr)

# Create sample data for analysis
set.seed(123)

relationship_managers <- c("John Doe", "Jane Smith", "Robert Johnson", "Bryan Armstrong", " Claudia Jane")

n <- 300

loan_data <- data.frame(
  loan_id = 1:n,
  Relationship_Manager = sample(relationship_managers, n, replace = TRUE),
  Product = sample(c("Personal Loan", "Asset Finance", "Mortgage", "Secured Loan", "Unsecured Loan"), n, replace = TRUE),
  amount = sample(1000:100000, n, replace = TRUE),
  period = sample(1:15, n, replace = TRUE),
  date = sample(seq(as.Date('2022-01-01'), as.Date('2022-12-01'), by="month"), n, replace = TRUE)
)

# Function to generate default rates
generate_default_rate <- function() {
  return(runif(1, min = 0.01, max = 0.10))
}
# Assigning default rates
loan_data$default_rate <- sapply(1:n, function(loan_id) {
  generate_default_rate()
})

# Function to generate interest rates based on product and period
generate_interest_rate <- function(amount,period,Product) {
  if (amount <= 5000) {
    if (period <= 5) {
      if (Product == "Personal Loan") {
        return(runif(1, min = 3, max = 5))
      } else if (Product == "Asset Finance") {
        return(runif(1, min = 3, max = 5))
      } else if (Product == "Mortgage") {
        return(runif(1, min = 3, max =6))
      } else if (Product == "Secured Loan") {
        return(runif(1, min = 3, max = 6))
      } else if (Product == "Unsecured Loan") {
        return(runif(1, min = 4, max = 7))
      }
    } else if (period > 5) {
      if (Product == "Personal Loan") {
        return(runif(1, min = 6, max = 8))
      } else if (Product == "Asset Finance") {
        return(runif(1, min = 6, max = 8))
      } else if (Product == "Mortgage") {
        return(runif(1, min = 6, max = 9))
      } else if (Product == "Secured Loan") {
        return(runif(1, min = 6, max = 8))
      } else if (Product == "Unsecured Loan") {
        return(runif(1, min = 8, max = 10))
      }
    }
  } else {
    if (period <= 5) {
      if (Product == "Personal Loan") {
        return(runif(1, min = 5, max = 7))
      } else if (Product == "Asset Finance") {
        return(runif(1, min = 5, max = 7))
      } else if (Product == "Mortgage") {
        return(runif(1, min = 5, max = 8))
      } else if (Product == "Secured Loan") {
        return(runif(1, min = 5, max = 7))
      } else if (Product == "Unsecured Loan") {
        return(runif(1, min = 6, max = 9))
      }
    } else if (period > 5) {
      if (Product == "Personal Loan") {
        return(runif(1, min = 8, max = 10))
      } else if (Product == "Asset Finance") {
        return(runif(1, min = 8, max = 11))
      } else if (Product == "Mortgage") {
        return(runif(1, min = 8, max = 11))
      } else if (Product == "Secured Loan") {
        return(runif(1, min = 8, max = 10))
      } else if (Product == "Unsecured Loan") {
        return(runif(1, min = 10, max = 12))
      }
    }
  }
}
# Assigning interest rates based on product and period
loan_data$interest_rate <- mapply(
  generate_interest_rate,
  loan_data$period,
  loan_data$amount,
  loan_data$Product)


# Calculate total interest after period
calculate_total_interest <- function(amount, interest_rate, period) {
  # Assuming compound interest formula: total_amount = principal * (1 + rate) ^ time
  total_amount <- amount * (1 + (interest_rate / 100)) ^ period
  interest <- total_amount - amount
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
calculate_total_loan <- function(amount, interest_rate, period) {
  total_loan <- amount * (1 + (interest_rate / 100)) ^ period
  return(total_loan)
}
# Applying the function to create a new column for total loan
loan_data$total_loan <- mapply(
  calculate_total_loan,
  loan_data$amount,
  loan_data$interest_rate,
  loan_data$period
)

# Format date
loan_data = loan_data %>%
  arrange(date)
loan_data$month = format(loan_data$date, "%B")
