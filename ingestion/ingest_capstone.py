import pandas as pd
import sys

def load_csv(path: str) -> pd.DataFrame:
    """Load capstone support tickets CSV file into a DataFrame."""
    # Read CSV, treating blank entries as NaN values dynamically
    return pd.read_csv(path, keep_default_na=True, skipinitialspace=True)


def validate_tickets(df: pd.DataFrame) -> None:
    """Validate ticket data based on business rules. Exit if validation fails."""
    
    # 1. Primary Key Checks
    if df["ticket_id"].isnull().any():
        print("❌ Null ticket_id found")
        sys.exit(1)
        
    if df["ticket_id"].duplicated().any():
        print("❌ Duplicate ticket_id found")
        sys.exit(1)

    # 2. Status Validation Check (Brief requirements)
    allowed_statuses = ["open", "resolved", "closed"]
    if not df["status"].isin(allowed_statuses).all():
        print("❌ Invalid status values detected")
        sys.exit(1)

    # 3. Category Validation Check
    allowed_categories = ["Billing", "Delivery", "Product", "Account"]
    if not df["category"].isin(allowed_categories).all():
        print("❌ Invalid category values detected")
        sys.exit(1)


def transform_tickets(df: pd.DataFrame) -> pd.DataFrame:
    """Clean data, handle null dates gracefully, and calculate days_to_resolve."""
    
    # String cleaning
    df["ticket_id"] = df["ticket_id"].str.strip()
    df["subject"] = df["subject"].str.strip()
    df["agent_name"] = df["agent_name"].str.strip()
    
    # Standardize statuses & categories to lowercase to prevent warehouse matching mismatches
    df["status"] = df["status"].str.strip().str.lower()
    df["priority"] = df["priority"].str.strip().str.lower()
    
    # Gracefully cast dates to datetime while preserving empty values as NaT (Not a Time)
    df["created_at"] = pd.to_datetime(df["created_at"], errors="coerce")
    df["resolved_at"] = pd.to_datetime(df["resolved_at"], errors="coerce")
    
    # Compute days_to_resolve column safely
    # If open, resolved_at is NaT, which naturally evaluates to NaN/Null when subtracted
    df["days_to_resolve"] = (df["resolved_at"] - df["created_at"]).dt.days
    
    # Reconvert datetime objects back to string formatting (YYYY-MM-DD) for raw VARCHAR loading 
    df["created_at"] = df["created_at"].dt.strftime('%Y-%m-%d')
    df["resolved_at"] = df["resolved_at"].dt.strftime('%Y-%m-%d')
    
    return df


def save_to_processed(df: pd.DataFrame, output_path: str) -> None:
    """Save clean, enriched data to the designated destination path."""
    # Ensure missing dates and calculations explicitly write out empty values for the database
    df.to_csv(output_path, index=False, na_rep="")


if __name__ == "__main__":
    input_path = "data/raw/capstone_support_tickets.csv"
    output_path = "data/processed/capstone_support_tickets_clean.csv"

    print("⏳ Processing Support Tickets...")
    df = load_csv(input_path)
    validate_tickets(df)
    df_clean = transform_tickets(df)
    save_to_processed(df_clean, output_path)

    print("✅ Support Tickets pipeline complete")