FROM swift:6.3

WORKDIR /app/modules/app-web-module

COPY modules/app-web-module /app/modules/app-web-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module
COPY modules/app-media-module /app/modules/app-media-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
