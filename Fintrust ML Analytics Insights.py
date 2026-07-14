Python 3.14.6 (tags/v3.14.6:c63aec6, Jun 10 2026, 10:26:10) [MSC v.1944 64 bit (AMD64)] on win32
Enter "help" below or click "Help" above for more information.

========= RESTART: C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py =========
Loading data directly from Excel...

Original Training Target Balance: [1410  190]
Applying SMOTE to balance the classes...
Balanced Training Target Balance: [1410 1410]

--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---
Accuracy: 73.25%
              precision    recall  f1-score   support

          No       0.91      0.78      0.84       353
         Yes       0.19      0.40      0.26        47

    accuracy                           0.73       400
   macro avg       0.55      0.59      0.55       400
weighted avg       0.82      0.73      0.77       400


========= RESTART: C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py =========
Loading data directly from Excel...

Original Training Target Balance: [1410  190]
Applying SMOTE to balance the classes...
Balanced Training Target Balance: [1410 1410]

--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---
Accuracy: 73.25%
              precision    recall  f1-score   support

          No       0.91      0.78      0.84       353
         Yes       0.19      0.40      0.26        47

    accuracy                           0.73       400
   macro avg       0.55      0.59      0.55       400
weighted avg       0.82      0.73      0.77       400

Loading data directly from Excel...

--- RUNNING MODEL 4: XGBOOST WITH SCALE_POS_WEIGHT ---
Accuracy: 84.25%
              precision    recall  f1-score   support

          No       0.92      0.90      0.91       353
         Yes       0.35      0.40      0.38        47

    accuracy                           0.84       400
   macro avg       0.64      0.65      0.64       400
weighted avg       0.85      0.84      0.85       400


========= RESTART: C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py =========
Loading data directly from Excel...

Original Training Target Balance: [1410  190]
Applying SMOTE to balance the classes...
Balanced Training Target Balance: [1410 1410]

--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---
Accuracy: 73.25%
              precision    recall  f1-score   support

          No       0.91      0.78      0.84       353
         Yes       0.19      0.40      0.26        47

    accuracy                           0.73       400
   macro avg       0.55      0.59      0.55       400
weighted avg       0.82      0.73      0.77       400

Loading data directly from Excel...

--- RUNNING MODEL 4: XGBOOST WITH SCALE_POS_WEIGHT ---
Accuracy: 84.25%
              precision    recall  f1-score   support

          No       0.92      0.90      0.91       353
         Yes       0.35      0.40      0.38        47

    accuracy                           0.84       400
   macro avg       0.64      0.65      0.64       400
weighted avg       0.85      0.84      0.85       400

Step 1: Loading and preparing data...
Step 2: Training final XGBoost model...
Step 3: Calculating churn risk probabilities for ALL customers...

================ SUCCESS ================
Identified 49 active customers who are currently high-risk.
List saved to: C:\Users\DEl\Downloads\FinTrust_High_Risk_Customers.xlsx
=========================================

========= RESTART: C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py =========
Loading data directly from Excel...

Original Training Target Balance: [1410  190]
Applying SMOTE to balance the classes...
Balanced Training Target Balance: [1410 1410]

--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---
Accuracy: 73.25%
              precision    recall  f1-score   support

          No       0.91      0.78      0.84       353
         Yes       0.19      0.40      0.26        47

    accuracy                           0.73       400
   macro avg       0.55      0.59      0.55       400
weighted avg       0.82      0.73      0.77       400

Loading data directly from Excel...

--- RUNNING MODEL 4: XGBOOST WITH SCALE_POS_WEIGHT ---
Accuracy: 84.25%
              precision    recall  f1-score   support

          No       0.92      0.90      0.91       353
         Yes       0.35      0.40      0.38        47

    accuracy                           0.84       400
   macro avg       0.64      0.65      0.64       400
weighted avg       0.85      0.84      0.85       400

Step 1: Loading and preparing data...
Step 2: Training final XGBoost model...
Step 3: Calculating churn risk probabilities for ALL customers...

================ SUCCESS ================
Identified 49 active customers who are currently high-risk.
List saved to: C:\Users\DEl\Downloads\FinTrust_High_Risk_Customers.xlsx
=========================================
Step 1: Loading data...
Step 2: Training XGBoost model...
Step 3: Generating Feature Importance Chart...

================ SUCCESS ================
Feature importance chart saved successfully!
Saved to: C:\Users\DEl\Downloads\fintrust_churn_drivers.png
=========================================

========= RESTART: C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py =========
Loading data directly from Excel...

Original Training Target Balance: [1410  190]
Applying SMOTE to balance the classes...
Balanced Training Target Balance: [1410 1410]

--- RUNNING MODEL 3: RANDOM FOREST WITH SMOTE ---
Accuracy: 73.25%
              precision    recall  f1-score   support

          No       0.91      0.78      0.84       353
         Yes       0.19      0.40      0.26        47

    accuracy                           0.73       400
   macro avg       0.55      0.59      0.55       400
weighted avg       0.82      0.73      0.77       400

Loading data directly from Excel...

--- RUNNING MODEL 4: XGBOOST WITH SCALE_POS_WEIGHT ---
Accuracy: 84.25%
              precision    recall  f1-score   support

          No       0.92      0.90      0.91       353
         Yes       0.35      0.40      0.38        47

    accuracy                           0.84       400
   macro avg       0.64      0.65      0.64       400
weighted avg       0.85      0.84      0.85       400

Step 1: Loading and preparing data...
Step 2: Training final XGBoost model...
Step 3: Calculating churn risk probabilities for ALL customers...
Traceback (most recent call last):
  File "C:/Users/DEl/OneDrive/Documents/Finturst Bank ML.py", line 156, in <module>
    high_risk_list.to_excel(output_path, index=False)
  File "C:\Users\DEl\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\pandas\core\generic.py", line 2312, in to_excel
    formatter.write(
  File "C:\Users\DEl\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\pandas\io\formats\excel.py", line 1003, in write
    writer = ExcelWriter(
  File "C:\Users\DEl\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\pandas\io\excel\_openpyxl.py", line 62, in __init__
    super().__init__(
  File "C:\Users\DEl\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\pandas\io\excel\_base.py", line 1281, in __init__
    self._handles = get_handle(
  File "C:\Users\DEl\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\pandas\io\common.py", line 939, in get_handle
    handle = open(handle, ioargs.mode)
PermissionError: [Errno 13] Permission denied: 'C:\\Users\\DEl\\Downloads\\FinTrust_High_Risk_Customers.xlsx'
