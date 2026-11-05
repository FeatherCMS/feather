FROM swift:6.3

WORKDIR /app/modules/app-redirect-module

COPY modules/app-redirect-module /app/modules/app-redirect-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
