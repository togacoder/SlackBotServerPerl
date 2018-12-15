use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;
use Data::Dumper;

my $d = HTTP::Daemon->new(
    LocalAddr => 'localhost',
    LocalPort => 12344,
) or die;
print "Please contact me at: <URL:", $d->url, ">\n";

while (my $c = $d->accept) {
    my $r = $c->get_request;
    print("$r->{_content}\n");
    $c->send_status_line(200);
    $c->close;
    undef($c);
}
exit;
