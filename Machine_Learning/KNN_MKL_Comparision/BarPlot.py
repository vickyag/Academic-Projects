import numpy as np
import matplotlib.pyplot as plt
 
# data to plot
n_groups = 4
acc_700 = (100, 100, 89.5, 51.5)
acc_7k = (100, 100, 98.05, 51)
acc_70k = (100, 100, 99.9, 49.9)
 
# create plot
fig, ax = plt.subplots()
index = np.arange(n_groups)
bar_width = 0.2
opacity = 1
 
bar1 = plt.bar(index, acc_700, bar_width,
                 alpha=opacity,
                 color='#4da6ff',
                 label='0.7k')
 
bar2 = plt.bar(index + bar_width, acc_7k, bar_width,
                 alpha=opacity,
                 color='#ff471a',
                 label='7k')

bar3 = plt.bar(index + 2*bar_width, acc_70k, bar_width,
                 alpha=opacity,
                 color='#ace600',
                 label='70k')
 
plt.xlabel('Data Distributions ---------------------->')
plt.ylabel('Accuracy ---------------------->')
plt.title('K-Nearest Neighbours (KNN)')
plt.xticks(index + bar_width, ('Dist1', 'Dist2', 'Dist3', 'Dist4'))
plt.legend()
 
plt.tight_layout()
plt.show()
