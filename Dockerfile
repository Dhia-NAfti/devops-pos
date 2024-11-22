FROM ubuntu:22.04

# Install necessary packages and clean up cache to reduce image size
RUN echo "Installing necessary packages and cleaning up cache..." && \
  #  apt-get update && \
    apt-get install -y apache2   git python3 python3-pip python3-venv libpq-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo "Packages installed and cache cleaned."

ARG ght
RUN echo "Cloning the private GitHub repository..." && \
    git clone https://${ght}@github.com/Dhia-NAfti/point-of-sell.git /tmp/point-of-sell && \
    cd /tmp/point-of-sell/pos-back-end && \
    echo "Setting up virtual environment..." && \
    python3 -m venv venv && \
    echo "Installing Python dependencies..." && \
    ./venv/bin/pip install -r requirements.txt && \
    echo "Repository cloned and dependencies installed."


# Set the working directory to the backend directory
WORKDIR /tmp/point-of-sell/pos-back-end

# Expose the necessary port for the Python backend
EXPOSE 8000

# Run both Apache and the Python backend
CMD echo "Starting Apache and the Python backend..." && \
    bash -c "apache2ctl -D FOREGROUND & ./venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000"

