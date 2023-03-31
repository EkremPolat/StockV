"""stockv_backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from stockV.views import *

urlpatterns = [
    path('admin/', admin.site.urls),
    path('signup/', AddUser.as_view(), name='signup'),
    path('login/', LoginView.as_view(), name='login'),
    path('password-change/', Password_change_view.as_view(), name='password-change'),
    path('verify-password/', PasswordVerificationView.as_view(), name='verify-password'),
    path('coins/', CoinListView.as_view(), name='coins'),
    path('saved-coins/<str:pk>/', GetSavedCoinListView.as_view(), name='saved-coins'),
    path('add-saved-coin/', AddSavedCoinView.as_view(), name='add-saved-coin'),
    path('remove-saved-coin/', RemoveSavedCoinView.as_view(), name='remove-saved-coin'),
    path('get-wallet/<str:pk>/', GetWalletListView.as_view(), name='get-wallet'),
    path('buy-crypto/', BuyCryptoView.as_view(), name='buy-crypto'),
    path('has-crypto/', HasCryptoView.as_view(), name='has-crypto'),
    path('sell-crypto', SellCryptoView.as_view(), name='sell-crypto'),
]
