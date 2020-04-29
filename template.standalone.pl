#!/usr/bin/perl -T
#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2008-10-19 14:18:51 +0100 (Sun, 19 Oct 2008) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

$VERSION = "0.1";

use strict;
use warnings;
use File::Basename;
use Getopt::Long qw(:config bundling);

# go flock ur $self ;)
use Fcntl ':flock'; # import LOCK_* constants
INIT {
    open *{0} or die "What?! $0:$!";
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

sub usage {
    print "@_\n\n" if @_;
    print "$main::DESCRIPTION\n\n" if $main::DESCRIPTION;
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
    exit 1;
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
#   't|tables=s{,}'    => \@tables,
) or usage;

defined($help) and usage;
defined($version) and die "$progname version $main::VERSION\n";

defined($host)                  || usage "hostname not specified";
$host =~ /^([\w\.-]+)$/         || usage "invalid hostname given\n";
$host = $1;

#defined($port)                 || usage "port not specified";
$port  =~ /^(\d+)$/             || usage "invalid port number given, must be a positive integer\n";
$port = $1;
($port >= 1 && $port <= 65535)  || usage "invalid port number given, must be between 1-65535)\n";
defined($warning)       || usage "warning threshold not defined";
defined($critical)      || usage "critical threshold not defined";
$warning  =~ /^\d+$/    || usage "invalid warning threshold given, must be a positive numeric integer";
$critical =~ /^\d+$/    || usage "invalid critical threshold given, must be a positive numeric integer";
($critical >= $warning) || usage "critical threshold must be greater than or equal to the warning threshold";

$timeout =~ /^\d+$/                 || usage "timeout value must be a positive integer\n";
($timeout >= 1 && $timeout <= 60)   || usage "timeout value must be between 1 - 60 secs\n";

vlog "verbose mode on";
$SIG{ALRM} = sub {
    die "timed out after $timeout seconds\n";
};
vlog "setting timeout to $timeout secs\n";
alarm($timeout);


