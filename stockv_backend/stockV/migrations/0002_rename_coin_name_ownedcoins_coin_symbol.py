# Generated by Django 4.1.7 on 2023-03-31 23:10

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stockV', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='ownedcoins',
            old_name='coin_name',
            new_name='coin_symbol',
        ),
    ]