package HighwaysEngland;

use strict;
use warnings;

use FixMyStreet;
use DBI;
use Utils;

sub database_file { FixMyStreet->path_to('../data/roads.sqlite') }

sub junction_lookup {
    my $s = shift;
    if ($s =~ /^\s*(?<road>[AM][0-9MT]*)[\s,.]*(junction|junc|j)\s*(?<junction>.*?)\s*$/i
          || $s =~ /^\s*(junction|junc|j)\s*(?<junction>.*?)[,.\s]*(?<road>[AM][0-9MT]*)\s*$/i
    ) {
        return _lookup_db($+{road}, 'junction', $+{junction}, 'name') || undef;
    } elsif ($s =~ /^\s*(?<road>[AM][^ ]*)\s*(?<dist>[0-9.]+)\s*$/i
          || $s =~ /^\s*(?<dist>[0-9.]+)\s*(?<road>[AM][^ ]*)\s*$/i
    ) {
        return _lookup_db($+{road}, 'sign', $+{dist}, 'distance') || undef;
    }
}

sub _lookup_db {
    my ($road, $table, $thing, $thing_name) = @_;
    my $db = DBI->connect("dbi:SQLite:dbname=".database_file(), undef, undef) or return;
    $thing = "J$thing" if $table eq 'junction' && $thing =~ /^[1-9]/;
    my $results = $db->selectall_arrayref(
        "SELECT * FROM $table where road=? and $thing_name=?",
        { Slice => {} }, uc $road, uc $thing);
    return unless $results;
    if (@$results) {
        my ($lat, $lon) = Utils::convert_en_to_latlon($results->[0]{easting}, $results->[0]{northing});
        return { latitude => $lat, longitude => $lon };
    }
}

1;
