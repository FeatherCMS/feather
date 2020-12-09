CUR_DIR = $(CURDIR)

run:
	swift run Feather

env:
	echo 'BASE_URL="http://0.0.0.0:8080"' > .env.development
	echo 'BASE_PATH="$(CUR_DIR)/"' >> .env.development
	
clean:
	rm -rf ./db.sqlite ./Resources/ ./Public/

test:
	swift test --enable-test-discovery

css:
	cat Public/css/frontend.css \
		| tr -d '\n' \
		| tr -d '\t' \
		| tr -s ' ' \
		| sed -E 's/[[:space:]]*:[[:space:]]*/:/g' \
		| sed -E 's/[[:space:]]*,[[:space:]]*/,/g' \
		| sed -E 's/[[:space:]]*\{[[:space:]]*/{/g' \
		| sed -E 's/[[:space:]]*\}[[:space:]]*/}/g' \
		| sed -E 's/[[:space:]]*>[[:space:]]*/>/g' \
		| sed -E 's/[[:space:]]*;[[:space:]]*/;/g' \
		> Public/css/frontend.min.css

install: css
	swift package update
	swift build -c release
	install .build/Release/Feather ./feather #./usr/local/bin/feather

uninstall:
	rm Public/css/frontend.min.css
	rm ./feather
