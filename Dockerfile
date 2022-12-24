FROM adoptopenjdk/openjdk11:alpine-jre

ENV MCL_VERSION v2.1.2

WORKDIR /app

RUN export zip_name=$(echo ${MCL_VERSION} | sed 's/v/mcl-/') &&\
    wget https://github.com/iTXTech/mirai-console-loader/releases/download/${MCL_VERSION}/${zip_name}.zip -O /tmp/mcl.zip &&\
    unzip /tmp/mcl.zip -d /app &&\
    rm -f /tmp/mcl.zip

RUN chmod +x mcl && \
    ./mcl --update-package net.mamoe:mirai-core-all &&\
    ./mcl --update-package org.itxtech:mcl-addon &&\
    ./mcl --update-package org.itxtech:soyuz &&\
    ./mcl --update-package net.mamoe:mirai-api-http --channel stable-v2 --type plugin &&\
    ./mcl --update-package net.mamoe:mirai-login-solver-selenium --channel nightly --type plugin &&\
    ./mcl --dry-run

ENV JAVA_OPTS -Dmirai.slider.captcha.supported

VOLUME ["/app/plugins","/app/config","/app/data","/app/bots","/app/logs"]

CMD ["./mcl"]
