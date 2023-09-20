import numpy as np
import pandas as pd
from scipy import linalg
import sys

uncertainty_class1 = .5
uncertainty_class2 = .2
uncertainty_class3 = .05

parameter_names = ['Ss_GW', 'SNH4_GW', 'SNO2_GW', 'SNO3_GW', 'SHPO4_GW', 'XH_GW', 'XN1_GW', 'XN2_GW', 'XS_GW', 
    'Ss_TG', 'SNH4_TG', 'SNO2_TG', 'SNO3_TG', 'SHPO4_TG', 'XH_TG', 'XN1_TG', 'XN2_TG', 'XS_TG', 
    'Ss_TB', 'SNH4_TB', 'SNO2_TB', 'SNO3_TB', 'SHPO4_TB', 'XH_TB', 'XN1_TB', 'XN2_TB', 'XS_TB',
    'Ss_KU', 'SNH4_KU', 'SNO2_KU', 'SNO3_KU', 'SHPO4_KU', 'XH_KU', 'XN1_KU', 'XN2_KU', 'XS_KU', 
    'ratio_jck', 'ratio_direct']

delta_theta_1 = 2.0 * uncertainty_class2  
delta_theta_2 = 4.0 * uncertainty_class2  
delta_theta_3 = 0.36 * uncertainty_class2  
delta_theta_4 = 3.44 * uncertainty_class2  
delta_theta_5 = 2.24 * uncertainty_class2  
delta_theta_6 = 3.66 * uncertainty_class2  
delta_theta_7 = 3.66 * uncertainty_class2  
delta_theta_8 = 3.66 * uncertainty_class2  
delta_theta_9 = 3.66 * uncertainty_class2  

delta_theta_10 = 60.0 * uncertainty_class2  
delta_theta_11 = 1.0 * uncertainty_class2  
delta_theta_12 = 0.155 * uncertainty_class2  
delta_theta_13 = 0.65 * uncertainty_class2  
delta_theta_14 = 1.15 * uncertainty_class2  
delta_theta_15 = 23.82 * uncertainty_class2  
delta_theta_16 = 23.82 * uncertainty_class2  
delta_theta_17 = 23.82 * uncertainty_class2  
delta_theta_18 = 23.82 * uncertainty_class2 

delta_theta_19 = 10.67 * uncertainty_class2  
delta_theta_20 = 46.0 * uncertainty_class2  
delta_theta_21 = 5.2 * uncertainty_class2  
delta_theta_22 = 8.0 * uncertainty_class2  
delta_theta_23 = 7.4 * uncertainty_class2  
delta_theta_24 = 11.7 * uncertainty_class2  
delta_theta_25 = 11.7 * uncertainty_class2 
delta_theta_26 = 11.7 * uncertainty_class2 
delta_theta_27 = 11.7 * uncertainty_class2 

delta_theta_28 = 60.0 * uncertainty_class2 
delta_theta_29 = 1.0 * uncertainty_class2 
delta_theta_30 = 0.155 * uncertainty_class2 
delta_theta_31 = 0.65 * uncertainty_class2 
delta_theta_32 = 1.15 * uncertainty_class2 
delta_theta_33 = 23.82 * uncertainty_class2 
delta_theta_34 = 23.82 * uncertainty_class2 
delta_theta_35 = 23.82 * uncertainty_class2 
delta_theta_36 = 23.82 * uncertainty_class2 

# delta_theta_37 = 0.75 * uncertainty_class2 # Dis_rate
delta_theta_37 = 0.21 * uncertainty_class2 # Gappei_rate_jkc
delta_theta_38 = 0.43 * uncertainty_class2 # Gappei_rate_direct

