FROM swift:6.3

WORKDIR /app/modules/cms-user-module

COPY modules/cms-user-module /app/modules/cms-user-module
COPY modules/cms-system-module /app/modules/cms-system-module
COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
