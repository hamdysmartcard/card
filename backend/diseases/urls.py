from django.urls import path
from . import views

urlpatterns = [
    path("disease/<int:id>/", views.disease),
    path("disease", views.disease),
]