delta_theta = [delta_theta_1, delta_theta_2, delta_theta_3,delta_theta_4, delta_theta_5, 
               delta_theta_6, delta_theta_7, delta_theta_8, delta_theta_9, delta_theta_10,
              delta_theta_11, delta_theta_12, delta_theta_13, delta_theta_14, delta_theta_15,
              delta_theta_16, delta_theta_17, delta_theta_18, delta_theta_19, delta_theta_20,
              delta_theta_21, delta_theta_22, delta_theta_23, delta_theta_24, delta_theta_25,
              delta_theta_26, delta_theta_27, delta_theta_28, delta_theta_29, delta_theta_30,
              delta_theta_31, delta_theta_32, delta_theta_33, delta_theta_34, delta_theta_35,
              delta_theta_36, delta_theta_37, delta_theta_38]

# print('delta theta')
# print(np.round(delta_theta, 3))
# print('+++++++++++++++++++++++++')

data_set = eval(sys.argv[1])

is_manual =False
starting_param = 38 # when is_manual is True, this will be used.

if data_set == 1:
    df = pd.read_csv(
                            './sensitivity-output/sensitivity-1.csv',
                            header=None
                        )
    df = df.to_numpy()
    df = df.T

    df_output = pd.read_csv(
                            './sensitivity-output/output-1.csv',
                            header=None
                        )
    df_output = df_output.to_numpy()
    df_output = df_output.T

    # scale factor
    # BOD - January to December 
    sc_jan_BOD = 6.1 
    sc_feb_BOD = 6.3 
    sc_mar_BOD = 7.5
    sc_apr_BOD = 7.9 
    sc_may_BOD = 5
    sc_jun_BOD = 4.7
    sc_jul_BOD = 5.2 
    sc_aug_BOD = 4.6 
    sc_sep_BOD = 5.4 
    sc_oct_BOD = 4.25 
    sc_nov_BOD = 3.75
    sc_dec_BOD = 4.75

    # DO - January to December 
    sc_jan_DO = 6.7
    sc_feb_DO = 6.7
    sc_mar_DO = 6.6 
    sc_apr_DO = 5.3 
    sc_may_DO = 5.3 
    sc_jun_DO = 5.2 
    sc_jul_DO = 4.5 
    sc_aug_DO = 5.35 
    sc_sep_DO = 6.75
    sc_oct_DO = 6.55 
    sc_nov_DO = 7.2 
    sc_dec_DO = 6.55 
    
    # SS - January to December 
    sc_jan_SS = 9
    sc_feb_SS = 12
    sc_mar_SS = 10
    sc_apr_SS = 16.3
    sc_may_SS = 9
    sc_jun_SS = 4.95 
    sc_jul_SS = 17 
    sc_aug_SS = 15.5 
    sc_sep_SS = 26.4
    sc_oct_SS = 16 
    sc_nov_SS = 11.5 
    sc_dec_SS = 8.65

    # NOx - January to December 
    sc_jan_NOx = 10.20 
    sc_feb_NOx = 10.30
    sc_mar_NOx = 8.00
    sc_apr_NOx = 8.40
    sc_may_NOx = 9.65
    sc_jun_NOx = 10.55
    sc_jul_NOx = 10.35 
    sc_aug_NOx = 10.45 
    sc_sep_NOx = 11.60
    sc_oct_NOx = 13.00
    sc_nov_NOx = 12.45
    sc_dec_NOx = 15.00

    # NH4 - January to December 
    sc_jan_NH4 = 6.73 
    sc_feb_NH4 = 7.26 
    sc_mar_NH4 = 7.79  
    sc_apr_NH4 = 8.08  
    sc_may_NH4 = 10.59 
    sc_jun_NH4 = 7.88
    sc_jul_NH4 = 6.50
    sc_aug_NH4 = 4.04
    sc_sep_NH4 = 2.20
    sc_oct_NH4 = 2.52
    sc_nov_NH4 = 2.07
    sc_dec_NH4 = 7.24
