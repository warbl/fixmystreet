use utf8;
package FixMyStreet::Cobrand::HighwaysEngland;
use parent 'FixMyStreet::Cobrand::UK';

use strict;
use warnings;

sub council_url { 'highwaysengland' }

sub site_key { 'highwaysengland' }

sub restriction { { cobrand => shift->moniker } }

sub hide_areas_on_reports { 1 }

sub all_reports_single_body { { name => 'Highways England' } }

sub body {
    my $self = shift;
    my $body = FixMyStreet::DB->resultset('Body')->search({ name => 'Highways England' })->first;
    return $body;
}

# Copying of functions from UKCouncils that are needed here also - factor out to a role of some sort?
sub cut_off_date { '' }
sub problems_restriction { FixMyStreet::Cobrand::UKCouncils::problems_restriction($_[0], $_[1]) }
sub problems_on_map_restriction { $_[0]->problems_restriction($_[1]) }
sub problems_sql_restriction { FixMyStreet::Cobrand::UKCouncils::problems_sql_restriction($_[0], $_[1]) }
sub users_restriction { FixMyStreet::Cobrand::UKCouncils::users_restriction($_[0], $_[1]) }
sub updates_restriction { FixMyStreet::Cobrand::UKCouncils::updates_restriction($_[0], $_[1]) }
sub base_url { FixMyStreet::Cobrand::UKCouncils::base_url($_[0]) }

sub admin_allow_user {
    my ( $self, $user ) = @_;
    return 1 if $user->is_superuser;
    return undef unless defined $user->from_body;
    return $user->from_body->name eq 'Highways England';
}

sub enter_postcode_text { 'Enter a location, road name or postcode' }

sub example_places {
    ['A14, Junction 13’, ‘A1 98.5', 'Newark on Trent']
}

sub allow_photo_upload { 0 }

sub report_form_extras { (
    { name => 'sect_label', required => 0 },
    { name => 'area_name', required => 0 },
    { name => 'road_name', required => 0 },
) }

sub allow_anonymous_reports { 'button' }

sub admin_user_domain { 'highwaysengland.co.uk' }

sub anonymous_account {
    my $self = shift;
    return {
        email => $self->feature('anonymous_account') . '@' . $self->admin_user_domain,
        name => 'Anonymous user',
    };
}

sub updates_disallowed {
    my ($self, $problem) = @_;
    return 1 if $problem->is_fixed || $problem->is_closed;
    return 1 if $problem->get_extra_metadata('closed_updates');
    return 0;
}

1;
