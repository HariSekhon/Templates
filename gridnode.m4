divert(-1)
#
#   Author: Hari Sekhon
#   Date: 2009-12-11 10:06:14 +0000 (Fri, 11 Dec 2009)
#
#  REQUIRES GNU M4 FOR PROPER OPERATION
divert(0)dnl
ifdef(NUM,,)
define host{
        use                     hadoop-host

        host_name               gridNUM-dc1
        alias                   Hadoop Grid Node NUM DC1
        address                 IP
}
