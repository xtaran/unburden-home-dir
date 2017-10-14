#!perl

use strict;
use warnings;

use Test::More;
use Test::Perl::Critic;
use File::Slurper qw(read_dir);

if ( $ENV{AUTOPKGTEST_TMP} || $ENV{ADTTMP} ) {
    critic_ok('/usr/bin/unburden-home-dir');
} else {
    # Main program
    all_critic_in_dir_ok(qw(bin));

    # Test suite helper and mockup libraries need different settings.
    Test::Perl::Critic->import(-profile =>
                               't/lib/.perlcriticrc-for-test-helpers');
    all_critic_in_dir_ok(qw(t/lib/Test));

    Test::Perl::Critic->import(-profile =>
                               't/lib/.perlcriticrc-for-mockup-libs');
    all_critic_in_dir_ok(glob('t/lib/mockup/*'));
}
done_testing();

# Test suite helper and mockup libraries need different
# settings. ("all_critic_ok()" can only be used once per run and fails
# if being used inside a subtest. See https://bugs.debian.org/795716
# and https://github.com/Perl-Critic/Test-Perl-Critic/issues/5
#
# So let's write a function which emulates the behaviour, but does
# neither call done_testing() nor dives into subdirectories. (The
# latter is just for simplicity because it's not needed here.)

sub all_critic_in_dir_ok {
    my @dirs = @_ or die "No directory passed to all_critic_in_dir_ok()";
    my @files = ();

    foreach my $dir (@dirs) {
        push(@files, map { "$dir/$_" } read_dir($dir));
    }

    foreach my $file (@files) {
        critic_ok($file);
    }
}
