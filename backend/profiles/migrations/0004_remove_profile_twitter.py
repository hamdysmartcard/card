# Generated by Django 4.0.3 on 2022-03-06 04:33

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('profiles', '0003_alter_profile_address_alter_profile_blood_type_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='profile',
            name='twitter',
        ),
    ]