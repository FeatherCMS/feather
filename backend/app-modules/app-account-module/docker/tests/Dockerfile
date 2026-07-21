FROM swift:6.2

WORKDIR /app/backend/app-modules/app-account-module

COPY backend/app-modules/app-account-module /app/backend/app-modules/app-account-module
COPY backend/app-modules/app-kernel /app/backend/app-modules/app-kernel

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
