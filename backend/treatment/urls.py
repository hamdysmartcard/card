from django.urls import path
from . import views

urlpatterns = [
    path("treatment/<int:id>/", views.treatment),
    path("treatment", views.treatment),
]
