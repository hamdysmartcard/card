from rest_framework import serializers
from . import models


class EmergencyContactSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.EmergencyContact
        fields = "__all__"
