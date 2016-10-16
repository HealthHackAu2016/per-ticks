from django.db import models
from django.contrib import admin
from django.core.validators import RegexValidator, EmailValidator


class BiteReport(models.Model):
    # Validators
    alphanumeric = RegexValidator(r'^[0-9]*$', 'Only numeric characters are allowed.')
    validate_email = EmailValidator()

    # Fields
    id = models.AutoField(primary_key=True)
    auth_id = models.CharField(max_length=20)
    auth_code = models.CharField(max_length=20)
    email = models.CharField(max_length=200, blank=True, validators=[validate_email])
    phone = models.CharField(max_length=11, blank=True, validators=[alphanumeric])
    allows_follow_up = models.BooleanField(default=False)
    wants_reminder = models.BooleanField(default=False)
    symptom_comments = models.TextField()
    submission_date = models.DateField(auto_now_add=True)
    bite_date = models.DateField()
    lat = models.FloatField()
    lon = models.FloatField()
    bitten_before = models.BooleanField(default=False)
    number_of_bites = models.IntegerField(default=1)
    # travel


admin.site.register(BiteReport)


class HospitalData(models.Model):
    numeric = RegexValidator(r'^[0-9]*$', 'Only numeric characters are allowed.')
    hospital_name = models.CharField(max_length=128)
    hospital_address = models.CharField(max_length=512)
    hospital_telephone = models.CharField(max_length=11, blank=True, validators=[numeric])


admin.site.register(HospitalData)


class Reminders(models.Model):
    report = models.ForeignKey(BiteReport)
    reminder_date = models.DateField()
    reminder_sent = models.BooleanField(default=False)

admin.site.register(Reminders)
