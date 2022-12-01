from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    username = None
    userID = models.IntegerField(primary_key=True, unique=True)
    email = models.EmailField(max_length=30, unique=True)
    password = models.CharField(max_length=255, blank=False, default="")
    first_name = models.CharField(max_length=30, blank=False)
    last_name = models.CharField(max_length=30, blank=False)
    userType = models.CharField(max_length=30, blank=False, default="StockVUser")
    
    USERNAME_FIELD = 'userID'
    REQUIRED_FIELDS = []

    def __str__(self):
        return str(self.userID)

class Coin(models.Model):
    name = models.CharField(max_length=30, blank=False)

class Wallet(models.Model):
    currency = models.FloatField(max_length=30, blank=False)

class StockVUser(User):
    appointments = models.ManyToManyField(Coin,blank=True) # check these relationships!
    prescriptions = models.ForeignKey(Wallet,blank=True, on_delete=models.CASCADE)


