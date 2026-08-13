FROM swift:6.2

WORKDIR /app/modules/app-web-module

COPY modules/app-web-module /app/modules/app-web-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
