import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import matplotlib as mpl
from pylab import *
from termcolor import colored

X=[]
Y=[]
count = 0
print "Do you want to test the data"
print "============================"
print "If you want to test give input as number 1 or else give 0"
print "====================================="
print "Exampl==>Enter input::1"
test = input("Enter input::")
print "============================================"

polynomial_degree = input("Enter polynomial degree(1-3)::")
print "============================================"

print "Give labda as zero (0) to perform simple linear regression "
print "=========================================================="
print "Give Lambda as other than one to perform ridge regression"
print "=========================================================="
lamda = input("Enter the Regularization Parameter lambda::")
print "********************************************************"
print "Example Absolute Path /home/machine/Videos/Assignment-1/16_3.txt"
print "================================================================="

file_path = raw_input("Enter file path::")

if(polynomial_degree == 1):
	for line in open(file_path):
		x1,x2,x3,x4,x5,x6,x7,x8,x9,y = line.split()
		X.append([1,float(x1),float(x2),float(x3),float(x5),float(x6),float(x7),float(x8)])
		Y.append(float(y))
		file_name = "nd_weight_1.txt"
elif(polynomial_degree == 2):
	for line in open("16_3.txt"):
		x1,x2,x3,x4,x5,x6,x7,x8,x9,y = line.split()
		X.append([1,float(x1),float(x2),float(x3),float(x5),float(x6),float(x7),float(x8)])
		z  = X[-1]
		#print z
		for i in range(1,10):
			for j in range(i,10):
					X[-1].append(z[i]*z[j])
		Y.append(float(y))
		file_name = "nd_weight_2.txt"
elif(polynomial_degree==3):
	for line in open("16_3.txt"):
		x1,x2,x3,x4,x5,x6,x7,x8,x9,y = line.split()
		X.append([1,float(x1),float(x2),float(x3),float(x5),float(x6),float(x7),float(x8)])
		z  = X[-1]
		#print z
		for i in range(1,10):
			for j in range(i,10):
					X[-1].append(z[i]*z[j])


		z  = X[-1]
		for i in range(1,10):
			for j in range(i,10):
				for k in range(j,10):
					X[-1].append(z[i]*z[j]*z[k])

		Y.append(float(y))
		file_name = "nd_weight_3.txt"






X=np.array(X)
Y=np.array(Y)


X_train_V, X_test, y_train_V, y_test = train_test_split(X, Y, test_size=0.1, random_state=42)
X_train, X_validate, y_train, y_validate = train_test_split(X_train_V, y_train_V, test_size=0.22, random_state=42)
#print X[1:100:,1]
#print Y[1:100]

x_t_x_train = np.dot(X_train.T,X_train) 
dime = x_t_x_train.shape
I = np.identity(dime[0])





#sort the arrays according to the first column
X1_train =  X_train[np.argsort(X_train[:,1])];
X1_test =  X_test[np.argsort(X_test[:,1])];
X1_validate =  X_validate[np.argsort(X_validate[:,1])];

#calculating the weight matrix
w = np.linalg.solve((np.dot(X_train.T, X_train)+lamda*I), np.dot(X_train.T, y_train))
#save it into file
np.savetxt(file_name, w) 



Yhat_without_sort = np.dot(X_train, w)
Yhat = np.dot(X1_train, w)
#fo.close()
#print y_prediction

#predict the data for test data
Yhat_test = np.dot(X1_test,w)
Yhat_test_without_sorted = np.dot(X_test,w)
Yhat_valid = np.dot(X1_validate,w)
Yhat_valid_without_sorted = np.dot(X_validate,w)
#plot versus predicted data and test data

