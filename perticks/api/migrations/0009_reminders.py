# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0008_hospitaldata_hospital_telephone'),
    ]

    operations = [
        migrations.CreateModel(
            name='Reminders',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('reminder_date', models.DateField()),
                ('reminder_sent', models.BooleanField(default=False)),
                ('report', models.ForeignKey(to='api.BiteReport')),
            ],
        ),
    ]
