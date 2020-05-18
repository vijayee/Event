build:
	mkdir -p build
test: build
	mkdir -p build/test
test/Events: test Events/test/*.pony
	stable fetch
	stable env ponyc Events/test -o build/test --debug
test/execute: test/Events
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
