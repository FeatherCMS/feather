FROM swift:6.2

WORKDIR /app/modules/app-account-module

COPY modules/app-account-module /app/modules/app-account-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
