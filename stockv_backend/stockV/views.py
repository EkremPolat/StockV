from .serializers import *
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.exceptions import AuthenticationFailed
from django.http import JsonResponse
from django.http import HttpResponse
import pandas as pd
from stockV.machine_learning.rectangle import send_rectangle_plots
from stockV.machine_learning.head_and_shoulders import send_head_and_shoulder_plots
from stockV.machine_learning.triples import send_triple_plots
from stockV.machine_learning.wedge import send_wedge_plots
from stockV.machine_learning.triangle import send_triangle_plots
from stockV.machine_learning.support_and_resistance import send_support_and_resistance_plots
from stockV.machine_learning.rounding_bottom import send_rounding_bottom_plots
from stockV.machine_learning.flag import send_flag_plots
from stockV.machine_learning.doubles import send_double_plots
import datetime
import requests

class AddUser(APIView):
    def post(self, request):
        serializer = StockVUserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)


class LoginView(APIView):
    def post(self, request):
        email = request.data['email']
        password = request.data['password']

        user = User.objects.filter(email=email).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")
            
        if not user.check_password(password):
            raise AuthenticationFailed("Password is incorrect!")

        response = Response()
        
        response.data = {
            'email' : user.email,
            'full_name' : user.full_name,
            'id' : user.id
        }

        return response


class Password_change_view(APIView):
    def patch(self, request):
        email = request.data['email']
        user = User.objects.filter(email=email).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")

        user_serializer = UserSerializer(user, data=request.data)
        user_serializer.is_valid(raise_exception=True)
        user_serializer.save()
        return Response(request.data)

class PasswordVerificationView(APIView):
    def post(self, request):
        email = request.data['email']
        password = request.data['password']

        user = User.objects.filter(email=email).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")
            
        if not user.check_password(password):
            raise AuthenticationFailed("Password is incorrect!")

        response = Response()
        
        response.data = {
            'success': True
        }

        return response
    
class CoinListView(generics.ListCreateAPIView): # This function provides receiving the list of coins and create new coins
    queryset = Coin.objects.all()
    serializer_class = CoinSerializer

class GetSavedCoinListView(APIView):
    def get(self, request, pk):
        user = StockVUser.objects.filter(id=pk).first()
        if user is None:
            raise AuthenticationFailed("User is not found!")
        
        savedCoins = user.savedCoins.all()
        coins = Coin.objects.filter(id__in=[coin.id for coin in savedCoins])
        coin_list = [{'name': coin.name, 'symbol': coin.symbol, 'price': coin.price, 'id': coin.id, 'dailyChange' : coin.dailyChange} for coin in coins]
        return JsonResponse(coin_list, safe=False)

class AddSavedCoinView(APIView):
    def post(self, request):
        userId = request.data['userId']
        coinId = request.data['coinId']
        user = StockVUser.objects.filter(id=userId).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")
        
        coin = Coin.objects.filter(id=coinId).first()

        if coin is None:
            raise AuthenticationFailed("Coin is not found!")
        
        user.savedCoins.add(coin)

        coins = Coin.objects.filter(id__in=[coin.id for coin in user.savedCoins.all()])

        coin_list = [{'name': coin.name, 'symbol': coin.symbol, 'price': coin.price, 'id': coin.id, 'dailyChange' : coin.dailyChange} for coin in coins]
        return JsonResponse(coin_list, safe=False)

class RemoveSavedCoinView(APIView):
    def post(self, request):
        userId = request.data['userId']
        coinId = request.data['coinId']
        user = StockVUser.objects.filter(id=userId).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")
        
        coin = Coin.objects.filter(id=coinId).first()

        if coin is None:
            raise AuthenticationFailed("Coin is not found!")
        
        user.savedCoins.remove(coin)
        
        coins = Coin.objects.filter(id__in=[coin.id for coin in user.savedCoins.all()])

        coin_list = [{'name': coin.name, 'symbol': coin.symbol, 'price': coin.price, 'id': coin.id, 'dailyChange' : coin.dailyChange} for coin in coins]
        return JsonResponse(coin_list, safe=False)
    
class GetWalletListView(APIView):
    def get(self, request, pk):
        user = StockVUser.objects.filter(id=pk).first()
        if user is None:
            raise AuthenticationFailed("User is not found!")
        ownedCoins = user.wallet.all()
        wallet_list = [{'coinName': ownedCoin.coin_name, 'coinSymbol': Coin.objects.filter(name=ownedCoin.coin_name).first().symbol , 'amount': ownedCoin.amount, 'usdValue': Coin.objects.filter(name=ownedCoin.coin_name).first().price} for ownedCoin in ownedCoins]
        return JsonResponse(wallet_list, safe=False)

class GetTransactionHistoryView(APIView):
    def get(self, request, pk):
        user = StockVUser.objects.filter(id=pk).first()
        if user is None:
            raise AuthenticationFailed("User is not found!")
        userTransactions = Transaction.objects.filter(user=user)
        transaction_list = [{'date': transaction.date.strftime("%Y-%m-%d %H:%M"), 'coinName': transaction.coinName, 'coinPrice': transaction.coinPrice, 'coinAmount': transaction.coinAmount, 'isSelling' : transaction.isSelling} for transaction in userTransactions]
        return JsonResponse(transaction_list, safe=False)

