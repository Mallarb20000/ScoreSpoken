# ---------- Build stage ----------
FROM python:3.12-slim as builder

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Install build tools only once
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libc6-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency files first (maximises layer caching)
COPY pyproject.toml poetry.lock ./

# Install Poetry and the dependencies
RUN pip install --no-cache-dir poetry && \
    poetry install --no-dev --no-root

# ---------- Runtime stage ----------
FROM python:3.12-slim as runtime

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy virtual-env from builder stage
COPY --from=builder /app/.venv ./.venv

# Copy application code
COPY --chown=appuser:appuser . .

USER appuser

# Activate virtual-env and run migrations + server
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000
CMD ["sh", "-c", "python manage.py migrate --noinput && \
                  gunicorn score.asgi:application \
                  -k uvicorn.workers.UvicornWorker \
                  --bind 0.0.0.0:8000"]