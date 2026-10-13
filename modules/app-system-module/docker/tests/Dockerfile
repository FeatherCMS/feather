FROM swift:6.2

WORKDIR /app/modules/app-system-module

COPY modules/app-system-module /app/modules/app-system-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
