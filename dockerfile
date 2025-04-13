# Use Puppeteer base image
FROM ghcr.io/puppeteer/puppeteer:latest 

# Switch to root user to install dependencies and manage permissions
USER root

# Set the working directory to /app
WORKDIR /app
RUN apt-get update && apt-get install -y \
  curl \
  gnupg2 \
  lsb-release \
  ca-certificates \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends \
  fonts-liberation \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdrm2 \
  libgbm1 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  xdg-utils \
  libu2f-udev \
  libxshmfence1 \
  libglu1-mesa \
  chromium \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# Install Node.js and n8n dependencies
RUN npm install -g n8n puppeteer
# Install Puppeteer and other dependencies
# RUN npm install puppeteer
# Install Puppeteer under /node_modules so it's available system-wide
COPY package.json /app/
COPY . /app/

# Install necessary dependencies for Puppeteer
RUN cd /app && npm install

# Set the Chromium environment variables
ENV XDG_CONFIG_HOME=/tmp/.chromium
ENV XDG_CACHE_HOME=/tmp/.chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium"

# Install browsers (puppeteer post-installation script)
# RUN node -e "require('puppeteer').default.install()"

# Expose the n8n port (5678 by default)
EXPOSE 5678

# Set environment variables for n8n
ENV N8N_BASIC_AUTH_ACTIVE=true

# Command to start n8n
CMD ["n8n", "npm","start"]
