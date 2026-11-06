FROM swift:6.3

WORKDIR /app/modules/cms-web-module

COPY modules/cms-web-module /app/modules/cms-web-module
COPY feather-core /app/feather-core
COPY modules/cms-system-module /app/modules/cms-system-module
COPY modules/cms-media-module /app/modules/cms-media-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
