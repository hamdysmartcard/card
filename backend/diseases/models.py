from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Disease(models.Model):
    # relations
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="user_diseases"
    )
    # fields
    disease = models.CharField(max_length=50)
    discover_date = models.DateField(auto_now=False, auto_now_add=False)
    is_healed = models.BooleanField(default=False)

    def __str__(self):
        return self.disease
