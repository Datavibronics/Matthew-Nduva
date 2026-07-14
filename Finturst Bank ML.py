import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score
from imblearn.over_sampling import SMOTE

print("Loading data directly from Excel...")
# 1. Load the dataset
file_name = r"C:\Users\DEl\Downloads\FinTrust_Customer_Churn_Dataset.xlsx"
df = pd.read_excel(file_name, sheet_name='Customer_Churn_Data')

# 2. Process features
X = df.drop(columns=['CustomerID', 'Churn'])
y = df['Churn']

# 3. Handle Categorical Features
categorical_cols = ['Gender', 'Country', 'City', 'AccountType']
for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

# Encode target variable
le_target = LabelEncoder()
y = le_target.fit_transform(y)

# 4. Split data into Training and Testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

print(f"\nOriginal Training Target Balance: {np.bincount(y_train)}")

# 5. Apply SMOTE to balance the training data synthetically
print("Applying SMOTE to balance the classes...")
smote = SMOTE(random_state=42)
X_train_balanced, y_train_balanced = smote.fit_resample(X_train, y_train)

print(f"Balanced Training Target Balance: {np.bincount(y_train_balanced)}")

print("\n--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---")
# Train a standard Random Forest model on the perfectly balanced synthetic data
smote_rf = RandomForestClassifier(n_estimators=100, max_depth=6, random_state=42)
smote_rf.fit(X_train_balanced, y_train_balanced)
smote_pred = smote_rf.predict(X_test)

# 6. Evaluation
print(f"Accuracy: {accuracy_score(y_test, smote_pred) * 100:.2f}%")
print(classification_report(y_test, smote_pred, target_names=le_target.classes_))


import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import classification_report, accuracy_score
from xgboost import XGBClassifier

print("Loading data directly from Excel...")
file_name = r"C:\Users\DEl\Downloads\FinTrust_Customer_Churn_Dataset.xlsx"
df = pd.read_excel(file_name, sheet_name='Customer_Churn_Data')

X = df.drop(columns=['CustomerID', 'Churn'])
y = df['Churn']

# Handle Categorical Features
categorical_cols = ['Gender', 'Country', 'City', 'AccountType']
for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

le_target = LabelEncoder()
y = le_target.fit_transform(y)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

print("\n--- RUNNING MODEL 4: XGBOOST WITH SCALE_POS_WEIGHT ---")
# Calculate scale_pos_weight: sum(negative instances) / sum(positive instances)
# This acts like class weights, perfectly tuned for boosting!
ratio = float(np.sum(y_train == 0)) / np.sum(y_train == 1)

xgb_model = XGBClassifier(
    n_estimators=100,
    max_depth=4,
    scale_pos_weight=ratio,
    learning_rate=0.05,
    random_state=42,
    eval_metric='logloss'
)

xgb_model.fit(X_train, y_train)
xgb_pred = xgb_model.predict(X_test)

print(f"Accuracy: {accuracy_score(y_test, xgb_pred) * 100:.2f}%")
print(classification_report(y_test, xgb_pred, target_names=le_target.classes_))

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from xgboost import XGBClassifier

print("Step 1: Loading and preparing data...")
file_name = r"C:\Users\DEl\Downloads\FinTrust_Customer_Churn_Dataset.xlsx"
df = pd.read_excel(file_name, sheet_name='Customer_Churn_Data')

# Keep a clean backup of original data for exporting at the end
df_export = df.copy()

# Features and target
X = df.drop(columns=['CustomerID', 'Churn'])
y = df['Churn']

# Label encode categorical columns
categorical_cols = ['Gender', 'Country', 'City', 'AccountType']
for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

le_target = LabelEncoder()
y = le_target.fit_transform(y)

# Train-Test Split (using same random state to keep model consistent)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

print("Step 2: Training final XGBoost model...")
ratio = float(np.sum(y_train == 0)) / np.sum(y_train == 1)
xgb_model = XGBClassifier(
    n_estimators=100,
    max_depth=4,
    scale_pos_weight=ratio,
    learning_rate=0.05,
    random_state=42,
    eval_metric='logloss'
)
xgb_model.fit(X_train, y_train)

