package HTML::Tag;
use strict;
use warnings;

use 5.010;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT    = qw();
our @EXPORT_OK = qw(build_cloud);


$HTML::Tag::Font_Default = 'Tahoma';
#@HTML::Tag::Font_Sizes = (5, 7, 9, 11, 13);
@HTML::Tag::Font_Sizes = ('70%', '85%', '100%', '115%', '130%'); # hmm..

## generalized routines for generating HTML tag clouds

sub build_cloud {
    # build_cloud(\%hash, $height, $width, [$sort_method], [$min_count]) -- returns an HTML string for a tag 'cloud'
    my $href        = shift;
    my %tags        = %{$href};
    my $height      = shift // 50;
    my $width       = shift // 50;
    my $sort_method = shift // 'ascii'; # allows sorting by 'ascii' or 'value'
    my $min_count   = shift // 1;
    my $html;

    ## need to cull entries with less than $min_count
	

	my @ordered = sort { $tags{$a}{count} <=> $tags{$b}{count} } keys %tags;
	my $high = $tags{$ordered[-1]}{count};
	my $range = ($high / $#HTML::Tag::Font_Sizes);
	
	foreach my $tag (keys %tags) { 
		next if $tag =~ /^_/; # skipping internals
		my $count = $tags{$tag}{count};

		my $size = ($count < ($range)) ? $HTML::Tag::Font_Sizes[0] :
				   ($count < ($range * 2)) ? $HTML::Tag::Font_Sizes[1] :
				   ($count < ($range * 3)) ? $HTML::Tag::Font_Sizes[2] :
				   ($count < ($range * 4)) ? $HTML::Tag::Font_Sizes[3] :
																	$HTML::Tag::Font_Sizes[-1]; # default
		$tags{$tag}{size} = $size;

	}

    ## build the initial HTML
    my $id = 'tag_cloud_' . rand(10000);
    $html = "<div id=\"$id\" style=\"display: inline; border-style: solid; border-width: 1px; border-color: #000000; position: absolute; height: $height; width: $width;\">";

    ## iterate keys according to sort
    my @keys;
    if ($sort_method =~ /value/i) { 
		@keys = sort { $tags{$a}{count} <=> $tags{$b}{count} } keys %tags;
    } else {
		@keys = sort { $a cmp $b } keys %tags;
    }

    for (my $i = 0; $i <= $#keys; $i++) { 
		next if $keys[$i] =~ /^_/i; # skipping internal settings
		my $lhtml;
		my $key = $keys[$i];
		my %tag = %{$tags{$key}}; # need to have some error checking here
		my $size = $tag{size};
		my $count = $tag{count};
		my $base = $tags{_internal}{base};
	
		my $link;
		if (defined $tag{link_rel}) {
			my $link = $tag{link_rel};
			my $alt  = $count;
			
			warn "WARN:: '<base>' specified in '$key', but no '_base' spec in incoming hash" unless $base;
			$link =~ s/<base>/$base/;
			$link =~ s/<value>/$count/g;
			$link =~ s/<key>/$key/g;
	
	
			$lhtml = "<a href=\"$link\" title=\"$count\"><span style=\"font-size: $size;\">$key</span></a>";
	
		} elsif (defined $tag{link_abs}) { 
			my $link = $tag{link_abs};
			my $alt  = $count;
	
			$lhtml = "<a href=$link title=$alt><span style='font-size: $size'>$key</span></a>";
	
		} else  {
			warn "WARN:: no 'link_abs' or 'link_rel' specified for '$key'";
			next;
		}
	
		$html .= " " . $lhtml;

    }

    ## build the closing HTML
    $html .= "</div>";

    return $html;
}


1;
