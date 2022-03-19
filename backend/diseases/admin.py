from webbrowser import register
from django.contrib import admin
from . import models

# Register your models here.
@admin.register(models.Disease)
class DiseaseAdmin(admin.ModelAdmin):
    """Admin View for disease"""

    pass
