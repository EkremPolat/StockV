# Generated by Django 4.1.3 on 2022-12-13 19:39

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stockV', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='first_name',
        ),
        migrations.RemoveField(
            model_name='user',
            name='last_name',
        ),
    ]
