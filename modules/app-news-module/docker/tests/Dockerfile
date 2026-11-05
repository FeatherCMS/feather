FROM swift:6.3

WORKDIR /app/modules/app-news-module

COPY modules/app-news-module /app/modules/app-news-module
COPY feather-core /app/feather-core
COPY modules/app-media-module /app/modules/app-media-module
COPY modules/app-system-module /app/modules/app-system-module
COPY modules/app-web-module /app/modules/app-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
