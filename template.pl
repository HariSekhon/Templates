#!/usr/bin/perl -T
#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2013-12-30 11:20:28 +0000 (Mon, 30 Dec 2013) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

$DESCRIPTION = ""; # TODO

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
