import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, accuracy_score

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

# Scale numeric values (highly recommended for linear models like Logistic Regression)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

print("\n--- RUNNING MODEL 1: TUNED RANDOM FOREST ---")
# We restrict max_depth to stop it from memorizing the 'No' answers
rf_model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42, class_weight='balanced')
rf_model.fit(X_train, y_train)
rf_pred = rf_model.predict(X_test)

print(f"Accuracy: {accuracy_score(y_test, rf_pred) * 100:.2f}%")
print(classification_report(y_test, rf_pred, target_names=le_target.classes_))


print("\n--- RUNNING MODEL 2: BALANCED LOGISTIC REGRESSION ---")
# A completely different linear algorithm to see if it handles churn patterns better
lr_model = LogisticRegression(class_weight='balanced', random_state=42, max_iter=1000)
lr_model.fit(X_train_scaled, y_train)
lr_pred = lr_model.predict(X_test_scaled)

print(f"Accuracy: {accuracy_score(y_test, lr_pred) * 100:.2f}%")
print(classification_report(y_test, lr_pred, target_names=le_target.classes_))
