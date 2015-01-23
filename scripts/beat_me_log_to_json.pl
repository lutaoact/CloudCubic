use warnings;
use strict;

use JSON;
use Data::Dumper;
use Date::Calc qw/Today Add_Delta_Days/;
my ($year, $month, $day) = Add_Delta_Days(Today(), -1);
my $yesterday = sprintf '%4d-%02d-%2d', $year, $month, $day;

my $INPUT_FILE = "/data/log/budweiser.data.log-$yesterday";
my $OUTPUT_FILE = "/data/log/budweiser.data.log-$yesterday.json";

my $result = {};
open my $fh, '<', $INPUT_FILE or die $!;
while (my $line = <$fh>) {
  chomp $line;
  my ($type, $orgId, $userId) = (split /\t/, $line)[1, 2, 3];
  $result->{$orgId}->{$userId}->{$type}++;
}
#print Dumper $result;

#将$result以json的形式写入到指定文件中
write_file($OUTPUT_FILE, json_encode($result));

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}
