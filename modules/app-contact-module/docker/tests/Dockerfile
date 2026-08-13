FROM swift:6.2

WORKDIR /app/app-contact-module

COPY modules/app-contact-module /app/app-contact-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
