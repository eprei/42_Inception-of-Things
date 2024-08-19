INDEX	=	docs/index.html
README	=	README.adoc

$(INDEX): $(README)
	asciidoctor $(README) -o $(INDEX) \
		--attribute nofooter \
		--attribute toc=left \
		--attribute sectnums \
		--attribute sectnumlevels=2

docs: $(INDEX)

.PHONY: docs
