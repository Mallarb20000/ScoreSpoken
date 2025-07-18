FROM python:3.12-slim AS builder
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN pip install --no-cache-dir poetry && \
    poetry install --only main --no-root

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /app/.venv ./.venv
COPY . .
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000
CMD ["sh", "-c", "python manage.py migrate --noinput && \
                  gunicorn score.asgi:application \
                  -k uvicorn.workers.UvicornWorker \
                  --bind 0.0.0.0:8000"]