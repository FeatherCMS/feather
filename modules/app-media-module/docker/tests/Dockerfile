FROM swift:6.3

WORKDIR /app/modules/app-media-module

COPY feather/modules/app-media-module /app/modules/app-media-module
COPY feather/modules/app-system-module /app/modules/app-system-module
COPY feather/feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
