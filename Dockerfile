FROM python:3.8

RUN apt-get update && \
    apt-get install -y android-tools-adb && \
    apt-get clean

COPY init.sh /init.sh

RUN chmod +x /init.sh

WORKDIR /app

ENTRYPOINT ["/init.sh"]