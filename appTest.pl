use strict;
use warnings;
use Slack::RTM::Bot;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Dumper;
use utf8;

my $bot = Slack::RTM::Bot->new(
    token => 'xoxb-376192276660-497178700774-6j9WhVa80qXYN6s7yEnSCich'
);


$bot->on (
    {
        channel => 'random',
        text => qr/.*/
    },
    sub {
        my ($res) = @_;
        &postMessage($res->{text});
        print Dumper $res;
    }
);

print "start_RTM\n";
$bot->start_RTM;
$bot->say(
    channel => 'random',
    text    => 'Start Perl Bot.'
);
&postMessage('Start');

my $str = <>;
chomp $str;

$bot->say(
    channel => 'random',
    text    => $str
);

$bot->say(
    channel => 'random',
    text    => 'Stop Perl Bot.'
);
$bot->stop_RTM;
print "stop_RTM\n";
exit;

sub postMessage {
    my ($text) = @_;
    my $url = 'https://script.google.com/macros/s/AKfycbxyCq6KtAYtx9Ws7GRcoAP_Edm5SGaK_sz5BAG8IqXh6h-zyL2X/exec';
    my %postdata = ('result' => $text);
    my $request = POST($url, \%postdata);

    # 送信
    print("SpreadSheet\n");
    my $ua = LWP::UserAgent -> new;
    my $res = $ua -> request($request) -> as_string;
}
