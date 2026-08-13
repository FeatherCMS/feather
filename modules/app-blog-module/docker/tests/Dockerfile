FROM swift:6.2

WORKDIR /app/modules/app-blog-module

COPY modules/app-blog-module /app/modules/app-blog-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module
COPY modules/app-web-module /app/modules/app-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
