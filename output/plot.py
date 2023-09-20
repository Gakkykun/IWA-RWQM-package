import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
from IPython.core.pylabtools import figsize
from matplotlib.offsetbox import AnchoredText
import os, sys

# Figure Width (cm)
figSizeXcm = 16
figSizeYcm = 9
figSizeYcmRev = 32

# Font size in Figures
fontSize = 14

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
# borderPad = 2

# Colours for the line plots - Can use rgb or html
colour1 = 'black'
colour2 = '#D01D3E'

# Plot Configuration
# plt.rcParams['font.family'] = fontChoice
plt.rcParams['axes.linewidth'] = lineWidth


wq_parameters = ['BOD', 'NOX', 'NH4', 'SSolids', 'O2']
segment_length = 1490.0  # [m]
y = {}



# Kuki obervatory points
# 2005 - 2010
monitoring_data_yearly_K_1 = {
    "O2":[
            [7.1, 5.2, 5.5, 6.7, 7.7],
            [6.7, 5.3, 7.5, 5.1, 8.3],
            [6.9, 6.8, 6.6, 5.1, 5.8],
            [5.7, 4.9, 6.8, 3.5, 4.7, 7.3],
            [6.7, 3.1, 5.9, 4.7, 2.8, 6.6],
            [5.3, 5.1, 3.7, 5.7, 3.8, 6.3],
            [2.1, 3.6, 4.5, 5.3, 4.5, 5.3],
            [5.3, 4.9, 5.4, 5.2, 5.9, 7.1],
            [6.9, 8.5, 5.9, 6.4, 6.6, 7],
            [6.2, 6.3, 6.8, 6.9, 9.3, 6.3],
            [7.1, 9, 7, 7.3, 7.9, 7.1],
            [4.5, 5.6, 7.5, 6.2, 6.9, 6.9]
    ],
    "BOD": [
             [5.8, 5.3, 8.2, 9.2, 6.1],
             [6, 5.8, 6.3, 9.4, 10.5],
             [5.5, 5.5, 7.5, 8.6, 10.8],
             [9.4, 4.6, 8.8, 10.8, 6.2, 7],
             [10, 8.8, 4.8, 4.4, 4.6, 5.2],
             [9.4, 4.7, 1.9, 3.5, 5, 4.7],
             [5.7, 9.6, 5.4, 5, 3.8, 4.1],
             [8.5, 5.7, 5, 3.1, 3.1, 4.2],
             [4, 8.3, 7, 2.8, 4.3, 6.5],
             [5.5, 4.4, 1.4, 4.1, 3.7, 5.6],
             [5.6, 5.5, 4, 3, 3.5, 2],
             [4.9, 4.6, 4.4, 3.5, 6.9, 5]
    ],
    "SSolids": [
        [7, 13, 9, 5, 17],
        [5, 12, 8, 12, 16],
        [5, 15, 10, 13, 8],
        [9, 19, 45, 13, 17, 15.6],
        [9, 6, 9, 6, 14, 10.7],
        [3, 4, 5, 10, 48, 4.9],
        [4, 8, 20, 14, 50, 27.7],
        [7, 14, 13, 17, 37, 31.7],
        [18, 59, 21, 22, 36, 30.8],
        [21, 17, 15, 14, 15, 20],
        [9, 15, 15, 9, 14, 4.9],
        [7, 14, 10, 6, 39, 7.3]
    ],
    "NH4": [
        [7.4, 5.92, 6.73, 8.12, 4.19],
        [11.4, 10.06, 5.89, 7.26, 2.27],
        [7, 4.2, 7.79, 9.17, 9.79, 5.91, 9.78],
        [10, 14.83, 3.08, 9.05, 7.11, 4.77],
        [11.7, 16.47, 9.47, 6.66, 6.23],
        [10.7, 16.6, 3.46, 4.34, 5.05],
        [10.2, 8, 2.17, 4.99, 2.02],
        [3.8, 4.79, 3.15, 0.87, 8.32, 4.27],
        [1.7, 7.59, 2, 0.6, 2.39, 4.06],
        [2.4, 1.27, 2.63, 1.06, 4.73, 4.4],
        [3.2, 1.95, 1.49, 1.31, 2.18, 2.72],
        [17.1, 5.89, 2.69, 3.74, 9.18, 8.58]
    ],
    "NOX": [
        [9, 10.4, 10.1, 11.6, 10.2],
        [10.8, 9.4, 10.2, 10.3, 12.9],
        [8, 6.9, 10, 6.7, 11.5],
        [8.5, 9.9, 5.2, 8.3, 6.3, 12.482],
        [11.2, 4.6, 8.6, 12.1, 7.2, 10.699],
        [6.7, 14.7, 11.7, 9.5, 7.8, 11.6],
        [7.7, 13.4, 8.3, 11.4, 11.6, 9.3],
        [9.7, 10.6, 8.4, 10.3, 19.6, 14.4],
        [11.9, 10.3, 10, 11.3, 12.2, 14.2],
        [12.2, 12.1, 13.6, 12.4, 18, 17.3],
        [13.4, 11.3, 12.7, 11.8, 12.2, 14.3],
        [15.7, 14.3, 12.7, 11.7, 20.3, 19.7]
    ]
}

