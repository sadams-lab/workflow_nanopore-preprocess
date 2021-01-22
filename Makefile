CROMWELL = cromwell/cromwell-*.jar
WOMTOOL = cromwell/womtool*.jar
BASEWDL = nanopore_preprocess.wdl

test:
	java -jar $(WOMTOOL) validate $(BASEWDL)
	