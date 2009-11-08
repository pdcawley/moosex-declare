#!/usr/bin/perl -d

BEGIN {
    push @DB::typeahead, "c", "q";

    open my $out, ">", \my $out_buf;
    $DB::OUT = $out;
    open my $in, "<", \my $in_buf;
    $DB::IN = $in;
}

use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";
use Foo;
use Sub::Identify ':all';

is(sub_fullname(Foo->can($_)), 'Foo::'.$_, "Foo->can($_) is called Foo::$_") for qw(foo inner bar);


{
    use MooseX::Declare;

    role Bar {
        before do_foo {
            return;
        }
    }

    class YachtClub with Bar {
        method do_foo {
            return;
        }
    }

    class GolfClub with Bar {
        method do_foo {
            return;
        }
    }

    local $TODO=1;

    is(sub_fullname(YachtClub->can('do_foo')), 'Baz::do_foo');
    is(sub_fullname(YachtClub->can('do_foo')), 'Quux::do_foo');
}

done_testing;
