[200~# Use the official Python image as the base
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the requirements.txt file into the container
COPY requirements.txt ./

# Install the dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose the port the Flask app will run on (default is 5000)
EXPOSE 5000

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0"]
