.PHONY: test doctor dry-run install

test:
	./tests/install_test.sh

doctor:
	./doctor.sh

dry-run:
	./install.sh --dry-run

install:
	./install.sh --apply
