import pandas as pd
import numpy as np
import seaborn as sns
import math
import matplotlib.pyplot as plt


def loadData():
    train = pd.read_csv("kc_house_train_data.csv")
    test = pd.read_csv("kc_house_test_data.csv")
    return [train, test]

def cleanData():
    [train, test] = loadData()
    IDs = train['id']
    actual_price = train['price']
    train = train.drop(['id', 'price'], axis = 1)
    i = 0
    conv_dates = []
    for value in train['date']:
        year = int(value[:4])
        month = int(value[4:6])
        day = int(value[6:8])
        conv_dates.insert(i, year*365 + month*30 + day) 
        i = i+1
    min_date = min(conv_dates)
    conv_dates = [date-min_date for date in conv_dates]
    train['date'] = conv_dates
    return [train, test, actual_price, IDs]

[train, test, actual_price, IDs] = cleanData()


temp = train
temp['price'] = actual_price 
corrmat = temp.corr()
f, ax = plt.subplots(figsize=(12, 9))
sns.heatmap(corrmat, vmax=.8, square=True,linewidth=0.3);
plt.show()
plt.savefig("correlatioMat.png")
