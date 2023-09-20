# The code was developed, referring to https://reedgroup.github.io/FigureLibrary/MOEADiagnostics.html

import pandas as pd
import matplotlib.pyplot as plt
from pandas.plotting import parallel_coordinates

rankings_kinetic = pd.read_csv('sensitivities_ranking_kinetic.csv')
fig, ax =plt.subplots(figsize=(5,5))

parallel_coordinates(rankings_kinetic, 'Params', linewidth=3, alpha=.8, ax=ax)
ax.set_ylabel('Sensitivity measures, $\delta_j^msqr$')
ax.get_legend().remove()
ax.annotate('$k_{hyd,T_0}$', xy =(2.0, rankings_kinetic['data_period_3'][0]), alpha=.8)

ax.annotate('$k_{gro,N1,T_0}$', xy =(2.0, rankings_kinetic['data_period_3'][1]))

ax.annotate('$k_{NO_2,N2}$', xy =(2.0, rankings_kinetic['data_period_3'][2]+0.1))

ax.annotate('$k_{gro,Haer,T_0}$', xy =(2.0, rankings_kinetic['data_period_3'][3]))

ax.annotate('$k_{S,H,aer}$', xy =(2.0, rankings_kinetic['data_period_3'][4]))

ax.annotate('$k_{gro,N2,T_0}$', xy =(2.0, rankings_kinetic['data_period_3'][5]))

ax.annotate('$k_{NH_4,N1}$', xy =(2.0, rankings_kinetic['data_period_3'][6]))

ax.annotate('$k_{HPO_4,N1}$', xy =(2.0, rankings_kinetic['data_period_3'][7]-0.1))


ax.set_yscale('log')
# ax.set_title('(a) Kinetic parameters')
ax.set_aspect(2)

plt.savefig('parameter-ranking-1.png')

rankings_WQ = pd.read_csv('sensitivities_ranking_WQ.csv')

fig2, ax2 =plt.subplots(figsize=(5,5))

parallel_coordinates(rankings_WQ, 'Params', linewidth=3, alpha=.8, ax=ax2)
ax2.set_ylabel('Sensitivity measures $\delta_j^msqr$')
ax2.get_legend().remove()

ax2.annotate(r'$\rho_{dir}$', xy =(2.0, rankings_WQ['data_period_3'][0]))

ax2.annotate('$S_S - TJ_{Gray}$', xy =(2.0, rankings_WQ['data_period_3'][1]))

ax2.annotate(r'$\rho_{chu}$', xy =(2.0, rankings_WQ['data_period_3'][2]))

ax2.annotate('$S_S - KU$', xy =(2.0, rankings_WQ['data_period_3'][3]))

ax2.annotate('$X_S - TJ_{Gray}$', xy =(2.0, rankings_WQ['data_period_3'][4]))

ax2.annotate('$X_H - TJ_{Gray}$', xy =(2.0, rankings_WQ['data_period_3'][5]+0.2))
ax2.annotate('$X_{N1} - TJ_{Gray}$', xy =(2.0, rankings_WQ['data_period_3'][6]))
ax2.annotate('$X_{N2} - TJ_{Gray}$', xy =(2.0, rankings_WQ['data_period_3'][7]-0.3))
ax2.annotate('$X_S - KU$', xy =(2.0, rankings_WQ['data_period_3'][8]))
ax2.annotate('$S_{NH_4} - TJ_{Black}$', xy =(2.0, rankings_WQ['data_period_3'][9]+0.2))


ax2.set_yscale('log')
# ax2.set_title('(b) Water quality components and prevalence ratios')
ax2.set_aspect(2)

plt.savefig('parameter-ranking-2.png')

