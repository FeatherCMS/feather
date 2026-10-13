FROM swift:6.2

WORKDIR /app/app-newsletter-module

COPY modules/app-newsletter-module /app/app-newsletter-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
