from django.db import models
from django.contrib.auth.models import AbstractUser
import uuid

class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = None
    first_name = None
    last_name = None
    is_staff = None
    is_active = None
    email = models.EmailField(max_length=30, unique=True)
    password = models.CharField(max_length=255, blank=False, default="")
    full_name = models.CharField(max_length=50, blank=False)
    userType = models.CharField(max_length=30, blank=False, default="StockVUser")
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __str__(self):
        return str(self.email)

class Coin(models.Model):   
    name = models.CharField(max_length=30, blank=False)
    price = models.FloatField(max_length=30, blank=False, default=0)
    dailyChange = models.FloatField(max_length=8, blank=False, default=0)
    symbol = models.CharField(max_length=10, blank=False)

class OwnedCoins(models.Model):
    coin_name = models.CharField(max_length=30)
    amount = models.FloatField(default=0)

class StockVUser(User):
    savedCoins = models.ManyToManyField(Coin, blank=True)
    balance = models.FloatField(default=1000)
    wallet = models.ManyToManyField(OwnedCoins, blank=True)

class Transaction(models.Model):
    date = models.DateTimeField(auto_now=True)
    coinName = models.CharField(max_length=30)
    coinPrice = models.FloatField()
    coinAmount = models.FloatField()
    isSelling = models.BooleanField()
    user = models.ForeignKey(StockVUser, on_delete=models.CASCADE)