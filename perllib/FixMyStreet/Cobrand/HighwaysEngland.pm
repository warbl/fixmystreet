package FixMyStreet::Cobrand::HighwaysEngland;
use parent 'FixMyStreet::Cobrand::UK';

use strict;
use warnings;

sub enter_postcode_text { 'Enter a location, road name or postcode' }

sub example_places {
    my $self = shift;
    return $self->feature('example_places') || $self->next::method();
}

sub allow_photo_upload { 0 }

sub report_form_extras { (
    { name => 'sect_label', required => 0 },
    { name => 'area_name', required => 0 },
    { name => 'road_name', required => 0 },
) }

1;
