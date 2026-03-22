# from django.core.exceptions import ValidationError


class ApplicationError(Exception):
    """Base exception for application-level errors."""

    def __init__(self, message: str, extra: dict | None = None) -> None:
        super().__init__(message)
        self.message = message
        self.extra = extra or {}
