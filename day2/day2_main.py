# -*- coding: utf-8 -*-
"""
Created on Sat Dec  5 13:17:27 2020

@author: tremelow
"""

import re


def __main__():
    sep = re.compile(r'\W+')
    file = open("day2_input","r")
    
    data = [sep.split(line) for line in file.read().split('\n')[:-1]]
    
    ##----------------------------
    ## ORIGINAL PROBLEM
    nb_ok = 0
    for el in data:
        lo, hi, char, pswd = int(el[0]), int(el[1]), el[2], el[3]
        occ = pswd.count(char)
        nb_ok += ((occ >= lo) and (occ <= hi))
    
    print(nb_ok)
    
    ##---------------------------
    ## BONUS
    nb_ok = 0
    for el in data:
        pos1, pos2, char, pswd = int(el[0]), int(el[1]), el[2], el[3]
        nb_ok += ((pswd[pos1-1] == char) ^ (pswd[pos2-1] == char))
    print(nb_ok)
    
__main__()