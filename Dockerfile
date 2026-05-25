# syntax=docker/dockerfile:1

FROM node:20-alpine AS frontend-builder
WORKDIR /build/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build

FROM python:3.11-slim AS runtime
WORKDIR /app

ENV FLASK_ENV=production \
    PYTHONUNBUFFERED=1

COPY requirements.txt requirements-prod.txt ./
RUN pip install --no-cache-dir -r requirements-prod.txt

COPY app ./app
COPY run.py wsgi.py migrate_history.py ./
COPY --from=frontend-builder /build/static ./static

RUN mkdir -p /app/instance

EXPOSE 8002

CMD ["gunicorn", "--bind", "0.0.0.0:8002", "--workers", "2", "--threads", "4", "--timeout", "60", "wsgi:app"]
