# Install and load required packages
library(dplyr)

# Create summary tables
# For use in first page

#Total Loans Amount
total_table <- loan_data %>%
  summarise(Total_Loan_Disbursed = sum(amount)) %>%
  mutate(Total_Loan_Disbursed = scales::dollar(Total_Loan_Disbursed))
#Total Interest Generated
interest_table <- loan_data %>%
  summarise(Total_Interest_Generated = sum(total_interest)) %>%
  mutate(Total_Interest_Generated = scales::dollar(Total_Interest_Generated))

# 1. Product Info
summary_table <- loan_data %>%
  group_by(Relationship_Manager, loan_id, Product, month, period,interest_rate, total_interest, total_loan) %>%
  summarise(loan_amount = sum(amount)) %>%
  arrange(total_loan) %>%
  mutate(interest_rate = scales::percent(interest_rate / 100)) %>%
  mutate(total_loan = scales::dollar(total_loan)) %>%
  mutate(loan_amount = scales::dollar(loan_amount)) %>%
  mutate(total_interest = scales::dollar(total_interest))
# 2. Product Monthly Totals
product_table <- loan_data %>%
  group_by(Product, month) %>%
  summarise(sum_loan_amount = sum(amount),sum_interest = sum(total_interest),sum_loan_total = sum(total_loan)) %>%
  arrange(sum_loan_total) %>%
  mutate(sum_loan_total = scales::dollar(sum_loan_total)) %>%
  mutate(sum_loan_amount = scales::dollar(sum_loan_amount)) %>%
  mutate(sum_interest = scales::dollar(sum_interest))
# 3. R.M. Month Totals
produ_table <- loan_data %>%
  group_by(Relationship_Manager, month) %>%
  summarise(sum_loan_amount = sum(amount),sum_interest = sum(total_interest),sum_loan_total = sum(total_loan)) %>%
  arrange(sum_loan_total) %>%
  mutate(sum_loan_total = scales::dollar(sum_loan_total)) %>%
  mutate(sum_loan_amount = scales::dollar(sum_loan_amount)) %>%
  mutate(sum_interest = scales::dollar(sum_interest))
# 4. Loan Monthly Totals
summ_table <- loan_data %>%
  group_by(month) %>%
  summarise(sum_loan_amount = sum(amount),sum_interest = sum(total_interest),sum_loan_total = sum(total_loan)) %>%
  arrange(sum_loan_total) %>%
  mutate(sum_loan_total = scales::dollar(sum_loan_total)) %>%
  mutate(sum_loan_amount = scales::dollar(sum_loan_amount)) %>%
  mutate(sum_interest = scales::dollar(sum_interest))


# For use in second page
# R.M Performance
# By Loans Disbursed
manager_performance <- loan_data %>%
  group_by(Relationship_Manager,) %>%
  summarise(manager_total_loan = sum(amount))
overall_total_loan <- sum(manager_performance$manager_total_loan)
manager_performance <- manager_performance %>%
  mutate(percentage_of_total = scales::percent(manager_total_loan / overall_total_loan)) %>%
  mutate(manager_total_loan = scales::dollar(manager_total_loan)) %>%
  arrange(desc(percentage_of_total))

# By Revenue
revenue_performance <- loan_data %>%
  group_by(Relationship_Manager,) %>%
  summarise(manager_total_revenue = sum(total_interest))
overall_total_revenue <- sum(revenue_performance$manager_total_revenue)
revenue_performance <- revenue_performance %>%
  mutate(percentage_of_total = scales::percent(manager_total_revenue / overall_total_revenue)) %>%
  mutate(manager_total_revenue = scales::dollar(manager_total_revenue)) %>%
  arrange(desc(percentage_of_total))

# Product Performance
#By Loans Disbursed
product_performance <- loan_data %>%
  group_by(Product,) %>%
  summarise(product_total_loan = sum(amount))
overall_total_product_loan <- sum(product_performance$product_total_loan)
product_performance <- product_performance %>%
  mutate(percentage_of_total = scales::percent(product_total_loan / overall_total_product_loan)) %>%
  mutate(product_total_loan = scales::dollar(product_total_loan)) %>%
  arrange(desc(percentage_of_total))

# By Revenue
product_revenue_performance <- loan_data %>%
  group_by(Product,) %>%
  summarise(product_total_revenue = sum(total_interest))
overall_total_product_revenue <- sum(product_revenue_performance$product_total_revenue)
product_revenue_performance <- product_revenue_performance %>%
  mutate(percentage_of_total = scales::percent(product_total_revenue / overall_total_product_revenue)) %>%
  mutate(product_total_revenue = scales::dollar(product_total_revenue)) %>%
  arrange(desc(percentage_of_total))

# 5. Pie Chart
products_table <- loan_data %>%
  group_by(Relationship_Manager, Product, month) %>%
  summarise(sum_amount = sum(amount))
# 5. Pie Chart
pro_table <- loan_data %>%
  group_by(Product, month) %>%
  summarise(sum_amount = sum(amount))
# 6. Amount Plot
prod_table <- loan_data %>%
  group_by(Product, date, month) %>%
  summarise(sum_amount = sum(amount))
# 7. R.M. Plot
rel_table <- loan_data %>%
  group_by(Relationship_Manager, date, month) %>%
  summarise(sum_amount = sum(amount))
# 8. Year Plot
summy_table <- loan_data %>%
  group_by(date) %>%
  summarise(sum_amount = sum(amount))
