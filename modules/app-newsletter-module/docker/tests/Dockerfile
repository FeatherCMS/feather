FROM swift:6.3

WORKDIR /app/modules/app-newsletter-module

COPY modules/app-newsletter-module /app/modules/app-newsletter-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module
COPY modules/app-web-module /app/modules/app-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