elif data_set == 2:
    df = pd.read_csv(
                        './sensitivity-output/sensitivity-2.csv',
                            header=None
                        )
    df = df.to_numpy()
    df = df.T

    df_output = pd.read_csv(
                            './sensitivity-output/output-2.csv',
                            header=None
                        )
    df_output = df_output.to_numpy()
    df_output = df_output.T

    # scale factor
    # BOD - January to December 
    sc_jan_BOD = 5.2 
    sc_feb_BOD = 6.7 
    sc_mar_BOD = 6.9 
    sc_apr_BOD = 7.75
    sc_may_BOD = 4.55 
    sc_jun_BOD = 4.6 
    sc_jul_BOD = 4.45 
    sc_aug_BOD = 3.55
    sc_sep_BOD = 2.55
    sc_oct_BOD = 1.75
    sc_nov_BOD = 2.3
    sc_dec_BOD = 3.15

    # DO - January to December
    sc_jan_DO = 8.25 
    sc_feb_DO = 9.25 
    sc_mar_DO = 10.15 
    sc_apr_DO = 7.85 
    sc_may_DO = 8.45
    sc_jun_DO = 8.6
    sc_jul_DO = 6.8
    sc_aug_DO = 7.05
    sc_sep_DO = 6.9
    sc_oct_DO = 7.2
    sc_nov_DO = 7.95
    sc_dec_DO = 8

    # SS - January to December 
    sc_jan_SS = 6.8 
    sc_feb_SS = 6.15 
    sc_mar_SS = 10.65 
    sc_apr_SS = 19.9 
    sc_may_SS = 8.4 
    sc_jun_SS = 13.4 
    sc_jul_SS = 21.1
    sc_aug_SS = 26
    sc_sep_SS = 21.95
    sc_oct_SS = 12.25
    sc_nov_SS = 8.25
    sc_dec_SS = 5.25

    # NOx - January to December
    sc_jan_NOx = 7.835 
    sc_feb_NOx = 6.89 
    sc_mar_NOx = 5.97 
    sc_apr_NOx = 4.71  
    sc_may_NOx = 5.005
    sc_jun_NOx = 6.49
    sc_jul_NOx = 7.56
    sc_aug_NOx = 8.055
    sc_sep_NOx = 8.44
    sc_oct_NOx = 9.11
    sc_nov_NOx = 9.19
    sc_dec_NOx = 8.91

    # NH4 - January to December 
    sc_jan_NH4 = 6.685 
    sc_feb_NH4 = 5.755
    sc_mar_NH4 = 6.2 
    sc_apr_NH4 = 6.47  
    sc_may_NH4 = 5.555  
    sc_jun_NH4 = 2.89
    sc_jul_NH4 = 1.94
    sc_aug_NH4 = 0.635
    sc_sep_NH4 = 0.455
    sc_oct_NH4 = 0.58
    sc_nov_NH4 = 0.535
    sc_dec_NH4 = 1.895
