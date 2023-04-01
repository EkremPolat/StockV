import requests
from .serializers import *
import time
from django.core.management.base import BaseCommand
from threading import Thread

def start_thread():
    while True:
        updateAllCoinViews()

def updateAllCoinViews():
    coinList = Coin.objects.all()
    for coin in coinList:
        coinSymbol = coin.symbol
        priceDailyUpdateURL = "https://api.binance.com/api/v1/ticker/24hr?symbol=" + coinSymbol + "USDT"
        priceDailyUpdateResponse = requests.get(priceDailyUpdateURL)
        if priceDailyUpdateResponse.status_code == 200:
            data = priceDailyUpdateResponse.json()
            dailyPriceChange = data["priceChangePercent"]
            coin.dailyChange = dailyPriceChange
                        
            priceUpdateURL = "https://api.binance.com/api/v3/ticker/price?symbol=" + coinSymbol + "USDT"
            priceUpdateResponse = requests.get(priceUpdateURL)

            if priceUpdateResponse.status_code == 200:
                data = priceUpdateResponse.json()
                price = data['price']
                coin.price = price
                        
        coin.save()

class Command(BaseCommand):
    help = 'Starts a thread that fetches coin info every second'

    def handle(self, *args, **options):
        thread = Thread(target=start_thread)
        thread.daemon = True
        thread.start()
            
            