monitoring_data_yearly_K_2 = {
    "O2":[
            [7.8, 7.1, 8.7, 10.5],
            [8.2, 7.4, 11.9, 10.3],
            [9, 7.2, 12.5, 11.3],
            [9.6, 3.5, 11.6, 6.1],
            [4.6, 7.7, 13.6, 9.2],
            [8.4, 4.9, 10.2, 8.8],
            [6.3, 5.8, 7.5, 7.3],
            [4.4, 9.1, 6.3, 7.8],
            [6.9, 5.9, 7.1, 6.9],
            [7, 7.3, 7.1, 8.8],
            [6.8, 8.2, 7.7, 9.4],
            [6.3, 9.1, 7.7, 8.3]
    ],
    "BOD": [
             [3.2, 7.2, 9.3, 2.8],
             [4.8, 8.1, 6.8, 6.6],
             [6.2, 7.6, 8.2, 4],
             [8.1, 13, 7.4, 6.1],
             [7.5, 3.5, 5.5, 3.6],
             [4.8, 7.6, 4.4, 2.5],
             [5.4, 3.5, 9.4, 2.7],
             [4.8, 3.2, 3.9, 2.8],
             [2.1, 3.7, 3, 1.3],
             [2.3, 1.7, 1.7, 1.8],
             [3.2, 2.8, 1.8, 1.2],
             [3.3, 4.6, 3, 2, 2]
    ],
    "SSolids": [
        [6.4, 9.3, 7.2, 4.4],
        [6.2, 11, 5.4, 6.1],
        [13, 15.2, 8.3, 3.9],
        [14.8, 60, 7.6, 25],
        [11.2, 10, 6.8, 5.7],
        [7.9, 34.7, 5.4, 18.9],
        [14.6, 20.4, 32.1, 21.8],
        [31.2, 20, 26.7, 25.3],
        [18.3, 24.9, 19, 58.6],
        [11.6, 12.9, 14.3, 11.2],
        [8.8, 8.2, 8.3, 5.6],
        [5.1, 7.8, 5.4, 2.8]
    ],
    "NH4": [
        [24.6, 7.18, 6.19, 1.02],
        [8.09, 7.49, 4.02, 2.45],
        [5.91, 9.78, 6.49, 2.61],
        [12.04, 6.35, 6.59, 1.65],
        [6.58, 8.08, 4.53, 1.28],
        [5.86, 2.72, 3.06, 0.36],
        [7.31, 1.22, 2.66, 0.45],
        [4.88, 0.61, 0.66, 0.33],
        [0.47, 0.57, 0.44, 0.29],
        [1.03, 0.8, 0.36, 0.19],
        [0.77, 0.88, 0.3, 0.19],
        [2.48, 3.46, 1.31, 0.42]
    ],
    "NOX": [
        [10.9, 7.48, 6.48, 8.19],
        [10.4, 5.77, 6.61, 7.17],
        [9.7, 4.46, 4.74, 7.2],
        [9.95, 3.32, 4.87, 4.55],
        [6.31, 5.63, 4.35, 4.38],
        [9.48, 5.78, 4.17, 7.2],
        [10.89, 7.88, 5.62, 7.24],
        [14.46, 8.14, 7.97, 7.44],
        [10.37, 8.41, 7.86, 8.47],
        [11.5, 9.41, 8.37, 8.81],
        [12.23, 9.05, 8.2, 9.33],
        [11.84, 8.4, 8.59, 9.23]
    ]
}

