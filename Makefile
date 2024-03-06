.PHONY: test
test:
	dart run build_runner build --delete-conflicting-outputs
	flutter test
