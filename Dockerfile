FROM python:3.12-slim

WORKDIR /app

# Copy only the dependency files first for caching
COPY pyproject.toml poetry.lock README.md ./

RUN pip install poetry && poetry install 

# Now copy the rest of the backend code
COPY . .

# Run Django app with ASGI server for async support
CMD ["poetry", "run", "gunicorn", "score.asgi:application", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]