monitoring_data_yearly_K_3 = {
    "O2":[
            [8.8, 9.3, 8, 8.6, 8.1],
            [9, 9.2, 10.3, 9.8, 7.6],
            [9.6, 10.1, 9.4, 8.6, 6.7],
            [10, 9.9, 5.6],
            [6.6, 8.1, 8.5],
            [4, 4.1, 5.5],
            [5.1, 6.2, 4.3, 4.1],
            [7.2, 4.2, 4.6, 4.1],
            [7, 8, 5.3, 4.9],
            [7.9, 7.5, 8, 6.5],
            [7.8, 9.1, 7.6, 7],
            [7.7, 7.3, 7.9, 5]
    ],
    "BOD": [
             [3.2, 2.1, 3.3, 1.9, 3.4],
             [4.7, 2.4, 3.3, 4.2, 5.5],
             [3.3, 4.3, 5.1, 8.3, 6.1],
             [3.2, 8.5, 6.3],
             [3.1, 5.6, 3.2],
             [4.2, 3.3, 3.2],
             [3.1, 4.6, 2.9, 6.9],
             [3, 2.6, 3.3, 6.2],
             [1.4, 1.5, 1.7, 2.5],
             [1.2, 2.1, 1.3, 1.9],
             [0.9, 1.2, 1.4, 1.7],
             [2, 1.9, 1.8, 5.8]
    ],
    "SSolids": [
        [3.9, 2.2, 2, 2.3, 4],
        [9.8, 3.1, 12.7, 5.2, 5],
        [5.3, 8.2, 9.6, 8.4, 11],
        [4.7, 9.6, 5],
        [12.6, 8, 4],
        [37, 12.2, 28],
        [21, 29.1, 22.3, 15],
        [23.7, 23.4, 28.8, 27],
        [15.5, 24.2, 13.1, 17],
        [12.3, 13.7, 8.1, 20],
        [5.2, 4.3, 10.9, 8],
        [2.8, 2.8, 3.8, 18]
    ],
    "NH4": [
        [3.78, 2.07, 4.31, 0.97, 2.3],
        [1.88, 2.46, 2.73, 4.11, 2.7],
        [1.5, 4.58, 4.67, 2.19, 1.4],
        [3.62, 2.09, 3.11],
        [2.23, 2.74, 2.7],
        [1.17, 1.68, 2],
        [0.74, 0.81, 0.54, 1.8],
        [0.37, 0.37, 0.43, 0.37],
        [0.17, 0.19, 0.15, 0.12],
        [0.16, 0.39, 0.14, 0.19],
        [0.29, 0.29, 0.2, 0.1],
        [0.43, 1.09, 0.37, 0.83]
    ],
    "NOX": [
        [8.32, 8.98, 6.31, 8.95, 6.9],
        [5.75, 7.59, 7.31, 7.16, 6.5],
        [6.19, 6.74, 4.68, 6.54, 5.33],
        [4.92, 5.36, 2.97],
        [2.78, 2.72, 3.9],
        [5.27, 5.78, 1.29],
        [6.83, 6.83, 6.75, 4.4],
        [8.64, 6.96, 8.15, 7.3],
        [8.82, 8.75, 8.09, 7.68],
        [9.86, 9.12, 8.44, 7.8],
        [10.49, 10.15, 8.75, 8.3],
        [9.74, 10.64, 8.5, 7.32]
    ]
}

# Kuki obervatory points
# Median data calculated with LibreOffice at Kuki observatory point (2005 - 2010) 
monitoring_data_1_K = {      
    "O2": [6.7, 6.7, 6.6, 5.3, 5.3, 5.2, 4.5, 5.35, 6.75, 6.55, 7.2, 6.55],
    "BOD": [6.1, 6.3, 7.5, 7.9, 5, 4.7, 5.2, 4.6, 5.4, 4.25, 3.75, 4.75],
    "SSolids": [9, 12, 10, 16.3, 9, 4.95, 17, 15.5, 26.4, 16, 11.5, 8.65],
    "NH4": [6.73, 7.26, 7.79, 8.08, 10.59, 7.88, 6.50, 4.04, 2.20, 2.52, 2.07, 7.24],
    "NOX": [10.20, 10.30, 8.00, 8.40, 9.65, 10.55, 10.35, 10.45, 11.60, 13.00, 12.45, 15.00],
} 

