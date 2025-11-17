FROM alpine:latest

COPY gophish /
COPY config.json /

RUN chmod +x /gophish

EXPOSE 3333 8080

CMD ["/gophish"]
