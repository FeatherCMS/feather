FROM swift:6.2

WORKDIR /app/feather-core

COPY feather-core /app/feather-core

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
