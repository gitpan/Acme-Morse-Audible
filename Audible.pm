package Acme::Morse::Audible;
use 5.006;
use strict;
use warnings;

our $VERSION = '1.00';

my $hearable = "\x4d\x54\x68\x64\0\0\0\6\0\0\0\1\x60\0\115\124\162\153";
my($long,$short)=("\xFF\x40\x90\x56\x50\x82\xDF\0\x80\x56\x00","\xFF\x40\x90\x56\x50\xFF\x40\x80\x56\x00");

sub record{
	local $_ = unpack 'b*', pop;
	s/(.)/$1?$long:$short/eg;
	$_="\0\xC0\x11\0\xFF\x59\x02\0\0$_\0\xFF\x2F";
	$hearable . pack('L', length($_)) . $_;
}

sub play{
	local $_ = pop;
	s/^$hearable.{4}.+?\0{2}//;s/\0\xFF\x2F$//;
	s/\xFF\x40(.+?)\x56\0/length($1)==7?1:0/ge;
	pack 'b*', $_;
}

open 0 or die "Cannot hear '$0'.\n";
my $telegram;
{local $/=undef;($telegram = <0>) =~ s/.*^\s*use\s+Acme::Morse::Audible\s*;\n//sm;}
close 0;
if($telegram =~ /^$hearable/){
	eval play $telegram;
}else{
	open my $fh,'>',$0 or die "Cannot record '$0'.\n";
	print $fh "use Acme::Morse::Audible;\n" . record $telegram;
	close $fh;
}
exit;

__END__

=head1 NAME

Acme::Morse::Audible - Audio(Morse) Programming with Perl 

=head1 SYNOPSIS

	use Acme::Morse::Audible;
	print <<Message;
	"For there is no enchantment against Jacob, no divination against Israel; now it shall be said of Jacob and Israel, `What has God wrought!'"
	
		--Bible, Numbers 23:23
		
	(The first telegraphic message. Dispatched by Samuel F. B. Morse on May 24, 1844 from Washington D.C. to Baltimore.)
	Message

=head1 DESCRIPTION

The first time a program is run under "use Acme::Morse::Audible;", it will become
a playable MIDI file with the Morse encoding of the code. (Dots and dashes encdoding, actually. 
Morse Code contains only alphabet.)
The program will continue to run as it did before, but will now also be audible.
(Some players might not play it unless you rename it to .mid.)

=head2 DIAGNOSTICS

=over 4

=item C<Cannot record '%s'.>

	Acme::Morse::Audible could not access the source file to modify it.

=item C<Cannot hear '%s'.>

	Acme::Morse::Audible could not access the source file to execute it or read it for first-time encoding.

=back

=head1 AUTHOR

Ido Trivizki, E<lt>trivizki@bigfoot.comE<gt>.

Based on L<Acme::Morse|Acme::Morse> by Damian Conway.

=head1 SEE ALSO

L<Acme::Morse>, L<Acme::Bleach>.

=cut
