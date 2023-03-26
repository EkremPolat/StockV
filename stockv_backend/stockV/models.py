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

class Transaction(models.Model):
    coin_name = models.CharField(max_length=30)
    amount = models.IntegerField(default=0)


class StockVUser(User):
    savedCoins = models.ManyToManyField(Coin, blank=True) # check these relationships!
    wallet = models.ManyToManyField(Transaction, blank=True)
