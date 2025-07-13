FROM python:3.12-slim

# Set working directory inside container
WORKDIR /app

# Copy dependency files from backend
COPY backend/pyproject.toml backend/poetry.lock backend/README.md ./  

# Install dependencies
RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Copy actual app code from backend
COPY backend/ .

# Start server with ASGI
CMD ["poetry", "run", "gunicorn", "score.asgi:application", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
