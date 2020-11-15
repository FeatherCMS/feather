CUR_DIR = $(CURDIR)

run:
	swift run Run serve --port 8080

env:
	echo 'BASE_URL="http://0.0.0.0:8080"' > .env.development
	echo 'BASE_PATH="$(CUR_DIR)/"' >> .env.development
	#echo 'DB_URL=postgres://myuser:mypass@localhost:5432/mydb' >> .env.development

module:
	echo "todo"
	
clean:
	echo "todo"

test:
	swift test --enable-test-discovery

views:
	for f in Sources/App/Modules/*; do  m=$$(basename $$f); cp -r "$${f}/Views/" "Resources/Views/$${m}" 2>/dev/null; done;

css:
	cat Public/css/frontend.css Public/css/frontend.light.css Public/css/frontend.dark.css \
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

install: views css
	swift package update
	swift build -c release
	install .build/Release/Run ./feather #./usr/local/bin/feather
	
uninstall:
	rm -r Resources/Views/*
	rm Public/css/frontend.min.css
	rm ./feather
