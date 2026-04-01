ARG BUILD_FROM
FROM $BUILD_FROM

ENV \
  LANG=C.UTF-8 \
  PATH=/opt/shot-scraper/bin:$PATH \
  PLAYWRIGHT_BROWSERS_PATH=/opt/playwright

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        python3 \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/shot-scraper

RUN /opt/shot-scraper/bin/pip install --no-cache-dir shot-scraper

# Pre-install Chromium and its runtime dependencies during image build.
RUN /opt/shot-scraper/bin/python -m playwright install --with-deps chromium

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
