CUR_DIR = $(CURDIR)

# =====================================================================
# 	run
# =====================================================================
	
env:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/"' > .env.development

clean:
	rm -rf ./Resources/ ./Public/

run:
	swift run Feather

# =====================================================================
# 	testing
# =====================================================================


env.testing:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/Tests/"' > .env.testing
		
clean.testing:
	rm -rf ./Tests/Resources/ ./Tests/Public/

test: clean.testing env.testing
	swift test

# =====================================================================
# 	install
# =====================================================================

install:
	swift package update
	swift build -c release
	install .build/Release/Feather ./feather #./usr/local/bin/feather

uninstall:
	rm ./feather

# =====================================================================
# 	dev
# =====================================================================

dev:
	cd .. && \
	git clone --branch dev git@github.com:FeatherCMS/feather-core.git && \
	git clone --branch dev git@github.com:FeatherCMS/analytics-module.git && \
	git clone --branch dev git@github.com:FeatherCMS/aggregator-module.git && \
	git clone --branch dev git@github.com:FeatherCMS/blog-module.git && \
	git clone --branch dev git@github.com:FeatherCMS/markdown-module.git && \
	git clone --branch dev git@github.com:FeatherCMS/redirect-module.git && \
	git clone --branch dev git@github.com:FeatherCMS/swifty-module.git && \
	cd feather
