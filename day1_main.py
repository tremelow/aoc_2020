# -*- coding: utf-8 -*-
"""
Created on Fri Dec  4 16:16:25 2020

@author: tremelow
"""

def search(arr, tgt, lo=0, hi=-1):
    hi = hi%len(arr)
    csr = (lo+hi)//2 # cursor
    
    while lo < hi:
        if arr[csr] < tgt:
            lo = csr+1
        elif arr[csr] > tgt:
            hi = csr-1
        else:
            lo, hi = csr, csr
        csr = (lo+hi)//2
    
    csr = (arr[csr] == tgt)*(csr + 1) - 1
    return csr


def crusher(arr, tgt):
    lo, hi = 1, len(arr)-1
    s = arr[lo] + arr[hi]
    searching = (s != tgt)
    while searching:
        lo += (s < tgt)
        hi -= (s > tgt)
        
        assert (lo < hi), "Target not found."
        
        s = arr[lo] + arr[hi]
        searching = (s != tgt)
        
    return lo, hi



def __main__():
    ##----------------------------------------
    ## READ DATA
    file = open("day1_input")
    # read data and convert it to a list of int
    data = [int(el) for el in file.read().split('\n')[:-1]]
    
    data.sort() # sort data, in O(n*log(n))


    ##-----------------------------------------
    ## DICHOTOMIC SEARCH -- O(n*log(n))
    for (i1, n1) in enumerate(data):
        i2 = search(data, 2020 - n1, lo=i1)
        if i2 != -1: # match found!
            n2 = data[i2]
            print("Method 1:", n1, "*", n2, "=", n1*n2)
            break

    ##-----------------------------------------
    ## "CRUSHING WALLS" SEARCH -- O(n)
    i1, i2 = crusher(data, 2020)
    print("Method 2:", data[i1], "*", data[i2], "=", data[i1]*data[i2])
    
    
    ##-----------------------------------------
    ## BONUS: find three elements -- O(n^2 log(n))
    for (i1, n1) in enumerate(data):
        for i2 in range(len(data)-1, i1, -1):
            n2 = data[i2]
            i3 = search(data, 2020 - n1 - n2, lo=i1, hi=i2)
            if i3 != -1:
                n3 = data[i3]
                print("Bonus:", n1, "*", n2, "*", n3, "=", n1*n2*n3)
                break
    
    ##-----------------------------------------

__main__()