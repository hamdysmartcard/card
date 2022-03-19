from django.contrib import admin
from . import models

# Register your models here.
@admin.register(models.Treatment)
class TreatmentAdmin(admin.ModelAdmin):
    """Admin View for Treatment"""

    pass
