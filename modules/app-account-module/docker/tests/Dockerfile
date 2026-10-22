FROM swift:6.3

WORKDIR /app/feather/modules/app-account-module

COPY feather/modules/app-account-module /app/feather/modules/app-account-module
COPY feather/feather-core /app/feather/feather-core
COPY feather/modules/app-auth-module /app/feather/modules/app-auth-module
COPY feather/modules/app-media-module /app/feather/modules/app-media-module
COPY feather/modules/app-system-module /app/feather/modules/app-system-module
COPY feather/modules/app-user-module /app/feather/modules/app-user-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
