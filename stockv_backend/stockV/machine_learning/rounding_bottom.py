from mplfinance.original_flavor import candlestick_ohlc
from scipy.signal import argrelextrema

import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')  
import numpy as np
import pandas as pd
import io
import base64

def find_rounding_bottom_points(ohlc, back_candles):
    all_points = []
    for candle_idx in range(back_candles+10, len(ohlc)):

        maxim = np.array([])
        minim = np.array([])
        xxmin = np.array([])
        xxmax = np.array([])

        for i in range(candle_idx-back_candles, candle_idx+1):
            if ohlc.loc[i,"Pivot"] == 1:
                minim = np.append(minim, ohlc.loc[i, "Close"])
                xxmin = np.append(xxmin, i) 
            if ohlc.loc[i,"Pivot"] == 2:
                maxim = np.append(maxim, ohlc.loc[i,"Close"])
                xxmax = np.append(xxmax, i)

        
        if (xxmax.size <3 and xxmin.size <3) or xxmax.size==0 or xxmin.size==0:
            continue

        # Fit a nonlinear line: ax^2 + bx + c        
        z = np.polyfit(xxmin, minim, 2)

        # Check if the first and second derivatives are for a parabolic function
        if 2*xxmin[0]*z[0] + z[1]*xxmin[0] < 0 and 2*z[0] > 0:
             if z[0] >=2.19388889e-04 and z[1]<=-3.52871667e-02:          
                    all_points.append(candle_idx)
                                    

    return all_points


def save_plot(ohlc, all_points, back_candles):
    total = len(all_points)
    plots = []
    plt.style.use('seaborn-darkgrid')
    for j, point in enumerate(all_points):
        candleid = point

        maxim = np.array([])
        minim = np.array([])
        xxmin = np.array([])
        xxmax = np.array([])

        for i in range(point-back_candles, point+1):
            if ohlc.loc[i,"Pivot"] == 1:
                minim = np.append(minim, ohlc.loc[i, "Close"])
                xxmin = np.append(xxmin, i) 
            if ohlc.loc[i,"Pivot"] == 2:
                maxim = np.append(maxim, ohlc.loc[i,"Close"])
                xxmax = np.append(xxmax, i)
                

        z = np.polyfit(xxmin, minim, 2)
        f = np.poly1d(z)
        
        ohlc_subset = ohlc[point-back_candles-10:point+back_candles+10]
        
        xxmin = np.insert(xxmin,0,xxmin[0]-3)    
        xxmin = np.append(xxmin, xxmin[-1]+3)
        minim_new = f(xxmin)
      
        ohlc_subset_copy = ohlc_subset.copy()
        ohlc_subset_copy.loc[:,"Index"] = ohlc_subset_copy.index

        fig, ax = plt.subplots(figsize=(15,7))

        candlestick_ohlc(ax, ohlc_subset_copy.loc[:, ["Index","Open", "High", "Low", "Close"] ].values, width=0.6, colorup='green', colordown='red', alpha=0.8)
        ax.plot(xxmin, minim_new)

        ax.grid(True)
        ax.set_xlabel('Index')
        ax.set_ylabel('Price')
        buffer = io.BytesIO()
        plt.savefig(buffer, format='png', bbox_inches='tight')
        buffer.seek(0)

        # Convert the plot image to a base64-encoded string
        image_base64 = base64.b64encode(buffer.getvalue()).decode('utf-8')

        # Append the base64-encoded image to the list of plots
        plots.append(image_base64)
        plt.close()

    return plots

def send_rounding_bottom_plots(df):
    ohlc = df.loc[:, ["Date", "Open", "High", "Low", "Close"] ]
    ohlc["Pivot"] = 0

    # Get the minimas and maximas 
    local_max = argrelextrema(ohlc["Close"].values, np.greater)[0]
    local_min = argrelextrema(ohlc["Close"].values, np.less)[0]   

    for m in local_max:
        ohlc.loc[m, "Pivot"] = 2
        
    for m in local_min:
        ohlc.loc[m, "Pivot"] = 1

    # Find all the rounding bottom points
    back_candles = 5
    all_points = find_rounding_bottom_points(ohlc, back_candles)

    # Save all the plots
    return save_plot(ohlc, all_points,back_candles)

if __name__ == "__main__":
    df = pd.read_csv("stockV/machine_learning/eurusd-4h.csv")

    ohlc = df.loc[:, ["Date", "Open", "High", "Low", "Close"] ]
    ohlc["Pivot"] = 0

    # Get the minimas and maximas 
    local_max = argrelextrema(ohlc["Close"].values, np.greater)[0]
    local_min = argrelextrema(ohlc["Close"].values, np.less)[0]   

    # Set max points to `2` 
    for m in local_max:
        ohlc.loc[m, "Pivot"] = 2
        
    # Set min points to `1`
    for m in local_min:
        ohlc.loc[m, "Pivot"] = 1

    # Find all the rounding bottom points
    back_candles = 5
    all_points = find_rounding_bottom_points(ohlc, back_candles)
    # Save all the plots
    save_plot(ohlc, all_points,back_candles)