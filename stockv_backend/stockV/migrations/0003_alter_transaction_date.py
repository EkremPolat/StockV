# Generated by Django 4.1.7 on 2023-03-31 23:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stockV', '0002_rename_coin_name_ownedcoins_coin_symbol'),
    ]

    operations = [
        migrations.AlterField(
            model_name='transaction',
            name='date',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
