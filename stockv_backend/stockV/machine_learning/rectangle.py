from mplfinance.original_flavor import candlestick_ohlc

import matplotlib.dates as mpdates
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
import numpy as np
import pandas as pd
from progress.bar import Bar
from scipy.stats import linregress
from scipy.signal import argrelextrema
from typing import List, Union
import io
import base64

def pivot_id(ohlc, l, n1, n2):
    """
    Get the pivot id 
    :params ohlc is a dataframe
    :params l is the l'th row
    :params n1 is the number of candles to the left
    :params n2 is the number of candles to the right
    :return int  
    """

    # Check if the length conditions met
    if l-n1 < 0 or l+n2 >= len(ohlc):
        return 0
    
    pivot_low  = 1
    pivot_high = 1

    for i in range(l-n1, l+n2+1):
        if(ohlc.loc[l,"Low"] > ohlc.loc[i, "Low"]):
            pivot_low = 0

        if(ohlc.loc[l, "High"] < ohlc.loc[i, "High"]):
            pivot_high = 0

    if pivot_low and pivot_high:
        return 3

    elif pivot_low:
        return 1

    elif pivot_high:
        return 2
    else:
        return 0


def pivot_point_position(row):
    """
    Get the Pivot Point position and assign the Low or High value
    :params row -> row of the ohlc dataframe
    :return float
    """
   
    if row['Pivot']==1:
        return row['Low']-1e-3
    elif row['Pivot']==2:
        return row['High']+1e-3
    else:
        return np.nan


def find_rectangle_points(ohlc: pd.DataFrame, backcandles: int) -> List[int]:
    """
    Find the trianle points based on the pivot points
    :params ohlc -> dataframe that has OHLC data
    :type :pd.DataFrame
    :params backcandles -> number of periods to lookback
    :type :int
    :returns triangle points
    """
    all_rectangle_points = []

    for candleid in range(backcandles+10, len(ohlc)):
        
        maxim = np.array([])
        minim = np.array([])
        xxmin = np.array([])
        xxmax = np.array([])

        for i in range(candleid-backcandles, candleid+1):
            if ohlc.loc[i,"Pivot"] == 1:
                minim = np.append(minim, ohlc.loc[i, "Low"])
                xxmin = np.append(xxmin, i) 
            if ohlc.loc[i,"Pivot"] == 2:
                maxim = np.append(maxim, ohlc.loc[i,"High"])
                xxmax = np.append(xxmax, i)

       
        if (xxmax.size <3 and xxmin.size <3) or xxmax.size==0 or xxmin.size==0:
               continue

        slmin, intercmin, rmin, pmin, semin = linregress(xxmin, minim)
        slmax, intercmax, rmax, pmax, semax = linregress(xxmax, maxim)

        if abs(rmax)>=0.8 and abs(rmin)>=0.8 and (abs(slmin/slmax)>=0.85 and abs(slmin/slmax)<=1.05) \
            and (slmin>=-0.001 and slmin <= 0.001) and (slmax>=-0.001 and slmax <= 0.001): #  
            all_rectangle_points.append(candleid)

    return all_rectangle_points


def save_plot(ohlc: pd.DataFrame, all_rectangle_points: List[int], backcandles: int) -> None:
    """
    Save all the triangle patterns graphs
    :params ohlc -> dataframe that has OHLC data
    :type :pd.DataFrame 
    :params all_rectangle_points -> list that has all index points that have rectangle points
    :type :List[int]
    
    :params backcandles -> number of periods to lookback
    :type :int
    
    :return None  
    """
    total = len(all_rectangle_points)
    plt.style.use('seaborn-darkgrid')
    bar  = Bar("Plotting the pattern", max=total)
    plots = []
    for j, rectangle_point in enumerate(all_rectangle_points):
        candleid = rectangle_point
        
        maxim = np.array([])
        minim = np.array([])
        xxmin = np.array([])
        xxmax = np.array([])

        for i in range(candleid-backcandles, candleid+1):
            if ohlc.loc[i,"Pivot"] == 1:
                minim = np.append(minim, ohlc.loc[i, "Low"])
                xxmin = np.append(xxmin, int(i)) 
            if ohlc.loc[i,"Pivot"] == 2:
                maxim = np.append(maxim, ohlc.loc[i,"High"])
                xxmax = np.append(xxmax, int(i))
                

        slmin, intercmin, rmin, pmin, semin = linregress(xxmin, minim)
        slmax, intercmax, rmax, pmax, semax = linregress(xxmax, maxim)

        ohlc_subset = ohlc[candleid-backcandles-10:candleid+backcandles+10]
        ohlc_subset_copy = ohlc_subset.copy()
        ohlc_subset_copy.loc[:,"Index"] = ohlc_subset_copy.index
    
        xxmin = np.append(xxmin, xxmin[-1]+15)
        xxmax = np.append(xxmax, xxmax[-1]+15)
    
        # Move the y-axis to the right hand side. 
        plt.rcParams['ytick.right'] = plt.rcParams['ytick.labelright'] = True
        plt.rcParams['ytick.left'] = plt.rcParams['ytick.labelleft'] = False

        fig, ax = plt.subplots(figsize=(15,7), facecolor='#000000')

        candlestick_ohlc(ax, ohlc_subset_copy.loc[:, ["Index","Open", "High", "Low", "Close"] ].values, width=0.6, colorup='green', colordown='red', alpha=0.8)

        # Draw the triangle lines.
        ax.plot(xxmin, xxmin*slmin + intercmin, linewidth=12, color="purple", alpha=0.85)
        ax.plot(xxmax, xxmax*slmax + intercmax, linewidth=12, color="purple", alpha=0.85)

        # Color the ticks white
        ax.tick_params(axis='x', colors='white')
        ax.tick_params(axis='y', colors='white')

        ax.set_facecolor('#000000')
        ax.grid(False)

        buffer = io.BytesIO()
        plt.savefig(buffer, format='png', bbox_inches='tight')
        buffer.seek(0)

        # Convert the plot image to a base64-encoded string
        image_base64 = base64.b64encode(buffer.getvalue()).decode('utf-8')

        # Append the base64-encoded image to the list of plots
        plots.append(image_base64)
        plt.close()
        bar.next()

    bar.finish()

    return plots


def send_rectangle_plots(df):
    ohlc         = df.loc[:, ["Date", "Open", "High", "Low", "Close"] ]

    ohlc["Pivot"]    = ohlc.apply(lambda x: pivot_id(ohlc, x.name, 3, 3), axis=1)
    ohlc['PointPos'] = ohlc.apply(lambda row: pivot_point_position(row), axis=1)

    # Identify the triangle patterns
    backcandles         = 20
    all_rectangle_points = find_rectangle_points(ohlc, backcandles)

    return save_plot(ohlc, all_rectangle_points, backcandles)

if __name__ == "__main__":
    df = pd.read_csv("stockV/machine_learning/eurusd-4h.csv")

    # Remove all non-trading periods
    df   = df[df['Volume']!=0]
    df.reset_index(drop=True, inplace=True)

    ohlc         = df.loc[:, ["Date", "Open", "High", "Low", "Close"] ]

    ohlc["Pivot"]    = ohlc.apply(lambda x: pivot_id(ohlc, x.name, 3, 3), axis=1)
    ohlc['PointPos'] = ohlc.apply(lambda row: pivot_point_position(row), axis=1)

    # Identify the triangle patterns
    backcandles         = 20
    all_rectangle_points = find_rectangle_points(ohlc, backcandles)

    save_plot(ohlc, all_rectangle_points, backcandles)