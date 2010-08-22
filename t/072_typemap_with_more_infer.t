#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Bread::Board');
}

{
    package My::Bar;
    use Moose;

    package My::Foo;
    use Moose;

    has 'bar' => (
        is       => 'ro',
        isa      => 'My::Bar',
        required => 1,
    );
}

# don't give infer enough information
# and make it figure it out for itself
# including inferring the embedded object
{
    my $c = container 'MyTestContainer' => as {
        typemap 'My::Foo' => infer();
    };

    {
        my $foo = $c->resolve( service => 'My::Foo::__AUTO__' );
        isa_ok($foo, 'My::Foo');
        isa_ok($foo->bar, 'My::Bar');

        my $bar = $c->resolve( service => 'My::Bar::__AUTO__' );
        isa_ok($bar, 'My::Bar');
    }
    {
        my $foo = $c->resolve( type => 'My::Foo' );
        isa_ok($foo, 'My::Foo');
        isa_ok($foo->bar, 'My::Bar');
    }
}

done_testing;

