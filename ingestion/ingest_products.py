import pandas as pd
import sys


def load_csv(path: str) -> pd.DataFrame:
    """Load products CSV."""
    return pd.read_csv(path)


def validate_products(df: pd.DataFrame) -> None:
    """Validate product data."""

    if df["product_id"].isnull().any():
        print("❌ Null product_id found")
        sys.exit(1)

    if df["product_id"].duplicated().any():
        print("❌ Duplicate product_id found")
        sys.exit(1)


def transform_products(df: pd.DataFrame) -> pd.DataFrame:
    """Clean product data."""

    df["unit_price_pence"] = df["unit_price_pence"].astype(int)
    df["in_stock"] = df["in_stock"].map({"true": True, "false": False})
    df["category"] = df["category"].str.strip()

    return df


def save_to_processed(df: pd.DataFrame, output_path: str) -> None:
    """Save cleaned products."""
    df.to_csv(output_path, index=False)


if __name__ == "__main__":
    df = load_csv("data/raw/products.csv")
    validate_products(df)
    df_clean = transform_products(df)
    save_to_processed(df_clean, "data/processed/products_clean.csv")

    print("✅ Products pipeline complete")