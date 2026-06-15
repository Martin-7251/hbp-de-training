import subprocess
import sys


def run_script(script_name: str) -> None:
    """Run a Python ingestion script and fail fast if it errors."""
    result = subprocess.run(["python", script_name])

    if result.returncode != 0:
        print(f"❌ Pipeline failed at {script_name}")
        sys.exit(1)


if __name__ == "__main__":
    print("🚀 Starting data pipeline...\n")

    run_script("ingestion/ingest_customers.py")
    run_script("ingestion/ingest_orders.py")
    run_script("ingestion/ingest_products.py")

    print("\n✅ Pipeline completed successfully")