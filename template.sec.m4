#
#  Author: Hari Sekhon
#  Date: 2010-10-13 10:06:16 +0100 (Wed, 13 Oct 2010)
#
#  vim:ts=4:sts=4:sw=4:et

type=Single
ptype=RegExp
pattern=(?i)REGEX
context=!NAME
continue=TakeNext
desc=$0
action=create NAME 300 ( report NAME /usr/bin/env mail -s "NAME" hari@domain.com )

type=Single
ptype=RegExp
pattern=(?i)REGEX
context=NAME
desc=$0
action=add NAME $0
