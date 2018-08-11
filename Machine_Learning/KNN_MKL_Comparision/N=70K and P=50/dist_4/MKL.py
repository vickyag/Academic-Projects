
# Test:
from sklearn.metrics.pairwise import rbf_kernel
from sklearn.metrics import roc_auc_score
from sklearn.datasets import make_classification
from EasyMKL import EasyMKL
from cvxopt import matrix
import numpy as np

import matplotlib.pyplot as plt
import scipy.io


class1_train = scipy.io.loadmat('class1_train.mat')['class1_train']
class2_train = scipy.io.loadmat('class2_train.mat')['class2_train']
class1_test = scipy.io.loadmat('class1_test.mat')['class1_test']
class2_test = scipy.io.loadmat('class2_test.mat')['class2_test']
size = 50000 # training sample size of each class
train_data = np.concatenate((class1_train[0:size,:], class2_train[0:size,:])) #Train Data
#val_data = np.concatenate((class1_train[size:,:], class2_train[size:,:])) # val data 
test_data = np.concatenate((class1_test[:,:], class2_test[:,:])) # test data 
X = np.concatenate((train_data, test_data)) 
Y = np.zeros(X.shape[0])
for i in range(X.shape[0]):
	if(i<(train_data.shape[0]/2) or (i>=train_data.shape[0] and i<(X.shape[0]-test_data.shape[0]/2))):
		Y[i] = 1
# Binary classification problem
random_state = np.random.RandomState(0)


# Train & Test:
pertr = (train_data.shape[0]*100)/X.shape[0]
X = X.astype(np.double)
X = matrix(X)
Y = matrix([1.0 if y>0 else -1.0 for y in Y])
idtrain = list(range(0,int(len(Y) * pertr / 100)))
idtest = list(range(int(len(Y) * pertr / 100),len(Y)))
Ytr = Y[idtrain]
Yte = Y[idtest]

# Selected features for each weak kernel:
featlist = [[random_state.randint(0,X.size[1]) for i in range(5)] for j in range(50)]

# Generation of the weak Kernels:
klist = [rbf_kernel(X[:,f], gamma = 0.1) for f in featlist]
klisttr = [matrix(k)[idtrain,idtrain] for k in klist]
klistte = [matrix(k)[idtest,idtrain] for k in klist] 

# EasyMKL initialization:
l = 0.5 # lambda
easy = EasyMKL(lam=l, tracenorm = True)
easy.train(klisttr,Ytr)

# Evaluation:
rtr = roc_auc_score(np.array(Ytr),np.array(easy.rank(klisttr)))
#print ('AUC EasyMKL train:',rtr*100)
ranktest = np.array(easy.rank(klistte))
rte = roc_auc_score(np.array(Yte),ranktest)
print ('AUC EasyMKL test:',rte*100)
#print ('weights of kernels:', easy.weights)