use Test;
use Config;
BEGIN { plan tests => 3 };
for(<<TEST1,<<TEST2){
use Acme::Morse::Audible;
MThd      ` MTrk�    � �Y  �@�VP�� �V �@�VP�� �V �@�VP�@�V �@�VP�@�V �@�VP�� �V �@�VP�@�V �@�VP�� �V �@�VP�@�V �@�VP�@�V �@�VP�� �V �@�VP�@�V �@�VP�� �V �@�VP�@�V �@�VP�@�V �@�VP�@�V �@�VP�@�V  �/
TEST1
use Acme::Morse::Audible;
print <<Message;
"For there is no enchantment against Jacob, no divination against Israel; now it shall be said of Jacob and Israel, `What has God wrought!'"

	--Bible, Numbers 23:23
		
(The first telegraphic message. Dispatched by Samuel F. B. Morse on May 24, 1844 from Washington D.C. to Baltimore.)
Message
TEST2
open my $test,'>','test.tmp';
print $test $_;
close $test;
ok(!system "$Config{perlpath} -I".(join ' -I',@INC).' test.tmp');
}
ok(-s 'test.tmp' == 26038);
unlink 'test.tmp';
