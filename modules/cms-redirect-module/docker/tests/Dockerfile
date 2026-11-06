FROM swift:6.3

WORKDIR /app/modules/cms-redirect-module

COPY modules/cms-redirect-module /app/modules/cms-redirect-module
COPY feather-core /app/feather-core
COPY modules/cms-system-module /app/modules/cms-system-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
