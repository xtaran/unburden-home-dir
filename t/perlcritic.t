#!perl

use Test::Perl::Critic;

if ( $ENV{AUTOPKGTEST_TMP} || $ENV{ADTTMP} ) {
    critic_ok('/usr/bin/unburden-home-dir');
} else {
    all_critic_ok(qw(bin t/lib));
}
