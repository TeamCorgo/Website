# Create a new stage for the nginx image
FROM nginx:latest

# Maintainer information
LABEL maintainer="Corgo LC Hunter Pearson <Hunter@corgo.org>"

# Set the environment variable for timezone
ENV TZ=America/Denver

# Install OS Features
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl nano openssl tzdata

# Set the timezone to Denver (Mountain Time)
RUN ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Update package list, clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

###################################################################

# Expose port 80
EXPOSE 80

# Copy the built files from the previous stage into the nginx HTML folder
COPY ./content /usr/share/nginx/html

# Copy nginx config files (Override)
COPY ./config /etc/nginx

# Create a directory for logs
RUN mkdir /etc/nginx/logs

# Copy Docker files
COPY ./entrypoint.sh /entrypoint.sh

# Set permissions for the entrypoint script
RUN chmod +x /entrypoint.sh

# Health check for Nginx
HEALTHCHECK --start-period=60s --interval=300s --timeout=60s --retries=3 \
    CMD curl -k -f http://127.0.0.1:80/robots.txt || exit 1

# Run and refresh 
ENTRYPOINT ["/entrypoint.sh"]
