from webbrowser import register
from django.contrib import admin
from . import models

# Register your models here.
@admin.register(models.EmergencyContact)
class EmergencyContactAdmin(admin.ModelAdmin):
    """Admin View for"""

    pass
