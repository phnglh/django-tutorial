#!/usr/bin/env python
"""Seed script to populate the database with initial/demo data.

Usage:
    python scripts/seed_data.py
"""

import os
import sys

import django

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.development")

django.setup()


def run() -> None:
    print("Seeding data...")
    # Add seed logic here.
    print("Done.")


if __name__ == "__main__":
    run()
