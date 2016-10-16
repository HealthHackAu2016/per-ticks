# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_bitereport_auth_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='bitereport',
            name='age',
            field=models.DateTimeField(),
        ),
    ]
