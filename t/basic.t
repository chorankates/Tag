#!/usr/bin/perl -w
## basic.t -- initial TDD work for HTML::Tag

use strict;
use warnings;

use Test::More qw(no_plan);


use lib '..';
use HTML::Tag;


# scope hacking
my %in;
my $out;

%in = (
    foo => {
        count => 42,
        link_rel => '<base>?value=<value>',
    },
    bar => {
        count => 13,
        link_abs => 'http://foo.com/foo.php?value=bar',
    },
    baz => {
        count => 5,
        link_rel => '<base>?value=<value>',
    },
    '_internal' => {
        'base' => 'http://foo.com/foo.php',
        'count' => 0, # hacky
    },
    
);

$out = HTML::Tag::build_cloud(\%in, 50, 50, 0);

is (defined $out, 1, "some content was returned:: $out");
#is_valid_markup($out);

%in = (
    one => {
        count => 1,
        link_rel => '<base>?value=<value>',
    },
    two => {
        count => 22,
        link_abs => 'http://foo.com/foo.php?value=bar',
    },
    three => {
        count => 44,
        link_rel => '<base>?value=<value>',
    },
    four => {
        count => 64,
        link_rel => '<base>?value=<value>',
    },
    five => {
        count => 84,
        link_rel => '<base>?value=<value>',
    },
    '_internal' => {
        'base' => 'http://foo.com/foo.php',
        'count' => 0, # hacky
    },
    
);

$out = HTML::Tag::build_cloud(\%in, 100, 100, 0);

is (defined $out, 1, "some content was returned:: $out");

## build a 100 element hash
%in = ( '_internal' => { 'base' => 'http://bar.com/bar.php', count => 0 } );
for (my $i = 0; $i < 100; $i++) {
    my $key = $i;
    $in{$key}{count}    = $key;
    $in{$key}{link_rel} = '<base>?value=<value>';
}

$out = HTML::Tag::build_cloud(\%in, 200, 200, 0);

is (defined $out, 1, "some content was returned:: $out");

exit;
