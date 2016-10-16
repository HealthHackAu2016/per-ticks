# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.core.validators


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BiteReport',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True)),
                ('auth_code', models.CharField(max_length=20)),
                ('email', models.CharField(blank=True, max_length=200, validators=[django.core.validators.EmailValidator()])),
                ('phone', models.CharField(blank=True, max_length=11, validators=[django.core.validators.RegexValidator(b'^[0-9]*$', b'Only numeric characters are allowed.')])),
                ('allows_follow_up', models.BooleanField(default=False)),
                ('symptom_comments', models.TextField()),
                ('age', models.IntegerField()),
                ('lat', models.FloatField()),
                ('lon', models.FloatField()),
            ],
        ),
    ]
