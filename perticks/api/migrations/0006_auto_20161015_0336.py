# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0005_auto_20161015_0317'),
    ]

    operations = [
        migrations.AddField(
            model_name='bitereport',
            name='bitten_before',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='bitereport',
            name='submission_date',
            field=models.DateField(default=datetime.datetime(2016, 10, 15, 3, 36, 13, 584125, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
    ]
