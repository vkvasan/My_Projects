#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 27 08:41:03 2021

@author: v
"""
import pandas as pd
import numpy as np
import torch.nn as nn
import torch 
import torch.nn.functional as F
import pylab as plt
import numpy as np 
from torch.utils.data import DataLoader
from torch.utils.data import TensorDataset
import math
from math import sqrt 
import csv
import copy 
from fitter import Fitter

def evision( Distributions,  Dataset ,threshold ):
        
        No_of_nodes = len(Dataset)
        
        No_of_features = len(Distributions[0])     #including output 
        
        count = 0 
        
        I=[] # Array containing i's of Distribution that do not correlate well with any Data set's Distribtution Statistics 
        
        New_Dataset =[]
        
        for i in range(0,No_of_nodes):
            for j in range(i+1, No_of_nodes):
                count = 0
                found = 0
                for s in range(0,No_of_features):
                    if Distributions[i][s] ==  Distributions[j][s]:
                        count = count+ 1
                if count>= threshold:
                    count = 0
                    found =1 
                    break      
            if found != 1:
                I.append(i)
            else: 
                I.append(No_of_nodes)
                    
        for i in  range(0,No_of_nodes):
            if I[i] != i :
                New_Dataset.append(Dataset[i]) 
    
        
        return New_Dataset,I
    
Distribution_statistics = [[['rdist'], ['powerlaw'], ['powerlaw'], ['loglaplace'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['alpha'], ['powerlaw'], ['dgamma'], ['kstwobign'], ['beta'], ['weibull_max'], ['gausshyper']], [['johnsonsb'], ['johnsonsb'], ['johnsonsu'], ['dweibull'], ['powerlaw'], ['gausshyper'], ['johnsonsb']], [['levy'], ['laplace'], ['dgamma'], ['exponnorm'], ['dweibull'], ['gausshyper'], ['johnsonsb']], [['arcsine'], ['chi2'], ['genextreme'], ['gennorm'], ['tukeylambda'], ['levy_l'], ['gausshyper']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['gausshyper'], ['dgamma'], ['genpareto'], ['gennorm']], [['johnsonsu'], ['johnsonsu'], ['exponnorm'], ['cauchy'], ['genextreme'], ['genpareto'], ['genlogistic']], [['johnsonsu'], ['johnsonsu'], ['gennorm'], ['johnsonsb'], ['dgamma'], ['johnsonsu'], ['johnsonsb']], [['johnsonsb'], ['beta'], ['vonmises_line'], ['dgamma'], ['dgamma'], ['johnsonsb'], ['genlogistic']], [['johnsonsb'], ['genextreme'], ['gennorm'], ['triang'], ['johnsonsb'], ['gausshyper'], ['exponnorm']], [['powernorm'], ['powernorm'], ['powernorm'], ['gennorm'], ['dgamma'], ['dgamma'], ['dweibull']], [['dgamma'], ['cauchy'], ['gennorm'], ['exponnorm'], ['dgamma'], ['johnsonsu'], ['triang']], [['burr12'], ['dweibull'], ['gennorm'], ['genlogistic'], ['dgamma'], ['weibull_max'], ['gumbel_r']], [['genpareto'], ['johnsonsb'], ['triang'], ['triang'], ['dgamma'], ['johnsonsb'], ['dgamma']], [['powerlaw'], ['nakagami'], ['genlogistic'], ['burr'], ['dgamma'], ['genpareto'], ['dweibull']], [['cauchy'], ['dgamma'], ['foldcauchy'], ['gennorm'], ['loggamma'], ['beta'], ['genextreme']], [['gennorm'], ['beta'], ['gennorm'], ['dweibull'], ['dgamma'], ['gausshyper'], ['powerlognorm']], [['chi'], ['erlang'], ['dgamma'], ['dgamma'], ['dgamma'], ['genpareto'], ['mielke']], [['ncx2'], ['powernorm'], ['powerlaw'], ['dgamma'], ['dweibull'], ['burr12'], ['gennorm']], [['genlogistic'], ['genlogistic'], ['betaprime'], ['gennorm'], ['dgamma'], ['dgamma'], ['genlogistic']], [['gennorm'], ['beta'], ['burr12'], ['genlogistic'], ['loggamma'], ['johnsonsu'], ['dweibull']], [['gennorm'], ['johnsonsu'], ['gennorm'], ['burr12'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['johnsonsb'], ['nakagami'], ['dgamma'], ['triang'], ['triang'], ['genpareto'], ['johnsonsb']], [['halflogistic'], ['halflogistic'], ['loggamma'], ['dgamma'], ['dgamma'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['gennorm'], ['dgamma'], ['gausshyper'], ['genlogistic']], [['gennorm'], ['gennorm'], ['dweibull'], ['mielke'], ['johnsonsb'], ['pearson3'], ['genextreme']], [['gennorm'], ['beta'], ['dweibull'], ['gennorm'], ['dgamma'], ['johnsonsb'], ['mielke']], [['fatiguelife'], ['johnsonsb'], ['laplace'], ['dgamma'], ['dgamma'], ['johnsonsb'], ['johnsonsb']], [['betaprime'], ['pareto'], ['betaprime'], ['gennorm'], ['triang'], ['dgamma'], ['burr']], [['t'], ['powernorm'], ['powernorm'], ['dweibull'], ['dgamma'], ['rdist'], ['kstwobign']], [['arcsine'], ['tukeylambda'], ['genlogistic'], ['dgamma'], ['dweibull'], ['weibull_max'], ['johnsonsb']], [['gennorm'], ['levy_l'], ['gengamma'], ['mielke'], ['dgamma'], ['gennorm'], ['dweibull']], [['johnsonsb'], ['dgamma'], ['dgamma'], ['kstwobign'], ['laplace'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['levy'], ['dweibull'], ['laplace'], ['dgamma'], ['triang'], ['johnsonsu']], [['gennorm'], ['johnsonsu'], ['dgamma'], ['triang'], ['dgamma'], ['beta'], ['johnsonsb']], [['johnsonsb'], ['powerlaw'], ['johnsonsb'], ['triang'], ['laplace'], ['johnsonsu'], ['dweibull']], [['levy_l'], ['johnsonsb'], ['johnsonsb'], ['dweibull'], ['dweibull'], ['genpareto'], ['gausshyper']], [['johnsonsu'], ['gennorm'], ['gennorm'], ['johnsonsu'], ['dgamma'], ['johnsonsu'], ['dweibull']], [['johnsonsu'], ['cauchy'], ['rdist'], ['dweibull'], ['gennorm'], ['johnsonsu'], ['johnsonsb']], [['johnsonsb'], ['dweibull'], ['exponpow'], ['gausshyper'], ['arcsine'], ['dweibull'], ['foldnorm']], [['dgamma'], ['gennorm'], ['gausshyper'], ['dweibull'], ['dweibull'], ['gausshyper'], ['gennorm']], [['chi2'], ['pareto'], ['betaprime'], ['gennorm'], ['mielke'], ['rdist'], ['dweibull']], [['chi'], ['pareto'], ['betaprime'], ['burr'], ['gennorm'], ['weibull_max'], ['dgamma']], [['johnsonsu'], ['gennorm'], ['gennorm'], ['exponnorm'], ['dgamma'], ['beta'], ['dgamma']], [['cauchy'], ['lognorm'], ['dweibull'], ['loglaplace'], ['dgamma'], ['beta'], ['johnsonsb']], [['loglaplace'], ['johnsonsb'], ['dweibull'], ['gennorm'], ['dgamma'], ['genpareto'], ['exponnorm']], [['johnsonsb'], ['johnsonsb'], ['triang'], ['gennorm'], ['ncf'], ['gausshyper'], ['dgamma']], [['powernorm'], ['powernorm'], ['frechet_l'], ['dweibull'], ['dgamma'], ['beta'], ['dgamma']], [['dgamma'], ['gennorm'], ['burr12'], ['dgamma'], ['dgamma'], ['gausshyper'], ['johnsonsb']], [['arcsine'], ['dweibull'], ['dgamma'], ['johnsonsb'], ['dgamma'], ['johnsonsb'], ['exponnorm']], [['exponnorm'], ['beta'], ['foldcauchy'], ['triang'], ['dweibull'], ['beta'], ['dweibull']], [['halfnorm'], ['halfgennorm'], ['betaprime'], ['dgamma'], ['dgamma'], ['dgamma'], ['gennorm']], [['johnsonsb'], ['dweibull'], ['dgamma'], ['rice'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['beta'], ['dgamma'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['chi'], ['triang'], ['dweibull'], ['exponpow'], ['beta'], ['invweibull']], [['cauchy'], ['powerlognorm'], ['dgamma'], ['beta'], ['beta'], ['exponpow'], ['cauchy']], [['chi'], ['pareto'], ['betaprime'], ['dgamma'], ['dgamma'], ['rdist'], ['genlogistic']], [['kstwobign'], ['powernorm'], ['betaprime'], ['gennorm'], ['dgamma'], ['dweibull'], ['dgamma']], [['nakagami'], ['exponnorm'], ['dweibull'], ['gennorm'], ['triang'], ['johnsonsb'], ['johnsonsb']], [['gennorm'], ['gennorm'], ['gennorm'], ['dweibull'], ['dweibull'], ['johnsonsb'], ['exponnorm']], [['gennorm'], ['johnsonsb'], ['dweibull'], ['powerlognorm'], ['tukeylambda'], ['genhalflogistic'], ['gumbel_r']], [['halfnorm'], ['powernorm'], ['betaprime'], ['dgamma'], ['tukeylambda'], ['johnsonsb'], ['dgamma']], [['halfnorm'], ['halfcauchy'], ['frechet_r'], ['dgamma'], ['tukeylambda'], ['johnsonsb'], ['burr']], [['gengamma'], ['halfgennorm'], ['betaprime'], ['gennorm'], ['gennorm'], ['dgamma'], ['invgamma']], [['beta'], ['halfgennorm'], ['betaprime'], ['dgamma'], ['dweibull'], ['dgamma'], ['dgamma']], [['chi'], ['pareto'], ['betaprime'], ['laplace'], ['burr12'], ['laplace'], ['pearson3']], [['chi2'], ['pareto'], ['betaprime'], ['burr'], ['genlogistic'], ['logistic'], ['expon']], [['pearson3'], ['pearson3'], ['betaprime'], ['loggamma'], ['pearson3'], ['hypsecant'], ['wald']], [['halfnorm'], ['pareto'], ['betaprime'], ['gennorm'], ['gennorm'], ['gennorm'], ['gennorm']], [['gilbrat'], ['powerlaw'], ['dweibull'], ['exponnorm'], ['gengamma'], ['genpareto'], ['triang']]]
    
    
Dataset = []
New_Dataset = []
    
    
for i in range ( 1, 55 ):
        s = "d"+str(i)+".csv"
        df = pd.read_csv( s )
        Dataset.append(df)
        n_bins = 7
    
length =[]
I=[]
for i in range( 1 , 7 ):
        New_Dataset,I =  evision( Distribution_statistics, Dataset ,i )   
        length.append(len(New_Dataset))
        
        
    
    
plt.bar( [ 1, 2, 3, 4, 5, 6 ], length )
    
    
     
plt.xlabel("Threshold")
plt.ylabel("Fraction of Datasets")    
        
        
plt.savefig('Fraction of Datasets_vs_Threshold.png')
    
    
    
    
    
