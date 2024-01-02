# Loan Analysis Shiny App

## Overview

The Loan Analysis Shiny App is a web application designed to assist users in analyzing and visualizing loan data. It provides a user-friendly interface to explore various aspects of loan portfolios, making it easier for stakeholders to make informed decisions.

## Features

- **Interactive Dashboard:** Visualize key loan metrics through interactive charts and graphs.
- **Data Filters:** Apply filters to customize the data displayed based on criteria such as loan amount, interest rate, and term.
- **Loan Portfolio Overview:** Quickly assess the overall health of the loan portfolio with summary statistics.
- **Risk Assessment:** Identify potential risks by exploring default rates and payment behavior.
- **Exportable Reports:** Download customized reports for further analysis or presentation.

## Getting Started

### Prerequisites

- R (version X.X.X)
- Shiny package (install using `install.packages("shiny")`)
- Other required R packages (listed in `app.R`)

### Installation

1. Clone this repository to your local machine.
2. Open the R console or RStudio.
3. Set the working directory to the location of the cloned repository.
4. Run the `app.R` script.

```R
library(shiny)
runApp("path/to/cloned/repo")
