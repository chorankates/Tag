#!/usr/bin/perl -w
## basic.t -- initial TDD work for HTML::Tag

use strict;
use warnings;

use Test::HTML::W3C;
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
    '_base' => 'http://foo.com/foo.php',
    );

$out = HTML::Tag::build_cloud(\%in, 0);

is (defined $out, 1, "some content was returned:: $out");
#is_valid_markup($out);


exit;
