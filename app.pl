use strict;
use warnings;
use Slack::RTM::Bot;
use LWP::UserAgent;
use HTTP::Request::Common;
use Encode 'decode';
use Data::Dumper;
use utf8;
use 5.28.0;

my $channel = 'random';
my $bot = Slack::RTM::Bot->new(
    token => ''
);

$bot->on(
    {
        channel => $channel,
        text => qr/.*だよ|.*/ 
    },
    sub { 
        my ($res) = @_;
        &logSlack($res);
    }
);

say "Start RTM";
$bot->start_RTM;
&saySlack('Start Perl Bot');

while(1) {
    $_ = <>;
    chomp $_;
    if($_ eq 'exit') {
        last;
    }
}

say "Stop RTM";
&saySlack('Stop Perl Bot');
$bot->stop_RTM;

exit;

# Slackに投稿する
sub saySlack {
    my ($str) = @_;
    $bot->say(
        channel => $channel,
        text => $str
    );
    &postSpreadSheet($str);
}

# GoogleSpreadSheetに記録する
sub logSlack {
    my ($log) = @_;
    print Dumper $log;
    my $str = decode('Unicode', $log->{text});
    print"$str\n";
    &postSpreadSheet($str);
}

# GoogleSpreadSheetにPOSTする
sub postSpreadSheet {
    my ($text) = @_;
    my $url = '';
    my %postdata = ('result' => $text);
    my $request = POST($url, \%postdata);

    my $ua = LWP::UserAgent->new;
    my $res = $ua->request($request)->as_string;
}
