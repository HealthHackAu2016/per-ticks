# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.core.validators


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0007_auto_20161015_0809'),
    ]

    operations = [
        migrations.AddField(
            model_name='hospitaldata',
            name='hospital_telephone',
            field=models.CharField(blank=True, max_length=11, validators=[django.core.validators.RegexValidator(b'^[0-9]*$', b'Only numeric characters are allowed.')]),
        ),
    ]
