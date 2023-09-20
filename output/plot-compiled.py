import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
from IPython.core.pylabtools import figsize
import os, sys

# Figure Width (cm)
figSizeXcm = 20
figSizeYcm = 9
figSizeYcmRev = 24

# Font size in Figures
fontSize = 8

# Line width in Figures (pt)
lineWidth = 1.0 

# Choice of Font ("Arial" / "Times New Roman" / "CMU Serif")
fontChoice = "Times"


# matplotlib.font_manager._rebuild()

# Convert figure size to inches
figSizeXinches = figSizeXcm/2.54
figSizeYinches = figSizeYcm/2.54
figSizeYinchesRev = figSizeYcmRev/2.54

# Padding to move axis labels away from the axis
tickPad = 3
tickLength = 4
markerSize = 4
labelPadY = 3
labelPadX = 3

# Padding around overall figure border (as a fraction of font size)
borderPad = 2

# Colours for the line plots - Can use rgb or html
colour1 = 'black'
colour2 = '#D01D3E'

# Plot Configuration
# plt.rcParams['font.family'] = fontChoice
plt.rcParams['axes.linewidth'] = lineWidth
plt.rcParams["figure.figsize"] = (figSizeXinches, figSizeYinchesRev)


wq_parameters = ['BOD', 'NOX', 'NH4', 'SSolids', 'O2']
segment_length = 1490.0  # [m]
y = {}


# Kuki obervatory points
# Median and sd data calculated with LibreOffice at Kuki observatory point (2005 - 2010) 
monitoring_data_1_K = {      
    "O2": [6.7, 6.7, 6.6, 5.3, 5.3, 5.2, 4.5, 5.35, 6.75, 6.55, 7.2, 6.55],
    "BOD": [6.1, 6.3, 7.5, 7.9, 5, 4.7, 5.2, 4.6, 5.4, 4.25, 3.75, 4.75],
    "SSolids": [9, 12, 10, 16.3, 9, 4.95, 17, 15.5, 26.4, 16, 11.5, 8.65],
    "NH4": [6.73, 7.26, 7.79, 8.08, 10.59, 7.88, 6.50, 4.04, 2.20, 2.52, 2.07, 7.24],
    "NOX": [10.20, 10.30, 8.00, 8.40, 9.65, 10.55, 10.35, 10.45, 11.60, 13.00, 12.45, 15.00],
} 

monitoring_data_1_sd_K = {
    "O2": [1.06, 1.38, 0.77, 1.57, 1.67, 1.15, 0.71, 0.86, 0.99, 1.25, 0.83, 0.73],
    "BOD": [1.69, 2.19, 2.24, 2.39, 1.84, 1.29, 2.34, 1.15, 2.20, 1.54, 1.29, 1.26],
    "SSolids": [4.82, 4.22, 3.96, 13.09, 3.38, 18.94, 16.29, 11.04, 15.43, 2.39, 4.49, 13.62],
    "NH4": [1.51, 3.59, 2.19, 4.55, 7.66, 10.96, 11.99, 2.72, 2.68, 1.71, 0.56, 2.87],
    "NOX": [0.93, 1.32, 2.08, 2.90, 2.94, 2.60, 2.02, 4.45, 1.69, 2.78, 1.15, 4.00]
}

# Median and sd data calculated with LibreOffice at Kuki observatory point (2011 - 2014) 
monitoring_data_2_K = {      
    "O2": [8.25, 9.25, 10.15, 7.85, 8.45, 8.6, 6.8, 7.05, 6.9, 7.2, 7.95, 8],
    "BOD": [5.2, 6.7, 6.9, 7.75, 4.55, 4.6, 4.45, 3.55, 2.55, 1.75, 2.3, 3.15],
    "SSolids": [6.8, 6.15, 10.65, 19.9, 8.4, 13.4, 21.1, 26, 21.95, 12.25, 8.25, 5.25],
    "NH4": [6.685, 5.755, 6.2, 6.47, 5.555, 2.89, 1.94, 0.635, 0.455, 0.58, 0.535, 1.895],
    "NOX": [7.835, 6.89, 5.97, 4.71, 5.005, 6.49, 7.56, 8.055, 8.44, 9.11, 9.19, 8.91],
} 

