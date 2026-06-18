import os
import sys
import numpy as np
import pandas as pd
from dotenv import load_dotenv
import snowflake.connector

# Load security credentials
load_dotenv()

def get_snowflake_connection():
    """Establish connection to the HBP Snowflake raw warehouse layer."""
    try:
        return snowflake.connector.connect(
            user=os.getenv("SNOWFLAKE_USER"),
            password=os.getenv("SNOWFLAKE_PASSWORD"),
            account=os.getenv("SNOWFLAKE_ACCOUNT"),
            warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
            database=os.getenv("SNOWFLAKE_DATABASE"),
            schema=os.getenv("SNOWFLAKE_SCHEMA")
        )
    except Exception as e:
        print(f"❌ Snowflake Connection Failed: {str(e)}")
        sys.exit(1)

def upload_table(conn, file_path: str, table_name: str) -> None:
    """Read a processed CSV file and write its contents to Snowflake using raw SQL."""
    if not os.path.exists(file_path):
        print(f"⚠️ Warning: File not found at {file_path}. Skipping...")
        return

    print(f"⏳ Uploading {file_path} to HBP_RAW.INGEST.{table_name}...")
    
    df = pd.read_csv(file_path)
    df.columns = [col.upper() for col in df.columns]
    df = df.where(pd.notnull(df), None)

    # Add the missing Fivetran tracking column to pass dbt model compilation
    df["_FIVETRAN_DELETED"] = False

    cursor = conn.cursor()
    try:
        # Step 1: Ensure table structure exists with the tracking column
        columns_with_types = []
        for col in df.columns:
            if col == "_FIVETRAN_DELETED":
                columns_with_types.append(f'"{col}" BOOLEAN')
            else:
                columns_with_types.append(f'"{col}" VARCHAR') # Using flexible text types for raw layer
        
        # Changed IF NOT EXISTS to OR REPLACE to clear out broken historical table shapes
        create_sql = f'CREATE OR REPLACE TABLE HBP_RAW.INGEST.{table_name} ({", ".join(columns_with_types)})'
        cursor.execute(create_sql)
        
        # Step 2: Clear old duplicate historical rows
        cursor.execute(f"TRUNCATE TABLE HBP_RAW.INGEST.{table_name}")

        # Step 3: Insert rows directly from memory via network (No local file creations)
        columns = ", ".join([f'"{c}"' for c in df.columns])
        placeholders = ", ".join(["%s"] * len(df.columns))
        insert_sql = f"INSERT INTO HBP_RAW.INGEST.{table_name} ({columns}) VALUES ({placeholders})"
        
        # CRITICAL FIX: Convert numeric NaN/Infinity boundaries to clean Python Nones
        # This prevents the raw text string 'NAN' from breaking the SQL compiler
        data_tuples = []
        for row in df.values:
            clean_row = tuple(
                None if (isinstance(val, float) and np.isnan(val)) else val 
                for val in row
            )
            data_tuples.append(clean_row)
        
        cursor.executemany(insert_sql, data_tuples)
        print(f"  ✔ Successfully overwrote and loaded {len(df)} rows into {table_name}!")

    except Exception as e:
        print(f"  ❌ Error while executing warehouse ingestion: {str(e)}")
        sys.exit(1)
    finally:
        cursor.close()

def main():
    # Define mapping configuration of local processed files to raw database tables
    upload_manifest = {
        "data/processed/customers_clean.csv": "DIM_CUSTOMERS",
        "data/processed/orders_clean.csv": "FCT_ORDERS",
        "data/processed/products_clean.csv": "DIM_PRODUCTS",
        "data/processed/capstone_support_tickets_clean.csv": "SUPPORT_TICKETS"
    }

    conn = get_snowflake_connection()
    
    print("\n☁ Connecting to Snowflake & Starting Bulk Append Operations...")
    for file_path, table_name in upload_manifest.items():
        upload_table(conn, file_path, table_name)
        
    conn.close()
    print("✨ All data sync operations completed successfully.")

if __name__ == "__main__":
    main()
