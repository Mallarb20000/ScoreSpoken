FROM python:3.12-slim

WORKDIR /app

# Copy only the dependency files first for caching
COPY pyproject.toml poetry.lock README.md ./

# Install poetry and dependencies
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy app source code
COPY . .

# Optional: collect static files for admin/media use
RUN poetry run python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

# Run Django app with ASGI support
CMD ["poetry", "run", "gunicorn", "score.asgi:application", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