if test!=1:


	#calcualte r squared for training data
	d1 = y_train - Yhat_without_sort
	d2 = y_train - y_train.mean()
	r2 = 1 - d1.dot(d1) / d2.dot(d2)
	print "the r-squared for training data is:", r2

	d1_test = y_test - Yhat_test_without_sorted
	d2_test = y_test - y_test.mean()
	r2_test = 1 - d1_test.dot(d1_test) / d2_test.dot(d2_test)
	print "the r-squared for test data is:", r2_test

	d1_valid = y_validate - Yhat_valid_without_sorted
	d2_valid = y_validate - y_validate.mean()
	r2_valid = 1 - d1_valid.dot(d1_valid) / d2_valid.dot(d2_valid)
	print "the r-squared for validation data is:", r2_valid

	d1_valid = d1_valid.dot(d1_valid)
	#d1_valid=np.sum(d1_valid)
	shape= y_validate.shape
	error=d1_valid/2
	print "error in validation is::",error
	#print shape[0]
	d1_valid=d1_valid/shape[0]
	#print d1_valid
	rmsd = sqrt(d1_valid)
	print "root mean squared error for Validation Data",rmsd


	#plt.scatter(X_test[1:3000:,1],y_test[1:3000])
	plt.plot(sorted(X_test[1:3000:,1]), sorted(y_test[1:3000]) , '*g' ,markersize=8, label = "TestData")  # solid green
	plt.plot(sorted(X_test[1:3000:,1]), sorted(Yhat_test_without_sorted[1:3000]), '.r',markersize=4,label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature")
	plt.ylabel("Output")
	plt.legend()

	#plot scatter plot and plane
	X1,X2 = np.meshgrid(X1_train[1:3000:,1], X1_train[1:3000:,2])
	plt3d = plt.figure().gca(projection='3d')
	plt3d.scatter(X_train[1:3000:,1],X_train[1:3000:,2],y_train[1:3000])
	plt3d.set_xlabel("Input Feature 1")
	plt3d.set_ylabel("Input Feature 2")
	plt3d.set_zlabel("Expected Output")
	plt3d.plot_surface((X1),(X2),sorted(Yhat[1:3000]), color='red' , label = 'Model Fit')
	fake2Dline = mpl.lines.Line2D([0],[0], linestyle="none", c='r', marker = 'o')
	plt3d.legend([fake2Dline], ['Trained Model in X,Y plane'], numpoints = 1)

	#graph for test data
	plt3d_test = plt.figure().gca(projection='3d')
	X1_test_M,X2_test_M = np.meshgrid(X1_test[1:3000:,1], X1_test[1:3000:,2])
	plt3d_test.scatter(X_test[1:3000:,1],X_test[1:3000:,2],y_test[1:3000],c='red')
	plt3d_test.set_xlabel("Input Feature 1")
	plt3d_test.set_ylabel("Input Feature 2")
	plt3d_test.set_zlabel("Expected Output")
	plt3d_test.plot_surface((X1_test_M),(X2_test_M),sorted(Yhat_test[1:3000]), color='lightgreen' , label = "Model Fit")
	fake2Dline = mpl.lines.Line2D([0],[0], linestyle="none", c='lightgreen', marker = 'p')
	plt3d_test.legend([fake2Dline], ['test data in X,Y plane'], numpoints = 1)

	plt.show()




else:
	X_T=X
	Y_T=Y
#Converting the X,Y to numpy arrays
	X_T=np.array(X)
	Y_T=np.array(Y)
	X1_test =  X_T[np.argsort(X_T[:,1])];
	Yhat_custom_test = np.dot(X1_test,w)
	Yhat_custom_test_without_sorted = np.dot(X_T,w)
	#print Yhat_custom_test_without_sorted
	plt.scatter(X_T[1:3000:,1],Y_T[1:3000])
	plt.plot(sorted(X_T[1:3000:,1]), sorted(Y_T[1:3000]) , '*g' ,markersize=8, label = "TestData")  # solid green
	plt.plot(sorted(X_T[1:3000:,1]), sorted(Yhat_custom_test_without_sorted[1:3000]), '.r' ,markersize=4,label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature")
	plt.ylabel("Output")
	plt.legend()
	plt.show()