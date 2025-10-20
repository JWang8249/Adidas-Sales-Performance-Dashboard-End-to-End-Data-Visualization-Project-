import pandas as pd
df = pd.read_csv("data/raw/adidas_sales.csv", skiprows = 4)
df.to_csv("data/raw/adidas_sales_cleaned.csv", index = False)
print("✅ Created adidas_sales_cleaned.csv")