from .serializers import *
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.exceptions import AuthenticationFailed
from django.http import JsonResponse
from django.http import HttpResponse
import datetime
import jwt


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

        user_serializer = UserUpdate(user, data=request.data)
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
        wallet_list = [{'coinName': ownedCoin.coin_name, 'coinSymbol': Coin.objects.filter(name=ownedCoin.coin_name).first().symbol , 'amount': ownedCoin.amount, 'usdValue': Coin.objects.filter(name=ownedCoin.coin_name).first().price, 'dailyChange': Coin.objects.filter(name=ownedCoin.coin_name).first().dailyChange} for ownedCoin in ownedCoins]
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
