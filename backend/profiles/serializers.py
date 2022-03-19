from rest_framework import serializers
from django.contrib.auth.models import User
from . import models
from django.contrib.auth import authenticate
from treatment import serializers as treatment_serializers
from diseases import serializers as diseases_serializers
from emergency_contacts import serializers as emergency_contacts_serializers


class RegisterUserSerializer(serializers.ModelSerializer):
    name = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "email", "username", "password", "name"]
        extra_kwargs = {
            "password": {"write_only": True},
            "username": {"write_only": True},
            "email": {"write_only": True},
        }

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(
            username=validated_data["username"],
            email=validated_data["email"],
        )
        user.set_password(password)
        user.save()
        profile = models.Profile(user=user, name=validated_data["name"])
        profile.save()
        return user


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Profile
        exclude = ("id", "forget_pass_code")


class webSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(
        many=False,
        read_only=True,
        source="user_profile",
    )
    treatments = treatment_serializers.TreatmentSerializer(
        many=True,
        read_only=True,
        source="user_treatments",
    )
    diseases = diseases_serializers.DiseaseSerializer(
        many=True,
        read_only=True,
        source="user_diseases",
    )
    emergency_contacts = emergency_contacts_serializers.EmergencyContactSerializer(
        many=True,
        read_only=True,
        source="user_emergency_contacts",
    )

    class Meta:
        model = models.User
        fields = ["profile", "treatments", "diseases", "emergency_contacts"]


class LoginUserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)
    treatments = treatment_serializers.TreatmentSerializer(
        many=True,
        read_only=True,
        source="user_treatments",
    )
    diseases = diseases_serializers.DiseaseSerializer(
        many=True,
        read_only=True,
        source="user_diseases",
    )
    emergency_contacts = emergency_contacts_serializers.EmergencyContactSerializer(
        many=True,
        read_only=True,
        source="user_emergency_contacts",
    )

    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "password",
            "email",
            "profile",
            "treatments",
            "diseases",
            "emergency_contacts",
        ]
        extra_kwargs = {
            "password": {"write_only": True},
            "email": {"write_only": True},
            "username": {"validators": [], "write_only": True},
        }

    def validate(self, data):
        user = authenticate(username=data["username"], password=data["password"])
        if user == None:
            raise serializers.ValidationError(
                {"error": "Invalid Username And Password"}
            )
        else:
            return user