class GetUserBalanceView(APIView):
    def get(self, request, pk):
        user = StockVUser.objects.filter(id=pk).first()
        if user is None:
            raise AuthenticationFailed("User is not found!")
        userBalance = user.balance
        
        response = Response()
        response.data = {
            'balance': userBalance
        }
        return response

class BuyCryptoView(APIView):
    def post(self, request):
        user_id = request.data['userId']
        coin_name = request.data['coinName']
        amount = request.data['amount']
        cost = request.data['cost']

        coin_price = cost / amount

        user = StockVUser.objects.filter(id=user_id).first()

        if user is None:
            raise AuthenticationFailed("User is not found!")
        
        # Decrease the balance of the user 
        user.balance -= cost
        user.save()

        response = Response()  
        response.data = {
            'balance': user.balance
        }

        # Check if the user already has some of that crypto
        ownedCoin = user.wallet.all().filter(coin_name=coin_name).first()

        if ownedCoin:
            # If the user already has some of that crypto, add the amount from the request to the actual amount on the database row
            ownedCoin.amount += amount
            ownedCoin.save()
        else:
            # If the user have not previously purchased that crypto, add the coin to user and set the amount to the amount from the request
            ownedCoin = OwnedCoins.objects.create(coin_name=coin_name, amount=amount)
            user.wallet.add(ownedCoin)

        transaction = Transaction.objects.create(coinName=ownedCoin.coin_name, coinPrice=coin_price, coinAmount=amount, isSelling=False, user=user)
        transaction.save()
        return response
    
class HasCryptoView(APIView):
    def post(self, request):
        user_id = request.data['userId']
        coin_name = request.data['coinName']
        user = StockVUser.objects.filter(id=user_id).first()
        ownedCoin = user.wallet.all().filter(coin_name=coin_name).first()

        if ownedCoin:
            return JsonResponse({'hasCrypto': True, 'amount': ownedCoin.amount})
        else:
            return JsonResponse({'hasCrypto': False, 'amount': 0.0})

class SellCryptoView(APIView):
    def post(self, request):
        user_id = request.data['userId']
        coin_name = request.data['coinName']
        amount = request.data['amount']
        totalEarnings = request.data['totalEarnings']

        coin_price = totalEarnings / amount

        user = StockVUser.objects.filter(id=user_id).first()

        user.balance += totalEarnings
        user.save()

        response = Response()  
        response.data = {
            'balance': user.balance
        }

        ownedCoin = user.wallet.all().filter(coin_name=coin_name).first()
        if (amount > ownedCoin.amount):
            return HttpResponse('The desired amount is higher than than the owned amount. Selling process failed.')
        else:
            transaction = Transaction.objects.create(coinName=ownedCoin.coin_name, coinPrice=coin_price, coinAmount=amount, isSelling=True, user=user)
            transaction.save()
            ownedCoin.amount -= amount
            if(ownedCoin.amount == 0):
                ownedCoin.delete()
            ownedCoin.save()
            return response


class GenerateChartPatterns(APIView):
    def post(self, request):
        symbol = request.data['symbol']
        intervalValue = request.data['intervalValue']
        intervalCode = request.data['intervalCode']
        startTime = request.data['startTime']
        endTime = request.data['endTime']
        chartType = request.data['chartType']

        
        url = 'https://api.binance.com/api/v3/klines?symbol=' + symbol + 'USDT&interval=' + str(intervalValue) + str(intervalCode) + '&startTime=' + str(startTime) + '&endTime=' + str(endTime)
        response = requests.get(url)
        if response.status_code == 200:

            data = response.json()
            # Extract open, high, low, and close values as separate lists
            dates = [datetime.datetime.fromtimestamp(entry[0] / 1000).strftime("%Y-%m-%d %H:%M:%S") for entry in data]
            opens = [float(candle[1]) for candle in data]
            highs = [float(candle[2]) for candle in data]
            lows = [float(candle[3]) for candle in data]
            closes = [float(candle[4]) for candle in data]
            df = pd.DataFrame({'Date': dates, 'Open': opens, 'High': highs, 'Low': lows, 'Close': closes})
            
            #df   = pd.read_csv("stockV/machine_learning/eurusd-4h.csv")

            if chartType == "Rectangle":
                plots = send_rectangle_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Head and Shoulders":
                plots = send_head_and_shoulder_plots(df)

                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Triples":
                plots = send_triple_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Wedge":
                plots = send_wedge_plots(df)

                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Triangle":
                plots = send_triangle_plots(df)
    
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)
            
            elif chartType == "Support and Resistance":
                plots = send_support_and_resistance_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Rounding Bottom":
                plots = send_rounding_bottom_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            elif chartType == "Flag":
                plots = send_flag_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)
            
            elif chartType == "Double":
                plots = send_double_plots(df)
                
                # Return the plots array as a JSON response
                return JsonResponse(plots, safe=False)

            else:
                print("Name: " + chartType)
                plots = []

                return JsonResponse(plots, safe=False)
        
        else:
            print(response)
            plots = []

            return JsonResponse(plots, safe=False)
        
