from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from . import serializers, models
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User


@api_view(["POST", "PUT", "GET"])
def treatment(request, id=None):
    if request.method == "GET":
        user = get_object_or_404(User, id=id)
        treatments = models.Treatment.objects.filter(user=user)
        serializer = serializers.TreatmentSerializer(treatments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == "POST":
        serializer = serializers.TreatmentSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    elif request.method == "PUT":
        treatment = get_object_or_404(models.Treatment, id=request.data.get("id"))
        if (
            request.data.get("treatment") != None
            and request.data.get("treatment") != ""
        ):
            treatment.treatment = request.data.get("treatment")
        if request.data.get("dose") != None and request.data.get("dose") != "":
            treatment.dose = request.data.get("dose")
        if (
            request.data.get("is_healed") != None
            and request.data.get("is_healed") != ""
        ):
            treatment.is_healed = request.data.get("is_healed")
        treatment.save()
        serializer = serializers.TreatmentSerializer(treatment)
        return Response(serializer.data, status=status.HTTP_200_OK)
