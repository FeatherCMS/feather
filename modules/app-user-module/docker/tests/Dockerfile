FROM swift:6.2

WORKDIR /app/modules/app-user-module

COPY modules/app-user-module /app/modules/app-user-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