# Median data calculated with LibreOffice at Kuki observatory point (2011 - 2014) 
monitoring_data_2_K = {      
    "O2": [8.25, 9.25, 10.15, 7.85, 8.45, 8.6, 6.8, 7.05, 6.9, 7.2, 7.95, 8],
    "BOD": [5.2, 6.7, 6.9, 7.75, 4.55, 4.6, 4.45, 3.55, 2.55, 1.75, 2.3, 3.15],
    "SSolids": [6.8, 6.15, 10.65, 19.9, 8.4, 13.4, 21.1, 26, 21.95, 12.25, 8.25, 5.25],
    "NH4": [6.685, 5.755, 6.2, 6.47, 5.555, 2.89, 1.94, 0.635, 0.455, 0.58, 0.535, 1.895],
    "NOX": [7.835, 6.89, 5.97, 4.71, 5.005, 6.49, 7.56, 8.055, 8.44, 9.11, 9.19, 8.91],
} 

# Median data calculated with LibreOffice at Kuki observatory point (2015 - 2018) 
monitoring_data_3_K = {      
    "O2": [8.6, 9.2, 9.4, 9.9, 8.1, 4.1, 4.7, 4.4, 6.15, 7.7, 7.7, 7.5],
    "BOD": [3.2, 4.2, 5.1, 6.3, 3.2, 3.3, 3.85, 3.15, 1.6, 1.6, 1.3, 1.95],
    "SSolids": [2.3, 5.2, 8.4, 5, 8, 28, 21.65, 25.35, 16.25, 13, 6.6, 3.3],
    "NH4": [2.3, 2.7, 2.19, 3.11, 2.7, 1.68, 0.775, 0.37, 0.16, 0.175, 0.245, 0.63],
    "NOX": [8.32, 7.16, 6.19, 4.92, 2.78, 5.27, 6.79, 7.725, 8.42, 8.78, 9.45, 9.12],
} 

monitoring_data_K = [monitoring_data_1_K, monitoring_data_2_K, monitoring_data_3_K]

simulation_month = 12
data_count = eval(sys.argv[1])

plt.rcParams["figure.figsize"] = (figSizeXinches, figSizeYinches)
plt.rcParams.update({'font.size': 12})

monitoring_data_yearly_K = [monitoring_data_yearly_K_1, monitoring_data_yearly_K_2, monitoring_data_yearly_K_3]


t = [i+1 for i in range(simulation_month)]


