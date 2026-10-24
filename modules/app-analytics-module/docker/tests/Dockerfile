FROM swift:6.3

WORKDIR /app/modules/app-analytics-module

COPY modules/app-analytics-module /app/modules/app-analytics-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
