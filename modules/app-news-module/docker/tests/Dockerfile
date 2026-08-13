FROM swift:6.2

WORKDIR /app/app-news-module

COPY modules/app-news-module /app/app-news-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
