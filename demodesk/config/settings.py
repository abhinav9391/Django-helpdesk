"""
Django settings for demodesk project.
"""

import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-change-this-in-production"

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
    "10.0.2.221",
    "65.2.183.45",
    "localhost",
    "127.0.0.1",
]


# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    "helpdesk",
    "rest_framework",

    # S3 storage
    "storages",
    
]


MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]


ROOT_URLCONF = "demodesk.config.urls"


TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]


WSGI_APPLICATION = "demodesk.config.wsgi.application"

# Database
# PostgreSQL RDS configuration

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ.get("DB_NAME", "helpdesk_db"),
        "USER": os.environ.get("DB_USER", "helpdesk_admin"),
        "PASSWORD": os.environ.get("DB_PASSWORD"),
        "HOST": os.environ.get(
            "DB_HOST",
            "django-helpdesk-poc-postgres.cpaem0kisb5j.ap-south-1.rds.amazonaws.com",
        ),
        "PORT": os.environ.get("DB_PORT", "5432"),
    }
}


# Password validation

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# ----------------------------------------------------------------------
# AWS S3 STATIC FILE STORAGE
# ----------------------------------------------------------------------

AWS_STORAGE_BUCKET_NAME = "django-helpdesk-poc-artifacts-593760773720"

AWS_S3_REGION_NAME = "ap-south-1"

# Keep the S3 bucket private.
# Django will generate signed URLs for static files.
AWS_QUERYSTRING_AUTH = True

# Optional: signed URLs will remain valid for 1 hour.
AWS_QUERYSTRING_EXPIRE = 3600

STORAGES = {
    "default": {
        "BACKEND": "storages.backends.s3.S3Storage",
    },
    "staticfiles": {
        "BACKEND": "storages.backends.s3.S3Storage",
    },
}

STATIC_URL = (
    f"https://{AWS_STORAGE_BUCKET_NAME}.s3."
    f"{AWS_S3_REGION_NAME}.amazonaws.com/static/"
)


# Media files remain on the application server for now

MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")


# Default primary key field type

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


# ----------------------------------------------------------------------
# Helpdesk settings
# ----------------------------------------------------------------------

HELPDESK_DEFAULT_QUEUE = "IT Support"

HELPDESK_CREATE_TICKET_SUBJECT_PREFIX = ""

HELPDESK_EMAIL_SUBJECT_TEMPLATE = "{{ ticket.ticket }} {{ ticket.title|safe }} %(subject)s"

HELPDESK_EMAIL_FOLLOWUP_SUBJECT_TEMPLATE = (
    "[{{ ticket.queue.slug }}] {{ ticket.title }}"
)

HELPDESK_EMAIL_REPLY_SUBJECT_TEMPLATE = (
    "[{{ ticket.queue.slug }}] {{ ticket.title }}"
)


# ----------------------------------------------------------------------
# Authentication
# ----------------------------------------------------------------------

LOGIN_URL = "/accounts/login/"

LOGIN_REDIRECT_URL = "/"

LOGOUT_REDIRECT_URL = "/"