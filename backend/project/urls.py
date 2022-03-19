from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include("profiles.urls")),
    path("api/", include("treatment.urls")),
    path("api/", include("diseases.urls")),
    path("api/", include("emergency_contacts.urls")),
]
