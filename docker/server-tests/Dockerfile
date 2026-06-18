FROM swift:6.1

WORKDIR /app

COPY . ./backend

RUN swift package resolve
RUN swift package clean
RUN swift package update

CMD ["swift", "test", "--parallel", "--enable-code-coverage"]
