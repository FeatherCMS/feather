FROM swift:6.3

WORKDIR /app/modules/cms-news-module

COPY modules/cms-news-module /app/modules/cms-news-module
COPY feather-core /app/feather-core
COPY modules/cms-media-module /app/modules/cms-media-module
COPY modules/cms-system-module /app/modules/cms-system-module
COPY modules/cms-web-module /app/modules/cms-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
