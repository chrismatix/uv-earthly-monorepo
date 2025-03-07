.PHONY: contents build-pex build-images test

contents:

build-pex:
	@for dir in $$(./scripts/get_workspaces.py); do \
  		echo "Building pex for $$dir..."; \
		./scripts/build_pex.sh $$dir; \
	done

build-images: build-pex
	@for dir in $$(./scripts/get_workspaces.py); do \
		echo "Building image for $$dir..."; \
		earthly ./$$dir+build; \
	done

test:
	@for dir in $$(./scripts/get_workspaces.py); do \
		echo "Testing $$dir..." && \
		(cd $$dir && uv run pytest) || exit 1; \
	done
