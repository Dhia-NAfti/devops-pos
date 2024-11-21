FROM ubuntu:latest

# Install necessary packages and clean up cache to reduce image size
RUN echo "Installing necessary packages and cleaning up cache..." && \
    apt-get update && \
    apt-get install -y apache2  wget git python3 python3-pip python3-venv libpq-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo "Packages installed and cache cleaned."
