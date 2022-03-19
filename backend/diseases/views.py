from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from . import serializers, models
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User


@api_view(["POST", "PUT", "GET"])
def disease(request, id=None):
    if request.method == "GET":
        user = get_object_or_404(User, id=id)
        diseases = models.Disease.objects.filter(user=user)
        serializer = serializers.DiseaseSerializer(diseases, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    elif request.method == "POST":
        serializer = serializers.DiseaseSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    elif request.method == "PUT":
        disease = get_object_or_404(models.Disease, id=request.data.get("id"))
        if request.data.get("disease") != None and request.data.get("disease") != "":
            disease.disease = request.data.get("disease")
        if (
            request.data.get("discover_date") != None
            and request.data.get("discover_date") != ""
        ):
            disease.discover_date = request.data.get("discover_date")
        if (
            request.data.get("is_healed") != None
            and request.data.get("is_healed") != ""
        ):
            disease.is_healed = request.data.get("is_healed")

        disease.save()
        serializer = serializers.DiseaseSerializer(disease)
        return Response(serializer.data, status=status.HTTP_200_OK)
