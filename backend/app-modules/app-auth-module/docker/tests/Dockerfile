FROM swift:6.2

WORKDIR /app/backend/app-modules/app-auth-module

COPY backend/app-modules/app-auth-module /app/backend/app-modules/app-auth-module
COPY backend/app-modules/app-kernel /app/backend/app-modules/app-kernel
COPY backend/app-modules/app-system-module /app/backend/app-modules/app-system-module
COPY backend/app-modules/app-user-module /app/backend/app-modules/app-user-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
