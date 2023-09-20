import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.offsetbox import AnchoredText
from sklearn.metrics import r2_score

combination = ['Ch', 'Ku']

# Dataset 1
plt.rcParams.update({'font.size': 16})
for i in range(2):
    place = combination[i]

    file_name = "./output-csv/Model-evaluation-%s-1.csv" % place
    df = pd.read_csv(file_name, header=None)
    df.columns = [['month', 'U_model', 'U_obs']]
    Y_U = df['U_model'].values.flatten()
    X_U = df['U_obs'].values.flatten()

    mae_U = abs(X_U-Y_U).mean() 

    d1_U = (X_U-Y_U).dot(X_U-Y_U)
    d2_U = (Y_U-Y_U.mean()).dot(Y_U - Y_U.mean())
    r2_U = 1 - d1_U/d2_U
    print('Dataset 1')
    print('+++++++++++++')
    print(place)
    print('MAE for U: ', mae_U)
    print('R2 for U: ', r2_U)
    print(df)
    
    f, ax = plt.subplots()
    
    at = AnchoredText(
    f"MAE: {np.round(mae_U,2)}\n$R^2$: {np.round(r2_score(Y_U, X_U),2)}", prop=dict(size=14), frameon=True, loc='upper left')
    at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    ax.add_artist(at)

    ax.set_ylabel('Model (m/s)')
    ax.set_xlabel('Observed (m/s)')
    ax.plot([0,0.3], [0,0.3], color='k')
    ax.scatter(X_U, Y_U,  color='k')
    ax.set_title('Comparisons at '+combination[i]+' with dataset 1')
    plt.show()


# Dataset 2
plt.rcParams.update({'font.size': 16})
for i in range(2):
    place = combination[i]

    file_name = "./output-csv/Model-evaluation-%s-2.csv" % place
    df = pd.read_csv(file_name, header=None)
    df.columns = [['month', 'U_model', 'U_obs']]

    Y_U = df['U_model'].values.flatten()
    X_U = df['U_obs'].values.flatten()

    mae_U = abs(X_U-Y_U).mean()

    d1_U = (X_U-Y_U).dot(X_U-Y_U)
    d2_U = (Y_U-Y_U.mean()).dot(Y_U - Y_U.mean())
    r2_U = 1 - d1_U/d2_U

    print('Dataset 2')
    print('+++++++++++++')
    print(place)
    print('MAE for U: ', mae_U)
    print('R2 for U: ', r2_U)
    print(df)
    
    f, ax = plt.subplots()
    
    at = AnchoredText(
    f"MAE: {np.round(mae_U,2)}\n$R^2$: {np.round(r2_score(Y_U, X_U),2)}", prop=dict(size=14), frameon=True, loc='upper left')
    at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    ax.add_artist(at)

    plt.ylabel('Model (m/s)')
    plt.xlabel('Observed (m/s)')
    plt.plot([0,0.3], [0,0.3], color='k')
    plt.scatter(X_U, Y_U,  color='k')
    ax.set_title('Comparisons at '+combination[i]+' with dataset 2')
    plt.show()

plt.rcParams.update({'font.size': 16})
for i in range(2):
    place = combination[i]

    file_name = "./output-csv/Model-evaluation-%s-3.csv" % place
    df = pd.read_csv(file_name, header=None)
    df.columns = [['month', 'U_model', 'U_obs']]

    Y_U = df['U_model'].values.flatten()
    X_U = df['U_obs'].values.flatten()

    mae_U = abs(X_U-Y_U).mean()

    d1_U = (X_U-Y_U).dot(X_U-Y_U)
    d2_U = (Y_U-Y_U.mean()).dot(Y_U - Y_U.mean())
    r2_U = 1 - d1_U/d2_U

    print('Dataset 3')
    print('+++++++++++++')
    print(place)
    print('MAE for U: ', mae_U)
    print('R2 for U: ', r2_U)
    
    f, ax = plt.subplots()
    
    at = AnchoredText(
    f"MAE: {np.round(mae_U,2)}\n$R^2$: {np.round(r2_score(Y_U, X_U),2)}", prop=dict(size=14), frameon=True, loc='upper left')
    at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    ax.add_artist(at)

    plt.ylabel('Model (m/s)')
    plt.xlabel('Observed (m/s)')
    plt.plot([0,0.3], [0,0.3], color='k')
    plt.scatter(X_U, Y_U,  color='k')
    ax.set_title('Comparisons at '+combination[i]+' with dataset 3')
    plt.show()