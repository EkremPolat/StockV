from .serializers import *
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.exceptions import AuthenticationFailed
from django.http import JsonResponse
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
        print(coin.name)


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
