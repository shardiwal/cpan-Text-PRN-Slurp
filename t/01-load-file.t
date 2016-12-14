#!perl -T
use 5.006;
use strict;
use warnings;

use lib 'lib';

use Test::Most tests => 5;
use Test::Warn;
use Text::CSV::Slurp;

BEGIN {
    use_ok( 'Text::PRN::Slurp' ) || print "Bail out!\n";
}

my $object = Text::PRN::Slurp->new ();
isa_ok ($object, 'Text::PRN::Slurp');

{
    my $slurp = Text::PRN::Slurp->new->load(
        'file' => 't/data/sample_2.prn',
        'file_headers' => [ q{ID}, q{Type}, q{Description} ]
    );

    is_deeply(
        $slurp,
        [
            {
                'Description' => 'Active Serve',
                'ID' => '1',
                'Type' => 'ASP'
            },
            {
                'Type' => 'JSP',
                'ID' => '2',
                'Description' => 'JavaServer P'
            },
            {
                'Type' => 'PNG',
                'ID' => '3',
                'Description' => 'Portable Net'
            },
            {
                'Type' => 'GIF',
                'ID' => '4',
                'Description' => 'Graphics Int'
            },
            {
                'Type' => 'WMV',
                'Description' => 'Windows Medi',
                'ID' => '5'
            }
        ],
        "PRN file parsed correctly"
    );
}

# With extra column
{
    my $slurp;
    warning_is {
        $slurp = Text::PRN::Slurp->new->load(
            'file' => 't/data/sample_2.prn',
            'file_headers' => [ q{ID}, q{Type}, q{Description}, q{JAI} ]
        );
    }
    "Columns doesn't seems to be matching",
    'warning when extra colum supplied';

    is_deeply(
        $slurp,
        [
            {
                'Description' => 'Active Serve',
                'ID' => '1',
                'Type' => 'ASP',
                'JAI' => ''
            },
            {
                'Type' => 'JSP',
                'ID' => '2',
                'Description' => 'JavaServer P',
                'JAI' => ''
            },
            {
                'Type' => 'PNG',
                'ID' => '3',
                'Description' => 'Portable Net',
                'JAI' => ''
            },
            {
                'Type' => 'GIF',
                'ID' => '4',
                'Description' => 'Graphics Int',
                'JAI' => ''
            },
            {
                'Type' => 'WMV',
                'Description' => 'Windows Medi',
                'ID' => '5',
                'JAI' => ''
            }
        ],
        "PRN file parsed correctly"
    );
}
