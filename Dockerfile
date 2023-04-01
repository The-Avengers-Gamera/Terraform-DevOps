# Use the official Python image as the base image
FROM python:3.10-slim as builder

# Install Flask
RUN pip install --no-cache-dir Flask==2.1.1

# Create the app.py file
RUN echo "from flask import Flask\n\
\n\
app = Flask(__name__)\n\
\n\
@app.route('/')\n\
def hello_world():\n\
    return 'Hello, World!'\n\
\n\
@app.route('/api/v1/actuator/health')\n\
def health_check():\n\
    return '', 200\n\
\n\
if __name__ == '__main__':\n\
    app.run(host='0.0.0.0', port=8080)" > /app.py

# Final stage
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the installed packages and app.py from the builder stage
COPY --from=builder /usr/local /usr/local
COPY --from=builder /app.py .

# Expose the port the app runs on
EXPOSE 8080

# Start the application
CMD ["python", "app.py"]