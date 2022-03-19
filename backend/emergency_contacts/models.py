from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class EmergencyContact(models.Model):
    # relations
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="user_emergency_contacts"
    )
    # fields
    index = models.IntegerField()
    name = models.CharField(max_length=50)
    phone_number = models.CharField(max_length=50)

    def __str__(self):
        return self.name
