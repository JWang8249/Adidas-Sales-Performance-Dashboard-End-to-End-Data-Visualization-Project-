import sqlite3, os, pandas as pd

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'processed', 'adidas.db')
SQL_FILE = os.path.join(os.path.dirname(__file__), 'sql_queries.sql')

print(f"🔗 Connected to {DB_PATH}")
print(f"📄 Reading SQL from {SQL_FILE}")

with open(SQL_FILE, 'r', encoding='utf-8') as f:
    sql_script = f.read()

with sqlite3.connect(DB_PATH) as conn:
    conn.executescript(sql_script)
    print("✅ Executed all SQL queries successfully")

    df = pd.read_sql_query("SELECT * FROM dim_city LIMIT 5;", conn)
    print(df)