elif data_set == 3:
    df = pd.read_csv(
                        './sensitivity-output/sensitivity-3.csv',
                            header=None
                        )
    df = df.to_numpy()
    df = df.T

    df_output = pd.read_csv(
                            './sensitivity-output/output-3.csv',
                            header=None
                        )
    df_output = df_output.to_numpy()
    df_output = df_output.T

    # scale factor
    # BOD - January to December 
    sc_jan_BOD = 3.2 
    sc_feb_BOD = 4.2
    sc_mar_BOD = 5.1
    sc_apr_BOD = 6.3 
    sc_may_BOD = 3.2 
    sc_jun_BOD = 3.3
    sc_jul_BOD = 3.85 
    sc_aug_BOD = 3.15 
    sc_sep_BOD = 1.6
    sc_oct_BOD = 1.6
    sc_nov_BOD = 1.3
    sc_dec_BOD = 1.95

    # DO - January to December
    sc_jan_DO = 8.6
    sc_feb_DO = 9.2
    sc_mar_DO = 9.4
    sc_apr_DO = 9.9 
    sc_may_DO = 8.1 
    sc_jun_DO = 4.1 
    sc_jul_DO = 4.7 
    sc_aug_DO = 4.4 
    sc_sep_DO = 6.15 
    sc_oct_DO = 7.7
    sc_nov_DO = 7.7
    sc_dec_DO = 7.5

    # SS - January to December 
    sc_jan_SS = 2.3
    sc_feb_SS = 5.2 
    sc_mar_SS = 8.4  
    sc_apr_SS = 5
    sc_may_SS = 8 
    sc_jun_SS = 28 
    sc_jul_SS = 21.65 
    sc_aug_SS = 25.35
    sc_sep_SS = 16.25
    sc_oct_SS = 13
    sc_nov_SS = 6.6
    sc_dec_SS = 3.3

    # NOx - January to December
    sc_jan_NOx = 8.32 
    sc_feb_NOx = 7.16
    sc_mar_NOx = 6.19 
    sc_apr_NOx = 4.92  
    sc_may_NOx = 2.78
    sc_jun_NOx = 5.27
    sc_jul_NOx = 6.79
    sc_aug_NOx = 7.725
    sc_sep_NOx = 8.42
    sc_oct_NOx = 8.78
    sc_nov_NOx = 9.45
    sc_dec_NOx = 9.12

    # NH4 - January to December 
    sc_jan_NH4 = 2.3 
    sc_feb_NH4 = 2.7
    sc_mar_NH4 = 2.19 
    sc_apr_NH4 = 3.11  
    sc_may_NH4 = 2.7  
    sc_jun_NH4 = 1.68 
    sc_jul_NH4 = 0.775
    sc_aug_NH4 = 0.37
    sc_sep_NH4 = 0.16
    sc_oct_NH4 = 0.175 
    sc_nov_NH4 = 0.245
    sc_dec_NH4 = 0.63



NUM_PARAMS = 38
N_DATAPOINTS = 60
vec = np.zeros((NUM_PARAMS, N_DATAPOINTS))

weighted_avg_sensitivity = np.zeros(NUM_PARAMS)
delta_msqr = np.zeros(NUM_PARAMS)
sensitivity_ranking = {}
sensitivity_ranking_collinearity = {}

