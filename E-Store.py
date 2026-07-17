import pandas as pd

print("Loading RetailMax dataset...")

file_name = r"C:\Users\DEl\Downloads\Analytics\RetailMax_Demand_Forecasting_Cleean_Dataset.csv"

df = pd.read_csv(file_name)

print("\nDataset Shape:")
print(df.shape)

print("\nColumns:")
print(df.columns)

print("\nFirst 5 Rows:")
print(df.head())
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

print("Loading RetailMax dataset...")

file_name = r"C:\Users\DEl\Downloads\Analytics\RetailMax_Demand_Forecasting_Cleean_Dataset.csv"

df = pd.read_csv(file_name)

# Target
y = df['UnitsSold']

# Remove identifiers and target
X = df.drop(columns=[
    'SaleID',
    'UnitsSold',
    'Sales_Date'
])

# Encode categorical columns
categorical_cols = [
    'Store',
    'Region',
    'ProductCategory',
    'ProductName',
    'Promotion',
    'HolidayFlag',
    'Weather',
    'Day Name',
    'InventoryStatus'
]

for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42
)

print("Training Linear Regression...")

lr = LinearRegression()
lr.fit(X_train, y_train)

pred = lr.predict(X_test)

mae = mean_absolute_error(y_test, pred)
rmse = np.sqrt(mean_squared_error(y_test, pred))
r2 = r2_score(y_test, pred)

print("\n=========== MODEL 1 RESULTS ===========")
print(f"MAE : {mae:.2f}")
print(f"RMSE: {rmse:.2f}")
print(f"R²  : {r2:.4f}")
print("======================================")
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

print("\n=== MODEL 2: RANDOM FOREST REGRESSOR ===")

rf = RandomForestRegressor(
    n_estimators=200,
    max_depth=12,
    random_state=42,
    n_jobs=-1
)

rf.fit(X_train, y_train)

rf_pred = rf.predict(X_test)

rf_mae = mean_absolute_error(y_test, rf_pred)
rf_rmse = np.sqrt(mean_squared_error(y_test, rf_pred))
rf_r2 = r2_score(y_test, rf_pred)

print(f"MAE : {rf_mae:.2f}")
print(f"RMSE: {rf_rmse:.2f}")
print(f"R²  : {rf_r2:.4f}")

from xgboost import XGBRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

print("\n=== MODEL 3: XGBOOST REGRESSOR ===")

xgb = XGBRegressor(
    n_estimators=300,
    max_depth=6,
    learning_rate=0.05,
    subsample=0.8,
    colsample_bytree=0.8,
    random_state=42
)

xgb.fit(X_train, y_train)

xgb_pred = xgb.predict(X_test)

xgb_mae = mean_absolute_error(y_test, xgb_pred)
xgb_rmse = np.sqrt(mean_squared_error(y_test, xgb_pred))
xgb_r2 = r2_score(y_test, xgb_pred)

print(f"MAE : {xgb_mae:.2f}")
print(f"RMSE: {xgb_rmse:.2f}")
print(f"R²  : {xgb_r2:.4f}")
import pandas as pd
import matplotlib.pyplot as plt
from xgboost import XGBRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

print("Loading RetailMax dataset...")

file_name = r"C:\Users\DEl\Downloads\Analytics\RetailMax_Demand_Forecasting_Cleean_Dataset.csv"

df = pd.read_csv(file_name)

# Target
y = df['UnitsSold']

# Features
X = df.drop(columns=[
    'SaleID',
    'UnitsSold',
    'Sales_Date'
])

# Encode categorical variables
categorical_cols = [
    'Store',
    'Region',
    'ProductCategory',
    'ProductName',
    'Promotion',
    'HolidayFlag',
    'Weather',
    'Day Name',
    'InventoryStatus'
]

for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

# Train/Test Split
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42
)

# Train XGBoost
model = XGBRegressor(
    n_estimators=300,
    max_depth=6,
    learning_rate=0.05,
    random_state=42
)

model.fit(X_train, y_train)

# Feature Importance
importance_df = pd.DataFrame({
    'Feature': X.columns,
    'Importance': model.feature_importances_
})

importance_df = importance_df.sort_values(
    by='Importance',
    ascending=False
)

print("\nTop Demand Drivers")
print(importance_df.head(15))

# Chart
plt.figure(figsize=(10,6))

plt.barh(
    importance_df['Feature'].head(15),
    importance_df['Importance'].head(15)
)

plt.title('RetailMax Demand Drivers')
plt.xlabel('Importance Score')
plt.ylabel('Feature')

plt.tight_layout()

output_path = r"C:\Users\DEl\Downloads\RetailMax_Demand_Drivers.png"

