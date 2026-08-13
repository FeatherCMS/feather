FROM swift:6.2

WORKDIR /app/modules/app-analytics-module

COPY modules/app-analytics-module /app/modules/app-analytics-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
