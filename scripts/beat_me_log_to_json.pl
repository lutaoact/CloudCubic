use warnings;
use strict;

use JSON;
use Data::Dumper;
use Date::Calc qw/Today Add_Delta_Days/;

#命令行提供，格式yyyy-MM-DD
my $yesterday = $ARGV[0] || sprintf '%4d-%02d-%02d', Add_Delta_Days(Today(), -1);
print "process beat me log for $yesterday\n";

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
