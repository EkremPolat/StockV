# Generated by Django 4.1.3 on 2022-12-13 19:41

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stockV', '0002_remove_user_first_name_remove_user_last_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='is_active',
        ),
        migrations.RemoveField(
            model_name='user',
            name='is_staff',
        ),
    ]