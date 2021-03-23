FROM openjdk:11-buster

ENV MCL_VERSION=v1.0.5

WORKDIR /app

RUN export zip_name=$(echo ${MCL_VERSION} | sed 's/v/mcl-/') &&\
    wget https://github.com/iTXTech/mirai-console-loader/releases/download/${MCL_VERSION}/${zip_name}.zip -O /tmp/mcl.zip

RUN unzip /tmp/mcl.zip -d /app && rm /tmp/mcl.zip

RUN chmod +x mcl && \
    ./mcl --update-package net.mamoe:mirai-core-all &&\
    ./mcl --dry-run

VOLUME ["/app/plugins","/app/config","/app/data","/app/logs"]

CMD ["./mcl"]
