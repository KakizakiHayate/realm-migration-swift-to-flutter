.PHONY: clean setup ios build run

clean:
	flutter clean
	flutter pub get

ios:
	cd ios && pod deintegrate && pod install && cd ..

build:
	flutter pub run build_runner build

setup: clean ios build

run:
	flutter run

all: setup run