for i in range(NUM_PARAMS):
    ses_jan_DO = df[0,i]/sc_jan_DO
    ses_feb_DO = df[1,i]/sc_feb_DO
    ses_mar_DO = df[2,i]/sc_mar_DO
    ses_apr_DO = df[3,i]/sc_apr_DO
    ses_may_DO = df[4,i]/sc_may_DO
    ses_jun_DO = df[5,i]/sc_jun_DO
    ses_jul_DO = df[6,i]/sc_jul_DO
    ses_aug_DO = df[7,i]/sc_aug_DO
    ses_sep_DO = df[8,i]/sc_sep_DO
    ses_oct_DO = df[9,i]/sc_oct_DO
    ses_nov_DO = df[10,i]/sc_nov_DO
    ses_dec_DO = df[11,i]/sc_dec_DO

    ses_jan_BOD = df[12,i]/sc_jan_BOD
    ses_feb_BOD = df[13,i]/sc_feb_BOD
    ses_mar_BOD = df[14,i]/sc_mar_BOD
    ses_apr_BOD = df[15,i]/sc_apr_BOD
    ses_may_BOD = df[16,i]/sc_may_BOD
    ses_jun_BOD = df[17,i]/sc_jun_BOD
    ses_jul_BOD = df[18,i]/sc_jul_BOD
    ses_aug_BOD = df[19,i]/sc_aug_BOD
    ses_sep_BOD = df[20,i]/sc_sep_BOD
    ses_oct_BOD = df[21,i]/sc_oct_BOD
    ses_nov_BOD = df[22,i]/sc_nov_BOD
    ses_dec_BOD = df[23,i]/sc_dec_BOD

    ses_jan_SS = df[24,i]/sc_jan_SS
    ses_feb_SS = df[25,i]/sc_feb_SS
    ses_mar_SS = df[26,i]/sc_mar_SS
    ses_apr_SS = df[27,i]/sc_apr_SS
    ses_may_SS = df[28,i]/sc_may_SS
    ses_jun_SS = df[29,i]/sc_jun_SS
    ses_jul_SS = df[30,i]/sc_jul_SS
    ses_aug_SS = df[31,i]/sc_aug_SS
    ses_sep_SS = df[32,i]/sc_sep_SS
    ses_oct_SS = df[33,i]/sc_oct_SS
    ses_nov_SS = df[34,i]/sc_nov_SS
    ses_dec_SS = df[35,i]/sc_dec_SS

    ses_jan_NH4 = df[36,i]/sc_jan_NH4
    ses_feb_NH4 = df[37,i]/sc_feb_NH4
    ses_mar_NH4 = df[38,i]/sc_mar_NH4
    ses_apr_NH4 = df[39,i]/sc_apr_NH4
    ses_may_NH4 = df[40,i]/sc_may_NH4
    ses_jun_NH4 = df[41,i]/sc_jun_NH4
    ses_jul_NH4 = df[42,i]/sc_jul_NH4
    ses_aug_NH4 = df[43,i]/sc_aug_NH4
    ses_sep_NH4 = df[44,i]/sc_sep_NH4
    ses_oct_NH4 = df[45,i]/sc_oct_NH4
    ses_nov_NH4 = df[46,i]/sc_nov_NH4
    ses_dec_NH4 = df[47,i]/sc_dec_NH4

    ses_jan_NOx = df[48,i]/sc_jan_NOx
    ses_feb_NOx = df[49,i]/sc_feb_NOx
    ses_mar_NOx = df[50,i]/sc_mar_NOx
    ses_apr_NOx = df[51,i]/sc_apr_NOx
    ses_may_NOx = df[52,i]/sc_may_NOx
    ses_jun_NOx = df[53,i]/sc_jun_NOx
    ses_jul_NOx = df[54,i]/sc_jul_NOx
    ses_aug_NOx = df[55,i]/sc_aug_NOx
    ses_sep_NOx = df[56,i]/sc_sep_NOx
    ses_oct_NOx = df[57,i]/sc_oct_NOx
    ses_nov_NOx = df[58,i]/sc_nov_NOx
    ses_dec_NOx = df[59,i]/sc_dec_NOx

    v_params = np.array([
        [ses_jan_BOD, ses_feb_BOD, ses_mar_BOD, ses_apr_BOD, 
                ses_may_BOD, ses_jun_BOD, ses_jul_BOD, ses_aug_BOD,
                ses_sep_BOD, ses_oct_BOD, ses_nov_BOD, ses_dec_BOD],
        [ses_jan_DO, ses_feb_DO, ses_mar_DO, ses_apr_DO, 
                ses_may_DO, ses_jun_DO, ses_jul_DO, ses_aug_DO,
                ses_sep_DO, ses_oct_DO, ses_nov_DO, ses_dec_DO],
        [ses_jan_SS, ses_feb_SS, ses_mar_SS, ses_apr_SS, 
                ses_may_SS, ses_jun_SS, ses_jul_SS, ses_aug_SS,
                ses_sep_SS, ses_oct_SS, ses_nov_SS, ses_dec_SS],
        [ses_jan_NOx, ses_feb_NOx, ses_mar_NOx, ses_apr_NOx, 
                ses_may_NOx, ses_jun_NOx, ses_jul_NOx, ses_aug_NOx,
                ses_sep_NOx, ses_oct_NOx, ses_nov_NOx, ses_dec_NOx],
        [ses_jan_NH4, ses_feb_NH4, ses_mar_NH4, ses_apr_NH4, 
                ses_may_NH4, ses_jun_NH4, ses_jul_NH4, ses_aug_NH4,
                ses_sep_NH4, ses_oct_NH4, ses_nov_NH4, ses_dec_NH4]
        ])

    v_params = v_params.flatten()*(delta_theta[i])
    vec[i, :] = v_params
    delta_msqr[i] = np.linalg.norm(v_params)/(np.sqrt(N_DATAPOINTS))
    sensitivity_ranking_collinearity[parameter_names[i]] = delta_msqr[i]

    v_params = v_params/v_params.max()

    # sensitivity measures - # of data per column (per parameter): 
    # 60 (5 monitored WQ * 12 months)
    # weighted_avg_sensitivity[i] = v_params.sum()/len(v_params)
    weighted_avg_sensitivity[i] = v_params.sum()/N_DATAPOINTS
    sensitivity_ranking[parameter_names[i]] = weighted_avg_sensitivity[i]

