FROM swift:6.3

WORKDIR /app/feather/modules/app-blog-module

COPY . /app/feather

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
