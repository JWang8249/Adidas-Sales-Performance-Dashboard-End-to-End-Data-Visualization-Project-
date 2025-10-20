# src/visualization.py
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

sns.set_theme(style="whitegrid", context="talk", palette="muted")

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'processed', 'adidas.db')

FIG_PATH = os.path.join(os.path.dirname(__file__), '..', 'reports', 'figures')
os.makedirs(FIG_PATH, exist_ok=True)

with sqlite3.connect(DB_PATH) as conn:
    print("✅ Connected to SQLite database")

    df_retailer = pd.read_sql_query("""
        SELECT r.retailer_name,
               SUM(f.total_sales) AS total_sales,
               ROUND(AVG(f.operating_margin)*100,2) AS avg_margin
        FROM fact_sales f
        JOIN dim_retailer r ON f.retailer_id = r.retailer_id
        GROUP BY r.retailer_name
        ORDER BY total_sales DESC
        LIMIT 10;
    """, conn)

    df_region = pd.read_sql_query("""
        SELECT c.Region AS region,
               SUM(f.total_sales) AS total_sales,
               SUM(f.operating_profit) AS total_profit
        FROM fact_sales f
        JOIN dim_city c ON f.city_id = c.city_id
        GROUP BY c.Region
        ORDER BY total_sales DESC;
    """, conn)

    df_monthly = pd.read_sql_query("""
        SELECT strftime('%Y-%m', invoice_date) AS month,
               SUM(total_sales) AS total_sales,
               SUM(operating_profit) AS total_profit
        FROM fact_sales
        GROUP BY month
        ORDER BY month;
    """, conn)

plt.figure(figsize=(10, 6))
sns.barplot(x="total_sales", y="retailer_name", data=df_retailer, hue="avg_margin", dodge=False)
plt.title("Top 10 Retailers by Total Sales")
plt.xlabel("Total Sales ($)")
plt.ylabel("Retailer")
plt.legend(title="Avg Margin (%)")
plt.tight_layout()
plt.savefig(os.path.join(FIG_PATH, "retailer_sales.png"))
plt.show()

plt.figure(figsize=(8, 6))
sns.barplot(x="region", y="total_sales", data=df_region)
plt.title("Sales by Region")
plt.xlabel("Region")
plt.ylabel("Total Sales ($)")
plt.tight_layout()
plt.savefig(os.path.join(FIG_PATH, "region_sales.png"))
plt.show()

plt.figure(figsize=(12, 6))
sns.lineplot(x="month", y="total_sales", data=df_monthly, marker="o", label="Total Sales")
sns.lineplot(x="month", y="total_profit", data=df_monthly, marker="o", label="Total Profit")
plt.title("Monthly Sales & Profit Trend")
plt.xlabel("Month")
plt.ylabel("Amount ($)")
plt.xticks(rotation=45)
plt.legend()
plt.tight_layout()
plt.savefig(os.path.join(FIG_PATH, "monthly_trend.png"))
plt.show()

# heatmap
with sqlite3.connect(DB_PATH) as conn:
    df_fact = pd.read_sql_query("""
        SELECT price_per_unit, units_sold, total_sales,
               operating_profit, operating_margin
        FROM fact_sales;
    """, conn)
corr_matrix = df_fact.corr()
plt.figure(figsize=(8, 6))
sns.heatmap(corr_matrix,
            annot=True, fmt=".2f", cmap="YlGnBu", linewidths=0.5,
            cbar_kws={"label": "Correlation Strength"})
plt.title("Correlation Heatmap of Numerical Variables", pad=15)
plt.tight_layout()
plt.savefig(os.path.join(FIG_PATH, "correlation_heatmap.png"))
plt.show()

print(f"📊 All figures saved to: {FIG_PATH}")