vec = vec.T
print('vec shape', vec.shape)
print('Sensitivity ranking:')
sorted_sensitivity_ranking = sorted(sensitivity_ranking.items(), key=lambda item: item[1], reverse=True)
print({k: np.round(v,5) for k, v in sorted_sensitivity_ranking})
print('++++++++++++++++++++++++')
print('Sensitivity ranking for collinearity:')
sorted_sensitivity_ranking_col = sorted(sensitivity_ranking_collinearity.items(), key=lambda item: item[1], reverse=True)
print({k: np.round(v,5) for k, v in sorted_sensitivity_ranking_col})


# x_measured = np.array([
# sc_jan_BOD, sc_feb_BOD, sc_mar_BOD, sc_apr_BOD, 
# sc_may_BOD, sc_jun_BOD, sc_jul_BOD, sc_aug_BOD, 
# sc_sep_BOD, sc_oct_BOD, sc_nov_BOD, sc_dec_BOD, 
# sc_jan_DO, sc_feb_DO, sc_mar_DO, sc_apr_DO, 
# sc_may_DO, sc_jun_DO, sc_jul_DO, sc_aug_DO, 
# sc_sep_DO, sc_oct_DO, sc_nov_DO, sc_dec_DO, 
# sc_jan_SS, sc_feb_SS, sc_mar_SS, sc_apr_SS, 
# sc_may_SS, sc_jun_SS, sc_jul_SS, sc_aug_SS, 
# sc_sep_SS, sc_oct_SS, sc_nov_SS, sc_dec_SS, 
# sc_jan_NOx, sc_feb_NOx, sc_mar_NOx, sc_apr_NOx, 
# sc_may_NOx, sc_jun_NOx, sc_jul_NOx, sc_aug_NOx, 
# sc_sep_NOx, sc_oct_NOx, sc_nov_NOx, sc_dec_NOx, 
# sc_jan_NH4, sc_feb_NH4, sc_mar_NH4, sc_apr_NH4, 
# sc_may_NH4, sc_jun_NH4, sc_jul_NH4, sc_aug_NH4, 
# sc_sep_NH4, sc_oct_NH4, sc_nov_NH4, sc_dec_NH4])

