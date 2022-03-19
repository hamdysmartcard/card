from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Treatment(models.Model):
    # relations
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="user_treatments"
    )
    # fields
    treatment = models.CharField(max_length=50)
    is_healed = models.BooleanField(default=False)
    dose = models.TextField()

    def __str__(self):
        return self.treatment
