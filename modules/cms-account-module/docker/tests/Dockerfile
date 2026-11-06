FROM swift:6.3

WORKDIR /app/feather/modules/cms-account-module

COPY feather/modules/cms-account-module /app/feather/modules/cms-account-module
COPY feather/feather-core /app/feather/feather-core
COPY feather/modules/cms-auth-module /app/feather/modules/cms-auth-module
COPY feather/modules/cms-media-module /app/feather/modules/cms-media-module
COPY feather/modules/cms-system-module /app/feather/modules/cms-system-module
COPY feather/modules/cms-user-module /app/feather/modules/cms-user-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
