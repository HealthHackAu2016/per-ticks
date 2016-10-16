# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_auto_20161015_0315'),
    ]

    operations = [
        migrations.AlterField(
            model_name='bitereport',
            name='age',
            field=models.DateField(),
        ),
    ]
