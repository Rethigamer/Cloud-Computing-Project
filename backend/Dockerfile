# Use a lightweight official Python image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies first (for faster rebuilding)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code (including app.py and templates/)
COPY . .

# Inform Docker that the container listens on port 5000
EXPOSE 5000

# Command to run the application using Gunicorn
# "app:app" refers to the Flask instance named 'app' inside the app.py file
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]