# Use a lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first and install early (good for Docker cache)
COPY requirements.txt .

# Install dependencies
RUN apt-get update && apt-get install -y g++
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libffi-dev \
    libssl-dev \
    libatlas-base-dev \
    libjpeg-dev \
    libpng-dev \
    libfftw3-dev \
    libfftw3-single3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose the port uvicorn will run on
EXPOSE 8000

# Start FastAPI with gunicorn and multiple uvicorn workers for better performance
CMD ["gunicorn", "-w", "1", "-k", "uvicorn.workers.UvicornWorker", "app:app", "--bind", "0.0.0.0:8000"]