monitoring_data_2_sd_K = {
    "O2": [1.47, 2.04, 2.37, 3.61, 3.74, 2.25, 0.81, 2.02, 0.54, 0.84, 1.08, 1.18],
    "BOD": [3.15, 1.36, 1.87, 3.02, 1.89, 2.10, 2.99, 0.88, 1.05, 0.29, 0.91, 1.07],
    "SSolids": [2.03, 2.57, 5.04, 23.22, 2.60, 13.34, 7.28, 4.61, 19.16, 1.40, 1.44, 2.05],
    "NH4": [10.26, 2.72, 2.94, 4.25, 2.94, 2.25, 3.07, 2.18, 0.12, 0.39, 0.34, 1.33],
    "NOX": [1.89, 2.03, 2.45, 2.93, 0.97, 2.25, 2.20, 3.32, 1.10, 1.39, 1.75, 1.59]
}

# Median and sd data calculated with LibreOffice at Kuki observatory point (2015 - 2018) 
monitoring_data_3_K = {      
    "O2": [8.6, 9.2, 9.4, 9.9, 8.1, 4.1, 4.7, 4.4, 6.15, 7.7, 7.7, 7.5],
    "BOD": [3.2, 4.2, 5.1, 6.3, 3.2, 3.3, 3.85, 3.15, 1.6, 1.6, 1.3, 1.95],
    "SSolids": [2.3, 5.2, 8.4, 5, 8, 28, 21.65, 25.35, 16.25, 13, 6.6, 3.3],
    "NH4": [2.3, 2.7, 2.19, 3.11, 2.7, 1.68, 0.775, 0.37, 0.16, 0.175, 0.245, 0.63],
    "NOX": [8.32, 7.16, 6.19, 4.92, 2.78, 5.27, 6.79, 7.725, 8.42, 8.78, 9.45, 9.12],
} 

monitoring_data_3_sd_K = {
    "O2": [0.53, 1.02, 1.33, 2.51, 1.00, 0.84, 0.95, 1.47, 1.45, 0.68, 0.88, 1.34],
    "BOD": [0.72, 1.21, 1.91, 2.66, 1.42, 0.55, 1.85, 1.64, 0.50, 0.44, 0.34, 1.95],
    "SSolids": [0.98, 3.96, 2.11, 2.75, 4.30, 12.55, 5.79, 2.62, 4.78, 4.93, 2.98, 7.45],
    "NH4": [1.35, 0.82, 1.63, 0.78, 0.28, 0.42, 0.56, 0.03, 0.03, 0.12, 0.09, 0.34],
    "NOX": [1.22, 0.74, 0.87, 1.27, 0.66, 2.46, 1.20, 0.77, 0.55, 0.89, 1.06, 1.45]
}

monitoring_data_K = [monitoring_data_1_K, monitoring_data_2_K, monitoring_data_3_K]
monitoring_data_sd_K = [monitoring_data_1_sd_K, monitoring_data_2_sd_K, monitoring_data_3_sd_K]

data_count = eval(sys.argv[1])

simulation_month = 12

t = [i+1 for i in range(simulation_month)]

wq_yearly_data_compiled_kuki = {}


