CUR_DIR = $(CURDIR)

run:
	swift run Feather

env:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/"' > .env.development
	echo 'FEATHER_HTTPS=false' >> .env.development

clean:
	rm -rf ./Resources/ ./Public/


env.testing:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/Tests/"' > .env.testing
	echo 'FEATHER_HTTPS=false' >> .env.development
		
clean.testing:
	rm -rf ./Tests/Resources/ ./Tests/Public/

test: clean.testing env.testing
	swift test

install:
	swift package update
	swift build -c release
	install .build/Release/Feather ./feather #./usr/local/bin/feather

uninstall:
	rm Public/css/frontend.min.css
	rm ./feather
