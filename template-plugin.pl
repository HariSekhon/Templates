#!/usr/bin/perl -T
# nagios: -epn
# [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2011-05-05 16:46:58 +0100 (Thu, 05 May 2011) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

$DESCRIPTION = "Nagios Plugin"; # TODO

$VERSION = "0.1";

use strict;
use warnings;
BEGIN {
    use File::Basename;
    use lib dirname(__FILE__) . "/lib";
}
use HariSekhonUtils;

set_port_default(80);
set_threshold_defaults(80, 90);

env_creds("[% NAME %]");

%options = (
    %hostoptions,
    %useroptions,
    %thresholdoptions,
);
splice @usage_order, 6, 0, qw//;

get_options();

$host       = validate_host($host);
$port       = validate_port($port);
$user       = validate_user($user);
$password   = validate_password($password) if $password;
validate_thresholds();

vlog2;
set_timeout();

$status = "OK";



quit $status, $msg;
