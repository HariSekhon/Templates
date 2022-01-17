#!/usr/bin/perl -T
# nagios: -epn
#
#  Author: Hari Sekhon
#  Date: 2008-10-19 14:18:51 +0100 (Sun, 19 Oct 2008)
#
#  vim:ts=4:sts=4:sw=4:et

$main::VERSION = 0.1;

use strict;
use warnings;
#use Benchmark::Timer;
use File::Basename;
use File::Temp "tempfile";
use FindBin;
use Getopt::Long qw(:config bundling);
#use MIME::Lite;
use Pod::Usage;
use SMS::AQL;
use Sys::Hostname;
#use Time::Local;
#use WWW::Shorten::TinyURL;
use lib "$FindBin::Bin";
use lib "/etc/nagios/plugins";
use lib "/usr/lib64/nagios/plugins";
use lib "/usr/lib/nagios/plugins";
use lib ".";
use utils qw(%ERRORS $TIMEOUT);

# go flock ur $self ;)
use Fcntl ':flock'; # import LOCK_* constants
INIT {
    open *{0} or die "What!? $0:$!";
    flock *{0}, LOCK_EX|LOCK_NB or die "$0 is already running somewhere!\n";
}

# Make %ENV safer (taken from PerlSec)
delete @ENV{qw(IFS CDPATH ENV BASH_ENV)};
$ENV{'PATH'} = '/bin:/usr/bin';

my $progname = basename $0;

my $default_timeout = 10;
my $help;
my $timeout = $default_timeout;
my $verbose = 0;
my $version;

sub vlog{
    print "@_\n" if $verbose;
}

sub quit{
    print "$_[0]: $_[1]\n";
    exit $ERRORS{$_[0]};
}

my $critical;
my $default_port = 80;
my $host;
my $port;
my $warning;
sub usage {
    print "@_\n\n" if @_;
    print "usage: $progname [ options ]

    -H --host           Host to connect to
    -p --port           Port to connect to
    -w --warning        Warning threshold
    -c --critical       Critical threshold
    -t --timeout        Timeout in secs (default $default_timeout)
    -v --verbose        Verbose mode
    -V --version        Print version and exit
    -h --help --usage   Print this help
\n";
    exit $ERRORS{"UNKNOWN"};
}

GetOptions (
            "h|help|usage"  => \$help,
            "H|host=s"      => \$host,
            "p|port=s"      => \$port,
            "w|warning=i"   => \$warning,
            "c|critical=i"  => \$critical,
            "t|timeout=i"   => \$timeout,
            "v|verbose+"    => \$verbose,
            "V|version"     => \$version,
# cannot use this while bundling though
#            't|tables=s{,}'    => \@tables,
           ) or usage;

defined($help) and usage;
defined($version) and die "$progname version $main::VERSION\n";

vlog "verbose mode on";

defined($host)                  || usage "hostname not specified";
$host =~ /^([\w\.-]+)$/         || die "invalid hostname given\n";
$host = $1;

#defined($port)                 || usage "port not specified";
$port  =~ /^(\d+)$/             || die "invalid port number given, must be a positive integer\n";
$port = $1;
($port >= 1 && $port <= 65535)  || die "invalid port number given, must be between 1-65535)\n";

defined($warning)       || usage "warning threshold not defined";
defined($critical)      || usage "critical threshold not defined";
$warning  =~ /^\d+$/    || usage "invalid warning threshold given, must be a positive numeric integer";
$critical =~ /^\d+$/    || usage "invalid critical threshold given, must be a positive numeric integer";
($critical >= $warning) || usage "critical threshold must be greater than or equal to the warning threshold";

$timeout =~ /^\d+$/                 || die "timeout value must be a positive integer\n";
($timeout >= 1 && $timeout <= 60)   || die "timeout value must be between 1 - 60 secs\n";

$SIG{ALRM} = sub {
    quit "UNKNOWN", "check timed out after $timeout seconds";
};
vlog "setting plugin timeout to $timeout secs\n";
alarm($timeout);
