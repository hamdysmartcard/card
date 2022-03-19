from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Profile(models.Model):
    # relations
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="user_profile"
    )
    # fields
    name = models.CharField(max_length=50)

    phone_number = models.CharField(max_length=50, default=None, null=True, blank=True)
    profile_image = models.ImageField(
        upload_to="media/profile pictures",
        height_field=None,
        width_field=None,
        max_length=None,
        default=None,
        null=True,
        blank=True,
    )
    address = models.TextField(default=None, null=True, blank=True)
    blood_type = models.CharField(max_length=50, default=None, null=True, blank=True)
    is_addictive = models.BooleanField(default=None, null=True, blank=True)
    national_id = models.IntegerField(default=None, null=True, blank=True)
    facebook = models.CharField(max_length=50, default=None, null=True, blank=True)
    instagram = models.CharField(max_length=50, default=None, null=True, blank=True)
    whatsapp = models.CharField(max_length=50, default=None, null=True, blank=True)

    forget_pass_code = models.CharField(
        max_length=50, default=None, null=True, blank=True
    )

    def __str__(self):
        return self.name
