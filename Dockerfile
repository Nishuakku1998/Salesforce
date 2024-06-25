FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest

# Update package lists excluding problematic PostgreSQL repository
RUN sed -i '/bionic-pgdg/d' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       gnupg \
       && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
       && apt-get install -y nodejs

# Install Salesforce CLI
RUN npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION=latest}

# Install OpenJDK and other packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       openjdk-11-jdk-headless \
       jq \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV SFDX_CONTAINER_MODE=true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/bash
