FROM swift:6.2

WORKDIR /app/backend/app-modules/app-blog-module

COPY backend/app-modules/app-blog-module /app/backend/app-modules/app-blog-module
COPY backend/app-modules/app-kernel /app/backend/app-modules/app-kernel
COPY backend/app-modules/app-system-module /app/backend/app-modules/app-system-module
COPY backend/app-modules/app-web-module /app/backend/app-modules/app-web-module

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