plt.savefig(output_path, dpi=300)

print(f"\nChart saved to:\n{output_path}")

import pandas as pd
from xgboost import XGBRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

print("Loading RetailMax dataset...")

file_name = r"C:\Users\DEl\Downloads\Analytics\RetailMax_Demand_Forecasting_Cleean_Dataset.csv"

df = pd.read_csv(file_name)

# Backup original
export_df = df.copy()

# Target
y = df['UnitsSold']

# Features
X = df.drop(columns=[
    'SaleID',
    'UnitsSold',
    'Sales_Date'
])

# Encode categories
categorical_cols = [
    'Store',
    'Region',
    'ProductCategory',
    'ProductName',
    'Promotion',
    'HolidayFlag',
    'Weather',
    'Day Name',
    'InventoryStatus'
]

for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

# Train model
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42
)

model = XGBRegressor(
    n_estimators=300,
    max_depth=6,
    learning_rate=0.05,
    random_state=42
)

model.fit(X_train, y_train)

# Predict all records
predictions = model.predict(X)

export_df['PredictedDemand'] = predictions.round(0)

# Demand gap
export_df['DemandGap'] = (
    export_df['PredictedDemand']
    - export_df['UnitsSold']
)

# Inventory Risk Flag
export_df['InventoryRisk'] = export_df.apply(
    lambda x:
        'Potential Stockout'
        if x['PredictedDemand'] > x['InventoryLevel']
        else 'Sufficient Inventory',
    axis=1
)

# High-Risk Inventory List
high_risk = export_df[
    export_df['InventoryRisk']
    == 'Potential Stockout'
]

# Export files
forecast_file = r"C:\Users\DEl\Downloads\RetailMax_Demand_Forecast.xlsx"
risk_file = r"C:\Users\DEl\Downloads\RetailMax_High_Risk_Inventory.xlsx"

export_df.to_excel(
    forecast_file,
    index=False
)

high_risk.to_excel(
    risk_file,
    index=False
)

print("\n================ SUCCESS ================")
print(f"Forecast File: {forecast_file}")
print(f"High Risk Inventory File: {risk_file}")
print(f"Products at Risk: {len(high_risk)}")
print("=========================================")

import pandas as pd
from xgboost import XGBRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

print("Loading RetailMax dataset...")

file_path = r"C:\Users\DEl\Downloads\Analytics\RetailMax_Demand_Forecasting_Cleean_Dataset.csv"

# Load dataset
df = pd.read_csv(file_path)

# Keep full copy for export
forecast_df = df.copy()

# --------------------------
# Target Variable
# --------------------------
y = df['UnitsSold']

# --------------------------
# Features
# --------------------------
X = df.drop(columns=[
    'SaleID',
    'UnitsSold',
    'Sales_Date'
], errors='ignore')

# Encode categorical fields
categorical_cols = [
    'Store',
    'Region',
    'ProductCategory',
    'ProductName',
    'Promotion',
    'HolidayFlag',
    'Weather',
    'CustomerTraffic',
    'InventoryStatus'
]

for col in categorical_cols:
    if col in X.columns:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col].astype(str))

# --------------------------
# Train Model
# --------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42
)

model = XGBRegressor(
    n_estimators=300,
    max_depth=6,
    learning_rate=0.05,
    random_state=42
)

model.fit(X_train, y_train)

# --------------------------
# Predict Entire Dataset
# --------------------------
predictions = model.predict(X)

forecast_df['PredictedDemand'] = predictions.round(0)

forecast_df['DemandGap'] = (
    forecast_df['PredictedDemand']
    - forecast_df['UnitsSold']
)

# --------------------------
# Inventory Risk
# --------------------------
forecast_df['InventoryRisk'] = forecast_df.apply(
    lambda row:
        'Potential Stockout'
        if row['PredictedDemand'] > row['InventoryLevel']
        else 'Sufficient Inventory',
    axis=1
)

# --------------------------
# Demand Category
# --------------------------
forecast_df['DemandCategory'] = pd.cut(
    forecast_df['PredictedDemand'],
    bins=[0, 10, 20, 1000],
    labels=[
        'Low Demand',
        'Medium Demand',
        'High Demand'
    ]
)

# --------------------------
# Export
# --------------------------
output_file = r"C:\Users\DEl\Downloads\RetailMax_AI_Forecasting_Dataset.xlsx"

forecast_df.to_excel(
    output_file,
    index=False
)

print("\n==========================")
print("EXPORT COMPLETED")
print("==========================")
print(f"File saved to:\n{output_file}")

print("\nColumns Included:")
print(forecast_df.columns.tolist())