for i, wq in enumerate(wq_parameters):
    wq_yearly_data = []

    fig4 = plt.figure()
    fig4.tight_layout(h_pad=borderPad)

    for month_count in range(simulation_month):
        if month_count < 9:
            month_count_char = "0"+str(month_count+1)
        else:
            month_count_char = str(month_count+1)

        
        df = pd.read_csv(
                f'./output-csv/Output{wq}.' + month_count_char + '-0'+ str(data_count) + '.csv',
                header=None
            )

        data_array = df.to_numpy()
            
        div_number = len(data_array[-1, :])
        div_length = segment_length/div_number

        y[wq] = data_array
        distance = np.array([i*div_length for i in range(div_number)]) 

        wq_yearly_data.append(y[wq][-1, -1])
        wq_yearly_data_compiled_kuki[wq] = wq_yearly_data

        ax4 = fig4.add_subplot(6,2,month_count+1)

        # Graph at the end of a month
        ax4.plot(distance, y[wq][-1, :], '-', markersize=markerSize,
                 linewidth=lineWidth+0.5, color=colour2)
        # print(y[wq][-1, 1:])
        plt.minorticks_off()
        ax4.tick_params(which='both', direction='in', length=tickLength,
                        width=lineWidth,  pad=tickPad, color=colour1)
        # ax4.grid(color=colour1, linewidth=lineWidth, alpha=0.3)
        # ax4.set_xlabel(r'Distance [m]', fontsize=fontSize, labelpad=labelPadX)
        ax4.set_ylabel(r'Concentration [mg/L]',
                       fontsize=fontSize, labelpad=labelPadY)
        # ax4.set_ylim(0,50.0)
        ax4.yaxis.set_ticks_position('both')
        ax4.xaxis.set_ticks_position('both')

        outputFilePath2 = "./png-compiled/distance_figure_" + wq + '.' + str(data_count) + ".png"
        plt.savefig(outputFilePath2)


fig3 = plt.figure()
fig3.tight_layout(pad=borderPad)

for j in range(5):
    code = int('51' + str(j+1))
    
    ax3 = fig3.add_subplot(code)
    ax3.plot(t, wq_yearly_data_compiled_kuki[wq_parameters[j]], '-', markersize=markerSize,
        linewidth=lineWidth+0.5, color=colour2, label="Model output")
    ax3.errorbar(t, monitoring_data_K[data_count-1][wq_parameters[j]][:simulation_month], monitoring_data_sd_K[data_count-1][wq_parameters[j]][:simulation_month], \
        marker='s', linestyle='', color='k', label='Observed data') 
    
    # r-squred
    Y = np.array(monitoring_data_K[data_count-1][wq_parameters[j]][:simulation_month])
    Yhat = np.array(wq_yearly_data_compiled_kuki[wq_parameters[j]])
    d1 = Y - Yhat
    d2 = Y - Y.mean()
    r2 = 1 - d1.dot(d1)/d2.dot(d2)
    print('Water quality: ', wq_parameters[j], 'the r-squared', r2)  

    mae = abs(Y-Yhat).mean()
    print('Water quality: ', wq_parameters[j], 'the mae', mae)

    # correlation coefficient
    corr = np.corrcoef(np.vstack((Y,Yhat)))[0,1]
    print('Water quality: ', wq_parameters[j], 'the correlation coef', corr)
    print(' ')

    plt.minorticks_off()
    ax3.tick_params(which='both', direction='in', length=tickLength,
                   width=lineWidth,  pad=tickPad, color=colour1)
    ax3.set_ylabel(r'Concentration_'+ wq_parameters[j] + '[mg/L]',
                  fontsize=fontSize, labelpad=labelPadY)

    
    if wq_parameters[j] == 'SSolids':
        ax3.set_ylim([0, 40])
    elif wq_parameters[j] == 'O2':
        ax3.set_ylim([0, 14])
    else:
        ax3.set_ylim([0, 20])


    ax3.yaxis.set_ticks_position('both')
    ax3.xaxis.set_ticks_position('both')

    ax3.legend()
    # Output File Paths for Plot
    outputFilePath = "./png-compiled/time_figure." + str(data_count) + ".png"
    plt.savefig(outputFilePath)



# plt.show()
