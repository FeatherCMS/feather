FROM swift:6.3

WORKDIR /app/modules/app-system-module

COPY feather/modules/app-system-module /app/modules/app-system-module
COPY feather/feather-core /app/feather-core
COPY feather-database /feather-database
COPY feather-sql /feather-sql
COPY feather-sql-postgres /feather-sql-postgres
COPY feather-dbal /feather-dbal

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