for i, wq in enumerate(wq_parameters):
    wq_yearly_data = []

    for month_count in range(simulation_month):
        if month_count < 9:
            month_count_char = "0"+str(month_count+1)
        else:
            month_count_char = str(month_count+1)

        df = pd.read_csv(
            f'./output-csv/Output{wq}.' + month_count_char + '-0' + str(data_count) + '.csv',
            header=None
        )

        data_array = df.to_numpy()
        
        div_number = len(data_array[-1, :])
        div_length = segment_length/div_number
        # print('div number', div_number)
        # print('div length', div_length)

        y[wq] = data_array
        distance = np.array([i*div_length for i in range(1,div_number+1)])
        # print('distance', distance) 
        
        # print(y[wq][-1, -1])
        # print(len(y[wq][-1,:]))
        wq_yearly_data.append(y[wq][-1, -1])

        fig2, ax2 = plt.subplots()
        # fig2.tight_layout(pad=borderPad)
        fig2.tight_layout()

        # Graph at the end of a month
        ax2.plot(distance, y[wq][-1, :], '-', markersize=markerSize,
                 linewidth=lineWidth+0.5, color='k')
        # print(y[wq][-1, 1:])
        plt.minorticks_off()
        ax2.tick_params(which='both', direction='in', length=tickLength,
                        width=lineWidth,  pad=tickPad, color=colour1)
        ax2.grid(color=colour1, linewidth=lineWidth, alpha=0.3)
        ax2.set_xlabel(r'Distance [m]', fontsize=fontSize, labelpad=labelPadX)
        ax2.set_ylabel(r'Concentration [mg/L]',
                       fontsize=fontSize, labelpad=labelPadY)
        ax2.set_title(wq+'-' + month_count_char)
        ax2.yaxis.set_ticks_position('both')
        ax2.xaxis.set_ticks_position('both')
        outputFilePath2 = "./png/distance_figure_" + wq + '-' + month_count_char + '-' + str(data_count) +  ".png"
        plt.savefig(outputFilePath2)
        plt.close()


    fig1, ax = plt.subplots()
    if wq_parameters[i] == 'SSolids':
        ax.set_ylim([0, 40])
    elif wq_parameters[i] == 'NOX': 
        ax.set_ylim([0, 20])
    elif  wq_parameters[i] == 'NH4':
        ax.set_ylim([0, 16])
    else:
        ax.set_ylim([0, 14])

    # fig1.tight_layout(pad=borderPad)
    fig1.tight_layout()
    ax.plot(t, wq_yearly_data[:simulation_month], '-', markersize=markerSize,
            linewidth=lineWidth+0.5, color=colour1, label="Model output")

    ax.boxplot(monitoring_data_yearly_K[data_count-1][wq][:],
        boxprops=dict(color='k'),
        capprops=dict(color='k'),
        whiskerprops=dict(color='k'),
        flierprops=dict(color='k', markeredgecolor='k'),
        medianprops=dict(color='k')
        )
        # ax.errorbar(t, monitoring_data_K[wq][:simulation_month], monitoring_data_sd_K[wq][:simulation_month], \
        #     marker='s', linestyle='', color=colour1, label='Observed data')

    plt.minorticks_off()
    ax.tick_params(which='both', direction='in', length=tickLength,
                   width=lineWidth,  pad=tickPad, color=colour1)
    # ax.grid(color=colour1, linewidth=lineWidth, alpha=0.3)
    ax.set_xlabel(r'time (month)', fontsize=fontSize, labelpad=labelPadX)

    if wq_parameters[i] == 'NOX':
        ax.set_ylabel(r'Concentration (mg-N/L)',
                  fontsize=fontSize, labelpad=labelPadY)
    elif wq_parameters[i] == 'NH4':
        ax.set_ylabel(r'Concentration (mg-N/L)',
                  fontsize=fontSize, labelpad=labelPadY)
    else:
        ax.set_ylabel(r'Concentration (mg/L)',
                  fontsize=fontSize, labelpad=labelPadY)

    ax.yaxis.set_ticks_position('both')
    ax.xaxis.set_ticks_position('both')

    
    # correlation coefficient
    # Y = np.array(monitoring_data_yearly_K[data_count-1][wq][:simulation_month])
    Y = np.array(monitoring_data_K[data_count-1][wq][:simulation_month])
    Yhat = np.array(wq_yearly_data[:simulation_month])

    # print("Y:", Y)
    # print("Y hat:", Yhat)
    corr = np.corrcoef(np.vstack((Y,Yhat)))[0,1]

    # RMSE
    rmse = np.sqrt(np.mean((Y - Yhat) ** 2))
    print("RMSE: " , np.round(rmse,3), ' for ', wq, " at ", data_count, )
    at = AnchoredText(
    f"RMSE: {np.round(rmse,2)}\nr: {np.round(corr,2)}", prop=dict(size=14), frameon=True, loc='upper left')
    at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    ax.add_artist(at)

    # ax.set_title(f'{wq} in time period {data_count}; r = {round(corr, 2)} ')

    # Output File Paths for Plot
    if wq == 'BOD' and data_count == 1:
        outputFilePath = "./png/figure-3-a.png"
    elif wq == 'BOD' and data_count == 2:
        outputFilePath = "./png/figure-3-b.png"
    elif wq == 'BOD' and data_count == 3:
        outputFilePath = "./png/figure-3-c.png"
    elif wq == 'NOX' and data_count == 1:
        outputFilePath = "./png/figure-3-d.png"
    elif wq == 'NOX' and data_count == 2:
        outputFilePath = "./png/figure-3-e.png"
    elif wq == 'NOX' and data_count == 3:
        outputFilePath = "./png/figure-3-f.png"
    elif wq == 'NH4' and data_count == 1:
        outputFilePath = "./png/figure-3-g.png"
    elif wq == 'NH4' and data_count == 2:
        outputFilePath = "./png/figure-3-h.png"
    elif wq == 'NH4' and data_count == 3:
        outputFilePath = "./png/figure-3-i.png"
    elif wq == 'SSolids' and data_count == 1:
        outputFilePath = "./png/figure-3-j.png"
    elif wq == 'SSolids' and data_count == 2:
        outputFilePath = "./png/figure-3-k.png"
    elif wq == 'SSolids' and data_count == 3:
        outputFilePath = "./png/figure-3-l.png"
    elif wq == 'O2' and data_count == 1:
        outputFilePath = "./png/figure-3-m.png"
    elif wq == 'O2' and data_count == 2:
        outputFilePath = "./png/figure-3-n.png"
    elif wq == 'O2' and data_count == 3:
        outputFilePath = "./png/figure-3-o.png"

    plt.savefig(outputFilePath)
    plt.close()


# plt.show()
