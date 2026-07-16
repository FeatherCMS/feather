FROM swift:6.1

WORKDIR /app

COPY . ./

RUN swift package resolve
RUN swift package clean

CMD ["swift", "test", "--parallel"]
