from shiny import App, render, ui, reactive
import pandas as pd
import numpy as np
import htmltools
import shinyswatch
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

# Create sample data

np.random.seed(123)

n = 500
loan_data = pd.DataFrame({
    'loan_id': range(1, n + 1),
    'product': np.random.choice(["Personal Loan", "Asset Finance", "Mortgage", "Unsecured Loan", "Secured Loan"], n, replace=True),
    'amount': np.random.choice(range(1000, 1000001), n, replace=True),
    'date': np.random.choice(pd.date_range('2022-01-01', '2023-01-01', freq='M').sort_values(), n, replace=True),
})
loan_data = loan_data.sort_values(by=['date']).reset_index()
loan_data['month'] = loan_data['date'].dt.strftime("%B")

product_choices = loan_data["product"].unique().tolist()
month_choices = loan_data["month"].unique().tolist()


# Create summary tables
summar_table = loan_data.groupby(['loan_id', 'product', 'month']).agg(sum_amount=('amount', 'sum')).reset_index()
prod_table = loan_data.groupby(['product', 'month']).agg(sum_amount=('amount', 'sum')).reset_index()
monthly_table = loan_data.groupby(['month']).agg(sum_amount=('amount', 'sum')).reset_index()

prody_table = prod_table.sort_values(by='sum_amount').reset_index(drop=True)

app_ui = ui.page_fluid(
    shinyswatch.theme.simplex(),
    ui.div(
        {"style":"text-align: center; font_weight: bold"},
        ui.panel_title("Loan Analysis of Products by Month in 2022")
        ),
    ui.layout_sidebar(
        ui.panel_sidebar(
            ui.input_select("Product_input", "Select Product:", choices = product_choices),
            ui.input_select("month_input", "Select Month:", choices = month_choices),
            ui.h2('Best Performing Product')
            ),
        ui.panel_main(
            ui.navset_card_tab(
                ui.nav("Product_Info", ui.output_table("summary_table")),
                ui.nav("Product_Summary", ui.output_table("product_table")),
                ui.nav("Monthly_Summary", ui.output_table("month_table")),
                ui.nav(ui.output_text_verbatim("txt"))
            ),
            ui.div(
                {"style":"background-colour: red;"},
                ui.navset_card_tab(
                    ui.nav("Product Trend", ui.output_plot("productplot")),
                    ui.nav("Pie Chart", ui.output_plot("pieplot")),
                    ui.nav("Monthly Loans Trend", ui.output_plot("lineplot")),
                )
            )                    
        )
    )
)

def server(input, output, session):
    @output
    @render.table
    def summary_table():
        filtered_summar_table = summar_table[summar_table['month'] == input.month_input()]
        filtered_summary_table = filtered_summar_table[filtered_summar_table['product'] == input.Product_input()]
        return filtered_summary_table
    
    @output
    @render.table
    def product_table():
        filtered_product_table = prody_table[prody_table['month'] == input.month_input()]
        return filtered_product_table
    
    @output
    @render.table
    def month_table():
        filter_data = loan_data.groupby('date')['amount'].sum().reset_index()
        filter_data['date'] = filter_data['date'].dt.strftime('%B')
        return filter_data
    
    @output
    @render.plot
    def productplot():
        trend_data = loan_data.groupby(['product','date']).agg(sum_amount=('amount', 'sum')).reset_index()
        trendy_data = trend_data.sort_values(by='date').reset_index()
        trendy_data['date'] = trendy_data['date'].dt.strftime('%b')
        filtered_product_table = trendy_data[trendy_data['product'] == input.Product_input()]
                
        # Create line graph
        fig, ax = plt.subplots()
        fig.set_facecolor('#99ccff')
        ax.plot(filtered_product_table['date'], filtered_product_table['sum_amount'], marker='o', linestyle='-', color='b')
        ax.set_title('Trend of Loan Amounts for Specific Products Over Time')
        ax.set_xlabel('Month')
        ax.set_ylabel('Total Loan Amount')
        ax.grid(True)
        return fig
    
    @output
    @render.plot
    def pieplot():
        filtered_product_table = prod_table[prod_table['month'] == input.month_input()]
        sizes = filtered_product_table['sum_amount'].tolist()
        labels = filtered_product_table['product'].tolist()
        
        # Create pie chart
        fig, ax=plt.subplots()
        fig.set_facecolor('#99ccff')
        ax.pie(sizes, labels=labels, autopct='%1.1f%%', startangle=140, wedgeprops=dict(width=0.5, edgecolor='w'))
        ax.axis('equal')
        plt.title('Distribution of Products in Loan Data')
        ax.legend()
        ax.grid()
        return fig
    
    @output
    @render.plot
    def lineplot():
        trend_data = loan_data.groupby('date')['amount'].sum().reset_index()
        trendy_data = trend_data.sort_values(by='date').reset_index()
        trendy_data['month'] = trendy_data['date'].dt.strftime('%b')
        
        # Create line graph
        fig, ax = plt.subplots()
        fig.set_facecolor('#99ccff')
        ax.plot(trendy_data['month'], trendy_data['amount'], marker='o', linestyle='-', color='b')
        ax.set_title('Trend of Total Loan Amounts Over Time')
        ax.set_xlabel('Month')
        ax.set_ylabel('Total Loan Amount')
        ax.grid(True)
        return fig
            
app = App(app_ui, server)
