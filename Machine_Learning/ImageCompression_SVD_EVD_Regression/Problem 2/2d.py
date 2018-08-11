import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import matplotlib as mpl
from sklearn.model_selection import train_test_split
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
polynomial_degree = input("Enter polynomial degree(1-5)::")

print "Give labda as zero (0) to perform simple linear regression "
print "=========================================================="
print "Give Lambda as other than one to perform ridge regression"
print "=========================================================="
lamda = input("Enter the Regularization Parameter lambda::")
print "********************************************************"
print "Example Absolute Path /home/machine/Videos/Assignment-1/q16_2.txt"
print "================================================================="

#file_path = raw_input("Enter file path::")
file_path = "q16_2.txt"
if(polynomial_degree == 1):
	for line in open(file_path):
	#print line
		x1,x2,y = line.split()
		x1=float(x1)
		x2=float(x2)
		X.append([1,x1,x2])
		Y.append(float(y))
	file_name = "2d_1_weights.txt"
elif(polynomial_degree == 2):
	for line in open(file_path):
		x1,x2,y = line.split()
		x1=float(x1)
		x2=float(x2)
		X.append([1,x1,x2,x1**2,x2**2,x1*x2])
		Y.append(float(y))
	file_name = "2d_2_weights.txt"
elif(polynomial_degree==3):
	for line in open(file_path):
	
		x1,x2,y = line.split()
		x1=float(x1)
		x2=float(x2)
		X.append([1,x1,x2,x1**2,x2**2,x1*x2,x1**3,x2**3,(x1**2)*x2,x1*(x2**2)])
		Y.append(float(y))
	file_name = "2d_3_weights.txt"
elif(polynomial_degree ==  4):
	for line in open(file_path):
		x1,x2,y = line.split()
		x1=float(x1)
		x2=float(x2)
		X.append([1,x1,x2,x1**2,x2**2,x1*x2,x1**3,x2**3,(x1**2)*x2,x1*(x2**2),(x1)**4,(x1**2)*(x2**2),(x2)*(x1)**3,(x1)*(x2)**3,(x2)**4])
		Y.append(float(y))
	file_name = "2d_4_weights.txt"
elif(polynomial_degree == 5):
	for line in open(file_path):
		x1,x2,y = line.split()
		x1=float(x1)
		x2=float(x2)
		X.append([1,x1,x2,x1**2,x2**2,x1*x2,x1**3,x2**3,(x1**2)*x2,x1*(x2**2),(x1)**4,(x1**2)*(x2**2),(x2)*(x1)**3,(x1)*(x2)**3,(x2)**4,x1**5,x2**5,(x1**2)*(x2**3),(x1**3)*(x2**2),(x1**4)*(x2),(x2**4)*x1])
		Y.append(float(y))
	file_name = "2d_5_weights.txt"

	
#Converting the X,Y to numpy arrays
X=np.array(X)
Y=np.array(Y)

X_train_V, X_test, y_train_V, y_test = train_test_split(X, Y, test_size=0.1, random_state=42)
X_train, X_validate, y_train, y_validate = train_test_split(X_train_V, y_train_V, test_size=0.22, random_state=42)

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
	
	plt.scatter(X_test[:,1],y_test)
	plt.plot(sorted(X_test[:,1]), sorted(y_test) , '*g' ,markersize=8, label = "TestData")  # solid green
	plt.plot(sorted(X_test[:,1]), sorted(Yhat_test_without_sorted), '.r',markersize=4,label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature")
	plt.ylabel("Output")
	plt.legend()

	#plot scatter plot and plane
	X1,X2 = np.meshgrid(X1_train[:,1], X1_train[:,2])
	plt3d = plt.figure().gca(projection='3d')
	plt3d.scatter(X_train[:,1],X_train[:,2],y_train)
	plt3d.set_xlabel("Input Feature 1")
	plt3d.set_ylabel("Input Feature 2")
	plt3d.set_zlabel("Expected Output")
	plt3d.plot_surface((X1),(X2),sorted(Yhat), color='red' , label = 'Model Fit')
	fake2Dline = mpl.lines.Line2D([0],[0], linestyle="none", c='r', marker = 'o')
	plt3d.legend([fake2Dline], ['Trained Model in X,Y plane'], numpoints = 1)

	#graph for test data
	plt3d_test = plt.figure().gca(projection='3d')
	X1_test_M,X2_test_M = np.meshgrid(X1_test[:,1], X1_test[:,2])
	plt3d_test.scatter(X_test[:,1],X_test[:,2],y_test,c='red')
	plt3d_test.set_xlabel("Input Feature 1")
	plt3d_test.set_ylabel("Input Feature 2")
	plt3d_test.set_zlabel("Expected Output")
	plt3d_test.plot_surface((X1_test_M),(X2_test_M),sorted(Yhat_test), color='lightgreen' , label = "Model Fit")
	fake2Dline = mpl.lines.Line2D([0],[0], linestyle="none", c='lightgreen', marker = 'p')
	plt3d_test.legend([fake2Dline], ['test data in X,Y plane'], numpoints = 1)

	plt.show()


else:
	X_T=[]
	Y_T=[]
#Converting the X,Y to numpy arrays
	X_T=np.array(X)
	Y_T=np.array(Y)
	w_t = []
	for line in open('2d_5_weights.txt'):
		w_t.append(float(line))
	w_t = np.array(w_t)


	X1_test =  X_T[np.argsort(X_T[:,1])];
	Yhat_custom_test = np.dot(X1_test,w_t)
	Yhat_custom_test_without_sorted = np.dot(X_T,w_t)
	#print Yhat_custom_test_without_sorted
	plt.scatter(X_T[:,1],Y_T)
	plt.plot(sorted(X_T[:,1]), sorted(Y_T) , '*g' ,markersize=8, label = "TestData")  # solid green
	plt.plot(sorted(X_T[:,1]), sorted(Yhat_custom_test_without_sorted), '.r' ,markersize=4,label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature")
	plt.ylabel("Output")
	plt.legend()
	plt.show()
	#print X_T