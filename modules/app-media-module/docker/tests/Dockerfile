FROM swift:6.2

WORKDIR /app/modules/app-media-module

COPY modules/app-media-module /app/modules/app-media-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
