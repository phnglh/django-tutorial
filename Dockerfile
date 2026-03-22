FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# ── development ──────────────────────────────────────────────────────────────
FROM base AS development

COPY pyproject.toml uv.lock ./
RUN uv sync --group dev --frozen

COPY . .

EXPOSE 8000
CMD ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]

# ── builder (install prod deps only) ─────────────────────────────────────────
FROM base AS builder

COPY pyproject.toml uv.lock ./
RUN uv sync --group prod --no-dev --frozen

# ── production ────────────────────────────────────────────────────────────────
FROM base AS production

COPY --from=builder /app/.venv /app/.venv

RUN groupadd --gid 1001 app && useradd --uid 1001 --gid app --no-create-home app

COPY --chown=app:app . .

RUN mkdir -p /run/gunicorn && chown app:app /run/gunicorn

ENV PATH="/app/.venv/bin:$PATH"

USER app

EXPOSE 8000
CMD ["gunicorn", "config.wsgi:application", "--config", "deploy/gunicorn/gunicorn.conf.py"]
