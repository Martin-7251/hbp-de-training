import subprocess
import sys


def run_script(script_name: str) -> None:
    """Run a Python pipeline file and fail fast if it throws errors."""
    result = subprocess.run(["venv/Scripts/python", script_name])

    if result.returncode != 0:
        print(f"❌ Pipeline sequence failed at {script_name}")
        sys.exit(1)


if __name__ == "__main__":
    print("🚀 Starting data engineering pipeline...\n")

    # --- PHASE 1: LOCAL DATA EXTRACTION, VALIDATION & TRANSFORMATION ---
    print("--- Phase 1: Local Ingestion & Transformations ---")
    run_script("ingestion/ingest_customers.py")
    run_script("ingestion/ingest_orders.py")
    run_script("ingestion/ingest_products.py")
    run_script("ingestion/ingest_capstone.py") # Your newly added Day 9 Module

    # --- PHASE 2: CENTRALIZED CLOUD DATA LOADING SEED ---
    print("\n--- Phase 2: Loading Processed Files to Snowflake ---")
    run_script("ingestion/upload_all_to_snowflake.py")

    print("\n✅ End-to-End Pipeline completed successfully. Data is live in Snowflake!")