x_measured = np.array([
sc_jan_DO, sc_feb_DO, sc_mar_DO, sc_apr_DO, 
sc_may_DO, sc_jun_DO, sc_jul_DO, sc_aug_DO, 
sc_sep_DO, sc_oct_DO, sc_nov_DO, sc_dec_DO, 
sc_jan_BOD, sc_feb_BOD, sc_mar_BOD, sc_apr_BOD, 
sc_may_BOD, sc_jun_BOD, sc_jul_BOD, sc_aug_BOD, 
sc_sep_BOD, sc_oct_BOD, sc_nov_BOD, sc_dec_BOD, 
sc_jan_SS, sc_feb_SS, sc_mar_SS, sc_apr_SS, 
sc_may_SS, sc_jun_SS, sc_jul_SS, sc_aug_SS, 
sc_sep_SS, sc_oct_SS, sc_nov_SS, sc_dec_SS, 
sc_jan_NH4, sc_feb_NH4, sc_mar_NH4, sc_apr_NH4, 
sc_may_NH4, sc_jun_NH4, sc_jul_NH4, sc_aug_NH4, 
sc_sep_NH4, sc_oct_NH4, sc_nov_NH4, sc_dec_NH4,
sc_jan_NOx, sc_feb_NOx, sc_mar_NOx, sc_apr_NOx, 
sc_may_NOx, sc_jun_NOx, sc_jul_NOx, sc_aug_NOx, 
sc_sep_NOx, sc_oct_NOx, sc_nov_NOx, sc_dec_NOx])

x_measured = x_measured.reshape((N_DATAPOINTS,1))

measure_error = (df_output - x_measured)**2/(N_DATAPOINTS-NUM_PARAMS)
# measure_error = (df_output - x_measured)**2
# measure_error = (df_output - x_measured)

Q_mes = np.eye(N_DATAPOINTS) * measure_error
# Q_mes = np.power(Q_mes, 1/(2**N_DATAPOINTS))

# Extracting the most sensitive 3 params for the initial combination
growing_comb =  []
growing_comb_col = []

initial_size = 1

for i in range(initial_size):
    # k, v = sorted_sensitivity_ranking[i]
    k, v = sorted_sensitivity_ranking_col[i]

    for j in range(len(parameter_names)):
        if (k == parameter_names[j]):
            param_index = j+1
            growing_comb.append(param_index)
            growing_comb_col.append(param_index)
            break
    

FIM_DE_pool = []
collinearity_pool = []

vec_pool = np.zeros((N_DATAPOINTS,initial_size)).astype(np.float32)

for k in range(initial_size):
    vec_pool[:,k] = vec[:,growing_comb[k]-1]

S = vec_pool
QmesInv = np.linalg.inv(Q_mes)
FIM = S.T@QmesInv@S
# FIM = S.T@S # results worse
lambdas = np.linalg.eigh(FIM)[0]
lambdas = np.maximum(lambdas, 0)

delta_theta_half = np.array(delta_theta)/2 
selected_delta_theta = np.array([delta_theta_half[i-1] for i in growing_comb])
delta_theta_norm = np.linalg.norm(selected_delta_theta)


# using scipy det
# print('Initial determinant (size 3): ', linalg.det(FIM)**(1/2**3))
determinant = linalg.det(FIM)**(1/2**i)
# determinant = linalg.det(FIM)
FIM_DE = determinant*delta_theta_norm**2/np.sqrt(np.max(lambdas)/np.min(lambdas))

print('Start combination', [parameter_names[id-1] for id in growing_comb])
print('Initial log10(DE): ', np.log10(FIM_DE))
print('++++++++++++++++++++++++')

vec_pool_col = np.zeros((N_DATAPOINTS,initial_size)).astype(np.float32)

for k in range(initial_size):
    norm_vec = vec[:,growing_comb_col[k]-1]/np.linalg.norm(vec[:,growing_comb_col[k]-1])
    vec_pool_col[:,k] = norm_vec

S = vec_pool_col
lambdas_col = np.linalg.eigh(S.T@S)[0]
lambdas_col = np.maximum(lambdas_col, 0)
col_index = 1/(np.sqrt(np.min(lambdas_col)))

print('Start combination', [parameter_names[id-1] for id in growing_comb_col])
print('Initial collinearity: ', np.round(col_index, 3))
print('++++++++++++++++++++++++')

FIM_DE_pool.append(np.log10(FIM_DE))
collinearity_pool.append(col_index)
# print(FIM_DE_pool)

FIM_DE_pool2 = []
idx_pool = []


# manual selection for the starting param

if is_manual:
    growing_comb = [starting_param]


