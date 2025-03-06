build-pex:
	for target in cli server; do ./build_pex.sh $$target; done

build-images: build-pex
	for target in cli server; do earthly ./$$target+build; done
