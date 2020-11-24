# evacs-blt

This script converts election data files from the
[EVACS](http://www.softimp.com.au/evacs/) format into the BLT format,
suitable for counting with [OpenSTV](http://openstv.org) or
[OpaVote](http://www.opavote.com).  The script requires a relatively
modern version of Perl and is easy to run. For example:

`$ perl evacs-to-blt.pl Molonglo < MolongloTotal.txt > Molonglo.blt`

The EVACS files are expected to be found in the current directory.
