import pandas as pd
import sys


def load_csv(path: str) -> pd.DataFrame:
    """Load customers CSV file into a DataFrame."""
    return pd.read_csv(path)


def validate_customers(df: pd.DataFrame) -> None:
    """Validate customer data. Exit if validation fails."""

    is_active = df["is_active"].astype(str).str.lower()

    if df["customer_id"].isnull().any():
        print("❌ Null customer_id found")
        sys.exit(1)

    if df["customer_id"].duplicated().any():
        print("❌ Duplicate customer_id found")
        sys.exit(1)

    if not df["email"].astype(str).str.contains("@", na=False).all():
        print("❌ Invalid email format detected")
        sys.exit(1)

    if not is_active.isin(["true", "false"]).all():
        print("❌ Invalid is_active values")
        sys.exit(1)


def transform_customers(df: pd.DataFrame) -> pd.DataFrame:
    """Clean and transform customer data."""

    df["customer_id"] = df["customer_id"].astype(int)
    df["first_name"] = df["first_name"].str.strip()
    df["last_name"] = df["last_name"].str.strip()
    df["email"] = df["email"].str.lower()
    df["country"] = df["country"].str.upper()
    df["created_at"] = pd.to_datetime(df["created_at"]).dt.date
    df["is_active"] = df["is_active"].astype(str).str.lower().map({"true": True, "false": False})

    return df


def save_to_processed(df: pd.DataFrame, output_path: str) -> None:
    """Save cleaned data to processed folder."""
    df.to_csv(output_path, index=False)


if __name__ == "__main__":
    input_path = "data/raw/customers.csv"
    output_path = "data/processed/customers_clean.csv"

    df = load_csv(input_path)
    validate_customers(df)
    df_clean = transform_customers(df)
    save_to_processed(df_clean, output_path)

    print("✅ Customers pipeline complete")
    