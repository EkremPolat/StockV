from django.apps import AppConfig

class StockvConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'stockV'

    def ready(self):
        from stockV.coin_fetch import Command
        Command().handle()
