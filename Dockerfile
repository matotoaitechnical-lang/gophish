FROM alpine:latest

# Install dependencies
RUN apk add --no-cache --update jq

# Copy the GoPhish binary and start script
COPY gophish /
COPY start.sh /

# Make them executable
RUN chmod +x /start.sh /gophish

# Expose ports
EXPOSE 3333 8080

# Use the start script
CMD ["/start.sh"]
