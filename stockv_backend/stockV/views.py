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
        serializer = StockVUser(data=request.data)
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

        payload = {
            'email' : user.email,
            'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes=60),
            'iat' : datetime.datetime.utcnow(),
        }

        token = jwt.encode(payload, 'secret', algorithm='HS256')

        response = Response()

        response.set_cookie(key='jwt', value=token, httponly=True, samesite="None", secure=True)
        
        response.data = {
            'jwt': token,
            'email' : user.email,
            'full_name' : user.full_name
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

class UpdateCoinView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Coin.objects.all()
    serializer_class = CoinSerializer

