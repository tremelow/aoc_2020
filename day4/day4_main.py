# -*- coding: utf-8 -*-
"""
Created on Sat Dec  5 15:41:06 2020

@author: tremelow
"""
import re

def __main__():
    file = open("day4_input","r")
    # data is separated by 1 blank line
    data = file.read().split('\n\n')
    
    
    ##----------------------------------------
    ## ORIGINAL PROBLEM
    
    fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] # "cid" ignored
    fields.sort()
    # find all 3-letter words followed by ":" except "cid"
    p = re.compile(r"(?!cid)\w{3}(?=:)+") 
    nb_ok = 0
    for el in data:
        t = sorted(p.findall(el))
        if t == fields:
            nb_ok += 1
            
    print(nb_ok)
    
    
    ##----------------------------------------
    ## BONUS PROBLEM
    opn, end = r"(?:^|\W)", r"(?:\W|$)"
    
    byr = re.compile(opn+r"byr:(?:19[2-9]\d|200[0-2])"+end)
    iyr = re.compile(opn+r"iyr:20(?:1\d|20)"+end)
    eyr = re.compile(opn+r"eyr:20(?:2\d|30)"+end)
    hgt = re.compile(opn+r"hgt:(?:1(?:[5-8]\d|9[0-3])cm|(?:59|6\d|7[0-6])in)"+end)
    hcl = re.compile(opn+r"hcl:#[0-9a-f]{6}"+end)
    ecl = re.compile(opn+r"ecl:(?:amb|blu|brn|gry|grn|hzl|oth)"+end)
    pid = re.compile(opn+r"pid:\d{9}"+end)
    
    params = [byr, iyr, eyr, hgt, hcl, ecl, pid]
    nb_ok = 0
    for el in data:
        matching = 1
        for charac in params:
            # modify matching if there are 0 or >1 matches
            matching *= sum(1 for _ in charac.finditer(el)) 
        if matching == 1:
            nb_ok += 1
        
    
    print(nb_ok)
    
__main__()