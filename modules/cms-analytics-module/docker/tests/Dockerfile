FROM swift:6.3

WORKDIR /app/modules/cms-analytics-module

COPY modules/cms-analytics-module /app/modules/cms-analytics-module
COPY feather-core /app/feather-core
COPY modules/cms-system-module /app/modules/cms-system-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
