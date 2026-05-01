ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG=C.UTF-8
ENV BUN_INSTALL=/root/.bun
ENV PATH=/root/.bun/bin:$PATH

RUN apk add --no-cache \
      ca-certificates \
      curl \
      git \
      unzip

RUN curl -fsSL https://bun.sh/install | bash

RUN git clone -b steamer --depth 1 https://github.com/weidi/huum-controller /opt/huum-controller \
    && cd /opt/huum-controller \
    && printf "%s\n" \
      "import './tcp/tcp-server.ts'" \
      "import './http/http-server.ts'" \
      > src/main.ts \
    && bun install --frozen-lockfile

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
