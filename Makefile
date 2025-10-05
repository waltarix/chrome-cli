# chrome-cli Makefile

PROJECT = chrome-cli.xcodeproj
SCHEME = chrome-cli
CONFIGURATION = Release
DERIVED_DATA_PATH = ./build
BUILD_DIR = $(DERIVED_DATA_PATH)/Build/Products/$(CONFIGURATION)
BINARY = $(BUILD_DIR)/chrome-cli

# Get version from App.m kVersion constant
VERSION ?= $(shell sed -n 's/.*kVersion = @"\(.*\)".*/\1/p' chrome-cli/App.m)
ARCHIVE_NAME = chrome-cli-$(VERSION)-aarch64-apple-darwin.tar.xz
DIST_DIR = chrome-cli-$(VERSION)

.PHONY: all build archive clean

all: archive

build:
	xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		ARCHS=arm64 \
		ONLY_ACTIVE_ARCH=NO

archive: build
	@echo "Creating archive: $(ARCHIVE_NAME)"
	mkdir -p $(DIST_DIR)
	cp $(BINARY) $(DIST_DIR)/
	cp -r scripts $(DIST_DIR)/
	tar -cJf $(ARCHIVE_NAME) $(DIST_DIR)
	rm -rf $(DIST_DIR)
	@echo "Archive created: $(ARCHIVE_NAME)"

clean:
	rm -rf $(DERIVED_DATA_PATH)
	rm -f *.tar.xz
	rm -rf chrome-cli-*
	@echo "Clean complete"
