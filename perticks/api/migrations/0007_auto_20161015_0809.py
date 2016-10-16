# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0006_auto_20161015_0336'),
    ]

    operations = [
        migrations.CreateModel(
            name='HospitalData',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('hospital_name', models.CharField(max_length=128)),
                ('hospital_address', models.CharField(max_length=512)),
            ],
        ),
        migrations.AddField(
            model_name='bitereport',
            name='number_of_bites',
            field=models.IntegerField(default=1),
        ),
        migrations.AddField(
            model_name='bitereport',
            name='wants_reminder',
            field=models.BooleanField(default=False),
        ),
    ]
