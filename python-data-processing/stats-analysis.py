import pandas as pd
import scipy.stats as stats
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import os

# Data format inside csv file
# Column: TheData,Month(Jan-Dec),Group(1-3)

csv_file_list = ["BOD.csv", "DO.csv", "SS.csv", "NH4.csv", "NOX.csv"]
month_list = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

filePath1 = 'output-ttest.txt'
filePath2 = 'output-anova.txt'

if os.path.exists(filePath1):
  os.remove(filePath1)
  print("Successfully! The File has been removed")
else:
  print("Can not delete the file as it doesn't exists")

if os.path.exists(filePath2):
  os.remove(filePath2)
  print("Successfully! The File has been removed")
else:
  print("Can not delete the file as it doesn't exists")


for i in range(len(csv_file_list)):
  df = pd.read_csv(csv_file_list[i],header=0)

  # Consturct model
  model = ols('Value ~ C(Month) * C(Group)', data=df).fit()

  # Perform ANOVA
  anova_table = sm.stats.anova_lm(model, typ=2)

  # Check the p-values for main effects and interaction effect; within-subject (Month) and between-subject (Group) effects 
  with open("output-anova.txt", "a") as f:
    print("Reading "+csv_file_list[i]+'...', file=f)   
    print(anova_table, file=f)

  # Perform Tukey's HSD test for post-hoc analysis
  # Within-Subjects Hypotheses:
  # Null Hypothesis (H0): There is no significant difference in the means across months within each 5-year data set.
  # Alternative Hypothesis (Ha): There is a significant difference in the means across months within each 5-year data set.

  # tukey_results = pairwise_tukeyhsd(endog=df['Value'], groups=df['Month'], alpha=0.05)
  # tukey_results = pairwise_tukeyhsd(endog=df['Value'], groups=df['Group'], alpha=0.05)

  # Print the results
  # print(tukey_results)
  # print(tukey_results.summary())
  with open("output-ttest.txt", "a") as f:
    print("Reading "+csv_file_list[i]+'...', file=f)

    for j in range(12):

      target_month = month_list[j]

      # Perform independent t-tests for January data
      t_statistic1, p_value1 = stats.ttest_ind(df[(df['Month'] == target_month) & (df['Group'] == 1)]['Value'], df[(df['Month'] == target_month) & (df['Group'] == 2)]['Value'])
      t_statistic2, p_value2 = stats.ttest_ind(df[(df['Month'] == target_month) & (df['Group'] == 1)]['Value'], df[(df['Month'] == target_month) & (df['Group'] == 3)]['Value'])
      t_statistic3, p_value3 = stats.ttest_ind(df[(df['Month'] == target_month) & (df['Group'] == 2)]['Value'], df[(df['Month'] == target_month) & (df['Group'] == 3)]['Value'])


      print("", file=f)
      # Check the p-values
      if p_value1 < 0.05:  # You can choose your significance level (e.g., 0.05)
          print(f"{target_month} data for Group 1 is significantly different from Group 2.", file=f)
      else:
          print(f"No significant difference between {target_month} data for Group 1 and Group 2.", file=f)

      if p_value2 < 0.05:
          print(f"{target_month} data for Group 1 is significantly different from Group 3.", file=f)
      else:
          print(f"No significant difference between {target_month} data for Group 1 and Group 3.", file=f)

      if p_value3 < 0.05:
          print(f"{target_month} data for Group 2 is significantly different from Group 3.", file=f)
      else:
            print(f"No significant difference between {target_month} data for Group 2 and Group 3.", file=f)

    print("--------------------------", file=f)