print("Step 3: Calculating churn risk probabilities for ALL customers...")
# predict_proba returns [prob_of_staying, prob_of_churning]
# We grab index 1 for probability of churn
all_features_encoded = X.copy()
probabilities = xgb_model.predict_proba(all_features_encoded)[:, 1]

# Add probabilities and model predictions back to our export dataframe
df_export['Churn_Probability'] = (probabilities * 100).round(2)
df_export['Churn_Prediction'] = xgb_model.predict(all_features_encoded)
df_export['Churn_Prediction'] = df_export['Churn_Prediction'].map({1: 'At Risk', 0: 'Healthy'})

# Filter for customers who haven't left yet, but have a high risk (> 60% probability)
high_risk_list = df_export[
    (df_export['Churn'] == 'No') & 
    (df_export['Churn_Probability'] >= 60.0)
].sort_values(by='Churn_Probability', ascending=False)

# Save results to a new Excel sheet
output_path = r"C:\Users\DEl\Downloads\FinTrust_High_Risk_Customers.xlsx"
high_risk_list.to_excel(output_path, index=False)

print(f"\n================ SUCCESS ================")
print(f"Identified {len(high_risk_list)} active customers who are currently high-risk.")
print(f"List saved to: {output_path}")
print("=========================================")

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
import seaborn as sns
from xgboost import XGBClassifier

print("Step 1: Loading data...")
file_name = r"C:\Users\DEl\Downloads\FinTrust_Customer_Churn_Dataset.xlsx"
df = pd.read_excel(file_name, sheet_name='Customer_Churn_Data')

X = df.drop(columns=['CustomerID', 'Churn'])
y = df['Churn']

# Handle Categorical Features
categorical_cols = ['Gender', 'Country', 'City', 'AccountType']
for col in categorical_cols:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col])

le_target = LabelEncoder()
y = le_target.fit_transform(y)

# Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

print("Step 2: Training XGBoost model...")
ratio = float(np.sum(y_train == 0)) / np.sum(y_train == 1)
xgb_model = XGBClassifier(
    n_estimators=100,
    max_depth=4,
    scale_pos_weight=ratio,
    learning_rate=0.05,
    random_state=42,
    eval_metric='logloss'
)
xgb_model.fit(X_train, y_train)

print("Step 3: Generating Feature Importance Chart...")
# Create a DataFrame for feature importances
importances = xgb_model.feature_importances_
feature_names = X.columns
importance_df = pd.DataFrame({
    'Feature': feature_names,
    'Importance': importances
}).sort_values(by='Importance', ascending=False)

# Plotting using Seaborn & Matplotlib
plt.figure(figsize=(10, 6))
sns.barplot(
    data=importance_df, 
    x='Importance', 
    y='Feature', 
    palette='viridis',
    hue='Feature',
    legend=False
)

plt.title('What Drives Customer Churn at FinTrust Bank?', fontsize=14, fontweight='bold', pad=15)
plt.xlabel('Importance Score (Contribution to Prediction)', fontsize=11)
plt.ylabel('Customer Feature', fontsize=11)
plt.tight_layout()

# Save the chart as an image in your Downloads folder
output_image_path = r"C:\Users\DEl\Downloads\fintrust_churn_drivers.png"
plt.savefig(output_image_path, dpi=300)
plt.close()

print(f"\n================ SUCCESS ================")
print(f"Feature importance chart saved successfully!")
print(f"Saved to: {output_image_path}")
print("=========================================")

revenue_at_risk = high_risk_list['EstimatedAnnualRevenue'].sum()

print("\n================ REVENUE AT RISK ================")
print(f"${revenue_at_risk:,.2f}")

# Add predictions back to original dataset
df_export = df.copy()

df_export['Churn_Probability'] = (
    xgb_model.predict_proba(X)[:,1] * 100
).round(2)

df_export['Churn_Prediction'] = np.where(
    df_export['Churn_Probability'] >= 60,
    'At Risk',
    'Healthy'
)

# Save file
output_file = r"C:\Users\DEl\Downloads\FinTrust_ML_Output.xlsx"

df_export.to_excel(
    output_file,
    index=False
)

print(f"Saved to {output_file}")
