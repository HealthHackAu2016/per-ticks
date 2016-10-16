# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_auto_20161015_0316'),
    ]

    operations = [
        migrations.RenameField(
            model_name='bitereport',
            old_name='age',
            new_name='bite_date',
        ),
    ]
