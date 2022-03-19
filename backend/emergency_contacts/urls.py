from django.urls import path
from . import views

urlpatterns = [
    path("emergency-contacts/<int:id>/", views.emergency_contacts),
    path("emergency-contacts", views.emergency_contacts),
]
