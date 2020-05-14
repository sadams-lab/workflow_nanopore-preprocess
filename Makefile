SHELL := /bin/bash
DOCKEREXEC = docker
DOCKERDIR = docker
CROMWELL = cromwell/cromwell-*.jar
WOMTOOL = cromwell/womtool*.jar
BASEWDL = nanopore_preprocess.wdl

test:
	java -jar $(WOMTOOL) validate $(BASEWDL)

docker: docker-guppy docker-minimap2

docker-guppy:
	$(DOCKEREXEC) build -f $(DOCKERDIR)/guppy_docker -t guppy:latest . && \
	$(DOCKEREXEC) tag guppy:latest adamslab/guppy:latest && \
	$(DOCKEREXEC) push adamslab/guppy


docker-minimap2:
	$(DOCKEREXEC) build -f $(DOCKERDIR)/minimap2_docker -t minimap2:latest . && \
	$(DOCKEREXEC) tag minimap2:latest adamslab/minimap2:latest && \
	$(DOCKEREXEC) push adamslab/minimap2