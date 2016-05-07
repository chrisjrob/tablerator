#!/usr/bin/perl
#
# times-tables.pl

# Copyright (C) 2016 Christopher Roberts
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

# User variables

use constant BLANK => '__';

my $file  = 'tables.md';
my $tables = 10;
my $owl   = {
    'bronze'    => 1,
    'silver'    => 0,
    'gold'      => 0
};

# End of user variables

create_tables($file, $tables, $owl);

regenerate_pdf($file);

exit;

sub regenerate_pdf {
    my $pdf = $file;
    $pdf =~ s/\.md/.pdf/;
    `pandoc $file -o $pdf`;
}

sub create_tables {
    my $file    = shift;
    my $tables  = shift;
    my $owl     = shift;

    my ($i, $t, $rands);

    # Define format

    format TABLES_TOP =
| No. | Question | Answer | No. | Question | Answer | No. | Question | Answer |
|----:+---------:+:-------+----:+---------:+:-------+----:+---------:+:-------|
.

    format TABLES =
| @>> | @>>>>>>>>>>>>>>>>>>>> = | @<<<<<<<<<<<< | @>> | @>>>>>>>>>>>>>>>>>>>> = | @<<<<<<<<<<<< | @>> | @>>>>>>>>>>>>>>>>>>>> = | @<<<<<<<<<<<< |
$i+1, $rands->[$i]{question}, $rands->[$i]{answer}, $i+2, $rands->[$i+1]{question}, $rands->[$i+1]{answer}, $i+3, $rands->[$i+2]{question}, $rands->[$i+2]{answer}
.

    select TABLES;
   
    # Remove line feed at start of format
    $^L = '';


    # Create tables

    open(TABLES, '>', $file) or die "Cannot write to $file: $!";

    print TABLES "# THE TABLERATOR\n\n";

    for ($t=1; $t<=$tables; $t++) {
        $rands = &getrands($owl);

        print TABLES "## Table $t\n\n";

        for($i=0;$i<60;$i+=3) {
            write TABLES; 
        }

        # Finish the format
        $- = 0;

        print TABLES "\n\nTime Taken: ______\n\n";
        print TABLES "**Answers:** ";

        for($i=0;$i<60;$i++) {
            print TABLES $i+1 . '=' . $rands->[$i]{reveal} . ' ';
        }
        print TABLES "\n\n\\newpage\n\n";
        
    }

    close(TABLES) or die "Cannot close $file: $!";
}

sub getrands {
    my $owl     = shift;

    my @opts;
    foreach my $opt (qw(bronze silver gold)) {
        if ($owl->{$opt} == 1) {
            push(@opts, $opt);
        }
    }

    my $count = @opts;

    my ($rands, $uniq);
    for(my $i=0; $i<60; $i++) {
        my $temp;
        {
            my $opt = getrand(1,$count);
            $opt--;
            $temp = getqa( $opts[$opt] );

            if (defined $uniq->{ $temp->{question} }{ $temp->{answer} } ) {
                redo;
            }
        }

        $uniq->{ $temp->{question} }{ $temp->{answer} } = 1;
        $rands->[$i] = $temp;
    }

    return $rands;
}

sub getqa {
    my $opt = shift;

    my $qa;
    if ($opt eq 'bronze') {
        $qa = getbronze();
    } elsif ($opt eq 'silver') {
        $qa = getsilver();
    } elsif ($opt eq 'gold') {
        $qa = getgold();
    }

    return $qa;
}

sub getbronze {

    my $x = getrand(1,12);
    my $y = getrand(1,12);
    my $z = getrand(1,12);

    my $qa = { 'question' => $x . ' x ' . $y, 'answer' => BLANK, 'reveal' => $x * $y };

    return $qa;

}

sub getsilver {
 
    my $x   = getrand(1,12);
    my $y   = getrand(1,12);
    my $z   = getrand(1,12);
    my $opt = getrand(0,1);

    my $qa = [
        { 'question' => BLANK . ' x ' . $y, 'answer' => $x * $y, 'reveal' => $x * $y },
        { 'question' => $x . ' x ' . BLANK, 'answer' => $x * $y, 'reveal' => $x * $y }
    ];

    return $qa->[$opt];

}

sub getgold{
 
    my $x   = getrand(1,12);
    my $y   = getrand(1,12);
    my $z   = getrand(1,12);
    my $opt = getrand(0,3);

    my $qa = [
        { 'question' => $x * $y . ' ÷ ' . BLANK, 'answer' => $x, 'reveal' => $y },
        { 'question' => $x * $y . ' ÷ ' . BLANK, 'answer' => '$\sqrt{' . $x**2 . '}$', 'reveal' => $y },
        { 'question' => $x . '\textsuperscript{2}', 'answer' => BLANK, 'reveal' => $x**2 },
        { 'question' => $x * $y . ' ÷ ' . $y, 'answer' => $z + $x . ' -- ' . BLANK, 'reveal' => $z },
    ];

    return $qa->[$opt];

}

sub getrand {
    my $min     = shift;
    my $max     = shift;

    if ($min == 1) {
        $max--;
    }

    my $rand    = rand($max);

    my $rounded = sprintf("%.0f", $rand);

    if ($min == 1) {
        $rand++;
    }

    return $rounded;
}

