from django.urls import path
from . import views

urlpatterns = [
    path("register", views.register),
    path("change-password", views.change_password),
    path("login", views.login),
    path("profile/<int:id>", views.profile),
    path("web/<int:id>", views.web),
    path("forget-password", views.forget),
    path("forget-confermation", views.forget_confermation),
]
