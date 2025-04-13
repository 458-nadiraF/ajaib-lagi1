# Use Puppeteer base image
FROM ghcr.io/puppeteer/puppeteer:latest 

# Switch to root user to install dependencies and manage permissions
USER root

# Set the working directory to /app
WORKDIR /app

# Install Node.js and n8n dependencies
RUN npm install -g n8n
# Install Puppeteer and other dependencies
RUN npm install puppeteer
# Install Puppeteer under /node_modules so it's available system-wide
COPY package.json /app/
COPY . /app/

# Install necessary dependencies for Puppeteer
RUN cd /app && npm install

# Set the Chromium environment variables
ENV XDG_CONFIG_HOME=/tmp/.chromium
ENV XDG_CACHE_HOME=/tmp/.chromium

# Install browsers (puppeteer post-installation script)
RUN npx puppeteer browsers install

# Expose the n8n port (5678 by default)
EXPOSE 5678

# Set environment variables for n8n
ENV N8N_BASIC_AUTH_ACTIVE=true

# Command to start n8n
CMD ["n8n", "npm","start"]
