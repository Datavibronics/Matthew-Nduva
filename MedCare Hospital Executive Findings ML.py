import pandas as pd

file_path = r"C:\Users\DEl\Downloads\MedCare_Hospital_Readmission_Dataset.xlsx"

df = pd.read_excel(file_path)

print(df.shape)
print(df.columns.tolist())
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, classification_report
from xgboost import XGBClassifier

print("Loading MedCare Hospital Dataset...")

file_path = r"C:\Users\DEl\Downloads\MedCare_Hospital_Readmission_Dataset.xlsx"

df = pd.read_excel(file_path)

# ======================================
# FEATURES & TARGET
# ======================================

X = df.drop(columns=[
    'PatientID',
    'AdmissionDate',
    'DischargeDate',
    'Readmitted'
])

y = df['Readmitted']

# ======================================
# ENCODE CATEGORICAL COLUMNS
# ======================================

label_encoders = {}

for col in X.select_dtypes(include=['object']).columns:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col].astype(str))
    label_encoders[col] = le

target_encoder = LabelEncoder()
y = target_encoder.fit_transform(y)

# ======================================
# TRAIN TEST SPLIT
# ======================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)

# ======================================
# XGBOOST MODEL
# ======================================

ratio = float(np.sum(y_train == 0)) / np.sum(y_train == 1)

model = XGBClassifier(
    n_estimators=200,
    max_depth=4,
    learning_rate=0.05,
    scale_pos_weight=ratio,
    random_state=42,
    eval_metric='logloss'
)

model.fit(X_train, y_train)

# ======================================
# PREDICTIONS
# ======================================

predictions = model.predict(X_test)

print("\n===== MODEL PERFORMANCE =====")

print(f"Accuracy: {accuracy_score(y_test, predictions)*100:.2f}%")

print("\nClassification Report:")

print(
    classification_report(
        y_test,
        predictions,
        target_names=target_encoder.classes_
    )
)

import pandas as pd
import matplotlib.pyplot as plt

importance_df = pd.DataFrame({
    'Feature': X.columns,
    'Importance': model.feature_importances_
})

importance_df = importance_df.sort_values(
    by='Importance',
    ascending=False
)

print(importance_df.head(15))

plt.figure(figsize=(10,6))
plt.barh(
    importance_df['Feature'][:15],
    importance_df['Importance'][:15]
)

plt.title('Top Drivers of Hospital Readmission')
plt.tight_layout()
plt.show()
