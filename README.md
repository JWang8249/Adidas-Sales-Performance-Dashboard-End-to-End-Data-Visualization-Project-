# 🏷️ Adidas Sales Performance Dashboard

**Author:** Jingyi (Justin) Wang
**Institution:** Tilburg University – Data Science & Society  
**Purpose:** End-to-End Data Analytics Project — transforming raw Adidas sales CSV data into structured SQL tables and business dashboards.

---

## 📊 Project Overview

This project demonstrates a complete **ETL + Analytics pipeline** combining Python (for data cleaning and visualization) and **SQL (for schema design and analytics)**.

Workflow summary:

1. **Extract & Clean** raw Adidas sales data via Python  
2. **Transform & Model** data in SQL (via DataGrip)  
3. **Load** into SQLite database (`adidas.db`)  
4. **Visualize** KPIs & trends using Python (Matplotlib + Seaborn) and Power BI

---

---

## 📝 Business Report

A comprehensive **Adidas U.S. Sales Performance Report (2020–2021)** is included in this project.  
It contains executive insights, KPI analysis, SQL-driven findings, visual interpretation, and strategic recommendations based on the full ETL + Analytics pipeline.

📄 **Full Report (Markdown):**  
[`Adidas_Sales_Report_Full.md`](/reports/Adidas_Sales_Report_Full.md)

The report covers:
- Executive Summary  
- Regional & Retailer Performance  
- Pricing & Volume Elasticity Analysis  
- Monthly Trend Interpretation  
- Correlation & KPI Insights  
- Strategic Recommendations & Business Implications  

This serves as a business-facing document demonstrating data storytelling, analytical reasoning, and decision-making capabilities derived from the dataset.

---

## 📁 Project Structure

```
Adidas-Sales-Dashboard/
│
├── data/
│   ├── raw/
│   │   └── adidas_sales.csv
│   ├── processed/
│   │   └── adidas.db
│
├── reports/
│   ├── Adidas_Sales_Report_Full.md
│   └── figures/
│       ├── retailer_sales.png
│       ├── region_sales.png
│       ├── monthly_trend.png
│       └── correlation_heatmap.png

│
├── src/
│   ├── __init__.py
│   ├── clean_csv.py
│   ├── sql_queries.py          # Demonstration: Python executes .sql files
│   ├── visualization.py
│   ├── data_cleaning.sql       # Core SQL for data transformation (executed in DataGrip)
│   └── sql_queries.sql         # Core SQL for analytical queries (executed in DataGrip)
│
├── requirements.txt
└── README.md
```

---

## ⚙️ Environment Setup

### 1️⃣ Create a Virtual Environment
```bash
python -m venv venv
source venv/bin/activate     # macOS/Linux
venv\Scripts\activate        # Windows
```

### 2️⃣ Install Dependencies
```bash
pip install -r requirements.txt
```

---

## 🧹 Data Cleaning (Python)

### Step 1: Clean Raw CSV
```bash
python src/clean_csv.py
```

- Input: `data/raw/adidas_sales.csv`  
- Output: `data/raw/adidas_sales_cleaned.csv`  
- Function: skip redundant header rows and reformat columns for SQL import.

---

## 🧮 Data Modeling & Transformation (SQL in DataGrip)

All database modeling and transformations are done directly inside **DataGrip**.

1. Open `data_cleaning.sql` in DataGrip  
2. Connect to an **SQLite** (or local SQL) environment  
3. Execute all statements in sequence  

This will create normalized tables:
- `dim_city`  
- `dim_retailer`  
- `dim_product`  
- `fact_sales`

and a fully cleaned fact table ready for analysis.

---

## 🔍 Analytical Queries (SQL in DataGrip)

Once the schema is created, run the file:

```sql
src/sql_queries.sql
```

This file contains business analytics queries such as:
- Retailer, product, and city counts  
- Sales time span and revenue summary  
- Regional sales breakdown  
- Profit margin by retailer  
- Monthly trends and top products per region  

---

## 📈 Data Visualization (Python)

After you export or connect to the SQLite database:

```bash
python src/visualization.py
```

Generates plots saved in `reports/figures/`:

| Figure | Description |
|:--------|:-------------|
| `retailer_sales.png` | Top 10 Retailers by Total Sales |
| `region_sales.png` | Regional Sales Comparison |
| `monthly_trend.png` | Monthly Sales & Profit Trend |
| `correlation_heatmap.png` | Correlation among numeric features |

---

## 🧩 Tech Stack

| Category | Tools / Libraries |
|-----------|-------------------|
| Language | Python 3.11+ |
| IDE | JetBrains DataGrip |
| Data Handling | pandas |
| Database | SQLite3 |
| Visualization | seaborn, matplotlib |
| Dashboard (optional) | Power BI |
| Version Control | Git + GitHub |

---

## 📦 requirements.txt

```txt
pandas>=2.0.0
matplotlib>=3.8.0
seaborn>=0.13.0
sqlalchemy>=2.0.0
jupyterlab>=4.0.0
```

---

## 📚 Future Improvements

- [ ] Automate SQL execution with Python (ETL pipeline)
- [ ] Integrate Power BI dashboard directly with SQLite
- [ ] Add Streamlit web dashboard
- [ ] Use Airflow for task scheduling

---

## 🏁 License

This project is licensed under the **MIT License** — you are free to use, copy, modify, merge, publish, distribute, and sublicense copies of this software, provided that proper credit is given to the original author.

---

© 2025 Jingyi (Justin) Wang