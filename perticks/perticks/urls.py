"""perticks URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import include, url
from django.contrib import admin
from api.views import do_login, do_logout
from api.views import static_homepage, static_about, static_tickremoval, research_login, research_view, report_bite, bite_map, update_report, submit, hospital_endpoint, fetch
from api.views import send_reminders, csv_download

urlpatterns = [
    url(r'^about', static_about),
    url(r'^csv-download', csv_download),
    url(r'^tick-removal', static_tickremoval),
    url(r'^login', research_login),
    url(r'^research', research_view),
    url(r'^report-bite', report_bite),
    url(r'^bite-map', bite_map),
    url(r'^update-report', update_report),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/submit', submit),
    url(r'^fe/hospital', hospital_endpoint),
    url(r'^api/fetch', fetch),
    url(r'^api/login', do_login),
    url(r'^api/logout', do_logout),
    url(r'^api/send_reminders', send_reminders),
    url(r'^', static_about),
]
