"""conduit URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.10/topics/http/urls/
"""
from django.urls import include, re_path, path
from django.contrib import admin
from django.http import JsonResponse


# 1. دالة الفحص
def health_check(request):
    return JsonResponse({"status": "healthy"}, status=200)


# 2. قائمة المسارات الموحدة
urlpatterns = [
    # مسار الـ Health Check لـ Docker
    path('api/health/', health_check, name='health_check'),

    # مسار لوحة التحكم
    re_path(r'^admin/', admin.site.urls),

    # مسارات التطبيق
    re_path(r'^api/', include('conduit.apps.articles.urls', namespace='articles')),
    re_path(r'^api/', include('conduit.apps.authentication.urls', namespace='authentication')),
    re_path(r'^api/', include('conduit.apps.profiles.urls', namespace='profiles')),
]