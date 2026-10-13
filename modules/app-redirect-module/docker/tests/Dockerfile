FROM swift:6.2

WORKDIR /app/modules/app-redirect-module

COPY modules/app-redirect-module /app/modules/app-redirect-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
