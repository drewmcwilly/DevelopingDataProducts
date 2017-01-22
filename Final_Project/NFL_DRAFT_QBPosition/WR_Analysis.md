Wide Receiver Draft Analysis
========================================================
author: Drew McWilliams
date: 1/22/2017
autosize: true

NFL Draft
========================================================

This Presenation was assembled as part of the final project in Coursera's Developing Data Products class.  

By using NFL Combine stats from 1999 through 2014 along with the draft results, this application aims to predict the round that a Wide Receiver would be selected.




The project used the data set located here: http://nflsavant.com/dump/combine.csv?year=2015.

Data Set Overview
========================================================

Below should give a general overview.  The most consistently populated columns that had an impact on the draft round were:
height, weight, fortyyd, vertical, broad, arms, hands, and college


```
      year                 name       firstname       lastname  
 Min.   :1999   Ben Obomanu  :  2   David  :  8   Johnson : 11  
 1st Qu.:2003   Mike Williams:  2   Mike   :  8   Williams: 10  
 Median :2007   Steve Smith  :  2   Chris  :  7   Robinson:  7  
 Mean   :2007   A.J. Green   :  1   Brandon:  6   Jones   :  6  
 3rd Qu.:2011   A.J. Jenkins :  1   Andre  :  5   Brown   :  5  
 Max.   :2014   Aaron Lockett:  1   Kevin  :  5   Jackson :  5  
                (Other)      :388   (Other):358   (Other) :353  
    position   heightfeet  heightinches heightinchestotal     weight     
 WR     :397       :  0   1.0000 :108   Min.   :65.00     Min.   :155.0  
        :  0    Jr.:  0   2.0000 : 67   1st Qu.:71.00     1st Qu.:191.0  
 C      :  0   5   :124   11.0000: 54   Median :73.00     Median :200.0  
 CB     :  0   6   :273   3.0000 : 41   Mean   :72.78     Mean   :200.6  
 DE     :  0              10.0000: 33   3rd Qu.:74.00     3rd Qu.:211.0  
 DT     :  0              9.0000 : 22   Max.   :78.00     Max.   :247.0  
 (Other):  0              (Other): 72                                    
      arms           hands           fortyyd         twentyyd     
 Min.   : 0.00   Min.   : 0.000   Min.   :0.000   Min.   :0.0000  
 1st Qu.: 0.00   1st Qu.: 0.000   1st Qu.:4.420   1st Qu.:0.0000  
 Median : 0.00   Median : 0.000   Median :4.480   Median :0.0000  
 Mean   :12.76   Mean   : 3.760   Mean   :4.462   Mean   :0.6197  
 3rd Qu.:31.50   3rd Qu.: 9.125   3rd Qu.:4.550   3rd Qu.:0.0000  
 Max.   :35.88   Max.   :10.750   Max.   :4.790   Max.   :2.7700  
                                                                  
     tenyd           twentyss       threecone        vertical   
 Min.   :0.0000   Min.   :0.000   Min.   :0.000   Min.   : 0.0  
 1st Qu.:0.0000   1st Qu.:3.860   1st Qu.:0.000   1st Qu.:33.5  
 Median :0.0000   Median :4.140   Median :0.000   Median :35.5  
 Mean   :0.4853   Mean   :3.191   Mean   :2.939   Mean   :33.5  
 3rd Qu.:1.5000   3rd Qu.:4.250   3rd Qu.:6.840   3rd Qu.:37.5  
 Max.   :1.6900   Max.   :4.770   Max.   :7.390   Max.   :45.0  
                                                                
     broad           bench            round                college   
 Min.   :  0.0   Min.   : 0.000   Min.   :1.000   Florida      : 12  
 1st Qu.:115.0   1st Qu.: 0.000   1st Qu.:2.000   Miami (FL)   : 10  
 Median :120.0   Median : 0.000   Median :4.000   USC          : 10  
 Mean   :105.3   Mean   : 6.207   Mean   :4.035   LSU          :  9  
 3rd Qu.:124.0   3rd Qu.:14.000   3rd Qu.:6.000   Ohio State   :  9  
 Max.   :139.0   Max.   :27.000   Max.   :8.000   Florida State:  8  
                                                  (Other)      :339  
      pick       pickround     picktotal       wonderlic      
 0      : 32   27     : 16   Min.   :  2.0   Min.   : 0.0000  
 14(78) :  4   17     : 15   1st Qu.: 60.0   1st Qu.: 0.0000  
 18(82) :  4   7      : 15   Median :114.0   Median : 0.0000  
 8(8)   :  4   12     : 14   Mean   :119.9   Mean   : 0.2746  
 12(44) :  3   10     : 13   3rd Qu.:178.0   3rd Qu.: 0.0000  
 13(13) :  3   14     : 13   Max.   :262.0   Max.   :25.0000  
 (Other):347   (Other):311                                    
    nflgrade     
 Min.   :0.0000  
 1st Qu.:0.0000  
 Median :0.0000  
 Mean   :0.4403  
 3rd Qu.:0.0000  
 Max.   :7.0000  
                 
```

Slide With Plot
========================================================



```
Error in eval(expr, envir, enclos) : could not find function "group_by"
```
