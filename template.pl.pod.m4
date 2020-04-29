divert(-1)
#
#  Author: Hari Sekhon
#  Date: 2011-05-06 11:24:02 +0100 (Fri, 06 May 2011)
#
#  vim:ts=4:sts=4:sw=4:et

changequote(`,')
divert(0)
__END__

=head1 `NAME'

NAME - <put a description here>

=head1 SYNOPSIS

NAME [ options ]

 Options:
   -v, --verbose      print debug output, disable timeout
   -?, -h, --usage    print the short help page
       --help         print the full help page
       --man          print the extended man page

=head1 OPTIONS

=over 8

=item B<-v>, B<--verbose>

Enable debugging. Also turn off the timeout, so that the script will run longer
than the default of 10 seconds. Note that this may lock up your console if
checking files that are on NFS, for example, but will enable you to identify
the flaw, one hopes.

=item B<--usage> (or, indeed, any option that isn't recognised)

Print a brief help message and exit.

=item B<--help>

Print a more detailed message (ie, the synopsis and options from the man page)
and exit.

=item B<--man>

Print the full man page, and exit.

=back

=head1 DESCRIPTION

B<This program> does what it says on the tin

=head1 BUGS

None known. Email me if you find any at the address below
=cut
