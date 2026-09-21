"""
Django settings for demodesk project.
"""

import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent


# ============================================================
# SECURITY
# ============================================================

SECRET_KEY = "django-insecure-change-this-in-production"

DEBUG = True

ALLOWED_HOSTS = [
    "10.0.2.221",
    "65.2.183.45",
    "localhost",
    "127.0.0.1",
]


# ============================================================
# APPLICATIONS
# ============================================================

INSTALLED_APPS = [
    # Django
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django.contrib.sites",

    # Pinax dependencies
    "account",
    "pinax.invitations",
    "pinax.teams",

    # Project / third-party
    "helpdesk",
    "rest_framework",
    "storages",
]

SITE_ID = 1


# ============================================================
# MIDDLEWARE
# ============================================================

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]


# ============================================================
# URL / WSGI
# ============================================================

ROOT_URLCONF = "demodesk.config.urls"

WSGI_APPLICATION = "demodesk.config.wsgi.application"


# ============================================================
# TEMPLATES
# ============================================================

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


# ============================================================
# DATABASE - AWS RDS POSTGRESQL
# ============================================================

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


# ============================================================
# PASSWORD VALIDATION
# ============================================================

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


# ============================================================
# INTERNATIONALIZATION
# ============================================================

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# ============================================================
# AWS S3 STATIC FILES
# ============================================================
# ============================================================
# AWS S3 STATIC FILES
# ============================================================

AWS_STORAGE_BUCKET_NAME = "django-helpdesk-poc-artifacts-593760773720"

AWS_S3_REGION_NAME = "ap-south-1"

# Store static files under the static/ prefix
AWS_LOCATION = "static"

# Keep the S3 bucket private
AWS_QUERYSTRING_AUTH = True

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

# ============================================================
# MEDIA
# ============================================================

MEDIA_URL = "/media/"

MEDIA_ROOT = os.path.join(BASE_DIR, "media")


# ============================================================
# DJANGO DEFAULT
# ============================================================

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


# ============================================================
# DJANGO-HELPDESK SETTINGS
# ============================================================

HELPDESK_DEFAULT_QUEUE = "IT Support"

HELPDESK_CREATE_TICKET_SUBJECT_PREFIX = ""

# IMPORTANT:
# django-helpdesk requires "ticket.ticket" to be present.
HELPDESK_EMAIL_SUBJECT_TEMPLATE = (
    "{{ ticket.ticket }} {{ ticket.title|safe }} %(subject)s"
)

HELPDESK_EMAIL_FOLLOWUP_SUBJECT_TEMPLATE = (
    "[{{ ticket.queue.slug }}] {{ ticket.title }}"
)

HELPDESK_EMAIL_REPLY_SUBJECT_TEMPLATE = (
    "[{{ ticket.queue.slug }}] {{ ticket.title }}"
)


# ============================================================
# AUTHENTICATION
# ============================================================

LOGIN_URL = "/accounts/login/"

LOGIN_REDIRECT_URL = "/"

LOGOUT_REDIRECT_URL = "/"