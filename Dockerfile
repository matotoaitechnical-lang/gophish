# Use a base image. You can find the official one on Docker Hub, or build from source.
# Option A: Use a pre-built binary (simpler)
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache --update jq

# Copy the GoPhish binary and the start script into the container
# (You need to download the Linux AMD64 version of GoPhish for this to work)
COPY gophish /
COPY start.sh /

# Make the script and binary executable
RUN chmod +x /start.sh /gophish

# Expose the admin and phishing ports
EXPOSE 3333 8080

# Start the service using the custom script
CMD ["/start.sh"]
