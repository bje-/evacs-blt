# Copyright (C) 2016 Ben Elliston
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Usage: perl evacs-to-blt.pl <electorate> > ballots.blt

use strict;
use warnings;
use feature qw(say);
use List::MoreUtils qw(firstidx);

my $pindex = "";
my $nseats = 5;  # seats have 5 members

if (scalar(@ARGV) != 1)
{
    say "Usage: ", $0, " <electorate>" ;
    die;
}

my $ecode = -1;
my $electorate = $ARGV[0];
my %candidates;
my @names;

# Get electorate code from Electorates.txt.
open ELECTORATES, '<', "Electorates.txt";
while (<ELECTORATES>) {
    chomp();
    next if /ecode/;
    my @fields = split(',');
    # strip quotes and newlines
    s/[\r"]//g for @fields;
    if ($fields[1] eq $electorate) { $ecode = $fields[0]; }
}
close ELECTORATES;
$ecode >= 0 || die;

# Gather the candidate names.
my (@fields, $key, $name);
open CANDIDATES, '<', "Candidates.txt";
while (<CANDIDATES>) {
    next if (!/^$ecode,/);
    chomp();
    my @fields = split(',');
    s/[\r]//g for @fields;
    $key = $fields[1] . "," . $fields[2];
    $name = $fields[3] . "," . $fields[4];
    $candidates{$key} = $name;
    push @names, $name;
}
close CANDIDATES;

# The number of candidates and the number of seats.
printf("%d %d\n", scalar(@names), $nseats);

# Start of the first ballot.
print "1 ";

open BALLOTS, '<', $electorate . "Total.txt";
while (<BALLOTS>) {
    next if /batch.*pindex/;
    chomp();
    my @fields = split(',', $_);
    my $candname = $candidates{$fields[3] . "," . $fields[4]};
    my $candnum = firstidx { $_ eq $candname } @names;
    if ($fields[1] ne $pindex)
    {
    	if ($pindex)
	{
	    # End the current ballot and start the next.
    	    printf("0\n1 ");
	}
   	$pindex = $fields[1];
    }
    # Candidates are numbered from 1.
    printf("%d ", $candnum + 1);
}
close BALLOTS;

say "0";  # end of last ballot
say "0";  # end of ballots marker

# Print candidates next.
for my $name (@names) {
    say $name;
}

# Print election title last.
say "\"" . $electorate . "\"";
