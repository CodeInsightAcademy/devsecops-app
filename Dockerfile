# Use official Python base image
FROM python:3.13.2-slim

# Set work directory
WORKDIR /app

# Copy app and requirements
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose the Flask default port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
