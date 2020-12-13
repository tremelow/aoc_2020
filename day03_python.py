# -*- coding: utf-8 -*-
"""
Created on Sat Dec  5 13:41:41 2020

@author: tremelow
"""
from functools import reduce


def __main__():
    file = open("day03_input","r")
    
    data = [line for line in file.read().split('\n')[:-1]]
    tree = "#"
    
    direction = (1,3)
    
    i,j = 0, 0
    nb_trees = 0
    while True:
        i += direction[0]
        if not i < len(data):
            break
        
        j = (j+direction[1])%len(data[i])
        
        nb_trees += (data[i][j] == tree)
    print(nb_trees)
    
    directions = [(1,1), (1,3), (1,5), (1,7), (2,1)]
    nb_trees = [0 for _ in directions]
    for (n,d) in enumerate(directions):
        i,j = 0, 0
        while True:
            i += d[0]
            if not i < len(data):
                break
            j = (j+d[1])%len(data[i])
            nb_trees[n] += (data[i][j] == tree)
            
    print(nb_trees)
    # print(reduce(lambda x,y: x*y, nb_trees, 1))


__main__()