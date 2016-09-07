build: dockerfiles FORCE
	cd builder; for i in *.dockerfile; do \
		docker build -f $$i -t beijaflorio/haskell-builder:$$i . ; \
	done

push: FORCE
	cd builder; for i in *.dockerfile; do \
		docker push `basename $$i ".dockerfile"`; \
	done

dockerfiles: ./builder/dockerfile.hs
	cd builder; ./dockerfile.hs

FORCE:
