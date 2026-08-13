FROM swift:6.2

WORKDIR /app/modules/app-auth-module

COPY modules/app-auth-module /app/modules/app-auth-module
COPY feather-core /app/feather-core
COPY modules/app-system-module /app/modules/app-system-module
COPY modules/app-user-module /app/modules/app-user-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
