FROM swift:6.3

WORKDIR /app/modules/cms-newsletter-module

COPY modules/cms-newsletter-module /app/modules/cms-newsletter-module
COPY feather-core /app/feather-core
COPY modules/cms-system-module /app/modules/cms-system-module
COPY modules/cms-web-module /app/modules/cms-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
