all:

test:
	fgrep -r '#!/usr/bin/perl' -l . | xargs perl -c
	perl -c *.pm
