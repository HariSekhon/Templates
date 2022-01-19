#
#  Author: Hari Sekhon
#  Date: [% DATE # 2013-11-03 04:03:58 +0000 (Sun, 03 Nov 2013) %]
#
#  [% VIM_TAGS %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

package [% NAME %];

$VERSION = "0.1";

use strict;
use warnings;
BEGIN {
    use File::Basename;
    use lib dirname(__FILE__) . "/..";
}
use HariSekhonUtils;
use Carp;

use Exporter;
our @ISA = qw(Exporter);

our @EXPORT = ( qw (
                )
);
our @EXPORT_OK = ( @EXPORT );

1;
