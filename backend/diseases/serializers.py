from rest_framework import serializers
from . import models


class DiseaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Disease
        fields = "__all__"