comb_size = initial_size # starting from 4

# for FIM
repeat = 7
for j in range(repeat):
    print('combination size', comb_size)
    counter = 1
    vec_pool2 = np.zeros((N_DATAPOINTS,comb_size)).astype(np.float32)
    # vec_pool2[:,:-1] = vec_pool_temp

    while counter < NUM_PARAMS+1:

        if counter not in growing_comb:
            growing_comb.append(counter)
            for k in range(comb_size):
                vec_pool2[:,k] = vec[:,growing_comb[k]-1]

            S2 = vec_pool2
            # print('S2 shape', S2.shape)
            FIM2 = S2.T@QmesInv@S2

            lambdas = np.linalg.eigh(FIM2)[0]
            lambdas = np.maximum(lambdas, 0)

            selected_delta_theta = np.array([delta_theta_half[i-1] for i in growing_comb])
            delta_theta_norm = np.linalg.norm(selected_delta_theta)
            modE= np.sqrt(np.max(lambdas)/np.min(lambdas))

            # determinant = np.linalg.det(FIM2)
            # using scipy det
            determinant = linalg.det(FIM2)**(1/2**comb_size)
            # determinant = linalg.det(FIM2)

            # print(counter, ' mod E: ', np.round(modE,3), 'determinant: ', np.round(determinant,4))
            # print('+++++++++++++++++++')
            
            # FIM_DE = np.max(np.linalg.det(FIM)*delta_theta_norm**2)/np.min(np.sqrt(np.max(lambdas)/np.min(lambdas)))
            FIM_DE = determinant*delta_theta_norm**2/modE

            FIM_DE_pool2.append(np.log10(FIM_DE))
            idx_pool.append(counter)

            # remove the last item for resetiing the combination list
            # print(growing_comb)
            growing_comb.pop()
            # print('idx pool', idx_pool)
            # print('FIM pool', FIM_DE_pool2)
            counter += 1


        else:
            counter += 1
            continue 


    print('Searching completed... Adding new items')
    # print('counter after while loop: ', counter)
    # print('FIM pool: ', FIM_DE_pool2)
    print(' ')


    # vec_pool_temp = vec_pool2
    # print('vec_pool_temp shape: ', vec_pool_temp.shape)

    # check the maximum FIM_DE
    # print('check argmax: ', np.argmax(FIM_DE_pool2))
    added_idx = idx_pool[np.argmax(FIM_DE_pool2)]
    print('added index: ', added_idx, ', max FIM_DE: ', np.max(FIM_DE_pool2))

    # adding a new parameter
    growing_comb.append(added_idx)
    FIM_DE_pool.append(np.max(FIM_DE_pool2))

    # calculation of collinearity index based on the determined subset
    vec_pool2_col = np.zeros((N_DATAPOINTS,comb_size)).astype(np.float32)

    for k in range(comb_size):
        norm_vec_2 = vec[:,growing_comb[k]-1]/np.linalg.norm(vec[:,growing_comb[k]-1])
        vec_pool2_col[:,k] = norm_vec_2

    S2_col = vec_pool2_col
    lambdas_col = np.linalg.eigh(S2_col.T@S2_col)[0]
    lambdas_col = np.maximum(lambdas_col, 0)
    col_index = 1/(np.sqrt(np.min(lambdas_col)))
       
    collinearity_pool.append(col_index)
    print('added collinearity: ', col_index)

    comb_size = comb_size + 1


    # index and FIM_DE2 pools reset
    idx_pool = []
    FIM_DE_pool2 = []
    print('+++++++++++++++++++++++++')

print('Final FIM DE set', np.round(FIM_DE_pool[:-1], 3))
print('Final collinearity values', np.round(collinearity_pool[:-1],3))
print(' ')
print('Final combination', [parameter_names[id-1] for id in growing_comb[:-1]])  
print('Calculatoin completed...')