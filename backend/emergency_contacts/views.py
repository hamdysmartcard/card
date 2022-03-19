from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from . import serializers, models
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User


@api_view(["POST", "PUT", "GET"])
def emergency_contacts(request, id=None):
    if request.method == "GET":
        user = get_object_or_404(User, id=id)
        contacts = models.EmergencyContact.objects.filter(user=user)
        serializer = serializers.EmergencyContactSerializer(contacts, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    elif request.method == "POST":
        serializer = serializers.EmergencyContactSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    elif request.method == "PUT":
        emergency_contact = get_object_or_404(
            models.EmergencyContact, id=request.data.get("id")
        )
        if request.data.get("name") != None and request.data.get("name") != "":
            emergency_contact.name = request.data.get("name")
        if request.data.get("index") != None and request.data.get("index") != "":
            emergency_contact.index = request.data.get("index")

        if (
            request.data.get("phone_number") != None
            and request.data.get("phone_number") != ""
        ):
            emergency_contact.phone_number = request.data.get("phone_number")
        emergency_contact.save()
        serializer = serializers.EmergencyContactSerializer(emergency_contact)
        return Response(serializer.data, status=status.HTTP_200_OK)
