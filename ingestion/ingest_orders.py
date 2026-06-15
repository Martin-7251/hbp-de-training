import pandas as pd
import sys


def load_csv(path: str) -> pd.DataFrame:
    """Load orders CSV."""
    return pd.read_csv(path)


def validate_orders(df: pd.DataFrame) -> None:
    """Basic validation for orders."""

    if df["order_id"].isnull().any():
        print("❌ Null order_id found")
        sys.exit(1)

    if df["order_id"].duplicated().any():
        print("❌ Duplicate order_id found")
        sys.exit(1)


def transform_orders(df: pd.DataFrame) -> pd.DataFrame:
    """Clean orders data."""

    df["order_id"] = df["order_id"].astype(int)
    df["customer_id"] = df["customer_id"].astype(int)
    df["quantity"] = df["quantity"].astype(int)
    df["unit_price_pence"] = df["unit_price_pence"].astype(int)
    df["ordered_at"] = pd.to_datetime(df["ordered_at"])
    df["status"] = df["status"].str.lower()

    return df


def save_to_processed(df: pd.DataFrame, output_path: str) -> None:
    """Save cleaned orders."""
    df.to_csv(output_path, index=False)


if __name__ == "__main__":
    df = load_csv("data/raw/orders.csv")
    validate_orders(df)
    df_clean = transform_orders(df)
    save_to_processed(df_clean, "data/processed/orders_clean.csv")

    print("✅ Orders pipeline complete")