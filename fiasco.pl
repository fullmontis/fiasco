# FIASCO: a minimalistic, script based video editor using ffmpeg

use strict;
use warnings;

my $usage = "USAGE: fiasco.pl script output [quality]";
my $txt = $ARGV[0] or print $usage;
my $out = $ARGV[1] or print $usage;
my $quality = 'fast';

# Read content of script

my @content;
open( my $file,'<',$txt ) or die "cannot open file $txt";
while( <$file> ){
    # here magic happens
    my @line = ( $_ =~ m/(\S+.[A-Za-z]{2,4})\s+([0-9]+(?::[0-9]{2}:[0-9]{2}(?:\.[0-9]{3})?)?)\s+([0-9]+(?::[0-9]{2}:[0-9]{2}(?:\.[0-9]{3})?)?)\s*/g); 
    push(@content,\@line);
    print for @line;
}
close($file);

# start joining files
my $first = 1;
my $outtemp = 'AAA_tempout1';
my $ext = '.ts';
my $options = '-vcodec mpeg2video -acodec mp2 -f mpegts';
$options .= ' -s 320x240' if $quality eq 'fast';
my $vt1 = 'AAA_temp1';
my $vt2 = 'AAA_temp2';

foreach(@content) {
    my ($source,$t1,$t2) = @{$_};

    if( $outtemp eq 'AAA_tempout1' ){
	$outtemp = 'AAA_tempout2';
    } else {
	$outtemp = 'AAA_tempout1';
    }

    if( $first == 1 ) {
	system("ffmpeg -y -i \"$source\" -ss $t1 -to $t2 $options \"$vt1$ext\"");	
    } else {
    	system("ffmpeg -y -i \"$source\" -ss $t1 -to $t2 $options \"$vt2$ext\"");
    	system("ffmpeg -y -i concat:\"$vt1$ext|$vt2$ext\" -codec copy \"$outtemp$ext\"");
    	$vt1 = $outtemp;
    } 
    
    $first = 0;

    # sleep 200 ms to avoid forking weird side effects
    select(undef, undef, undef, 0.2);
}

# rename output and delete temp files
rename("$outtemp$ext","$out$ext");
unlink glob "AAA_temp*$ext";

# my @files = ( $content =~ m/([a-zA-Z0-9]+\.[A-Za-z]{2,4})\s+([0-9]+(?::[0-9]{2}:[0-9]{2})?)\s+([0-9]+(?::[0-9]{2}:[0-9]{2})?)\s*/g);
# foreach (@files) {
#     my $video = $_;
#     my $t1 = shift(@files);
#     my $t2 = shift(@files);    
#     print "$video $t1 $t2";
# }



# if( $type eq "join" ) {
#     system("ffmpeg -y -ss 00:00:20 -i $video -t 00:00:02 $v1");
#     system("ffmpeg -y -ss 00:00:40 -i $video -t 00:00:02 $v2"); 
#     system("ffmpeg -y -i $v1 -i $v2 -filter_complex \"[0:0] [0:1] [1:0] [1:1] \
# concat=n=2:v=1:a=1 [v] [a]\" -map \"[v]\" -map \"[a]\" $out");
# } 
# if( $type eq "joinm" ) {
#     system("ffmpeg -y -ss 20 -i $video -vcodec mpeg2video -b:v 5000k -acodec mp2 \
# -t 3 -f mpegts $v1m");
#     system("ffmpeg -y -ss 30 -i $video -vcodec mpeg2video -b:v 5000k -acodec mp2 \
# -t 3 -f mpegts $v2m");
#     system("ffmpeg -y -i concat:\"$v1m|$v2m\" -codec copy $out");
# }
# if( $type eq "zoom" ) {
#     system("ffmpeg -y -i $video -vf \"scale=n*iw:-1, crop=1920:1080\" $out");
# }
# if( $type eq "fade" ) {
#     system("ffmpeg -y -i $video -vf \"fade=in:0:200\" $out");
# }
# if( $type eq "avi" ) {
#     system("ffmpeg -y -ss 20 -i $video -vcodec huffyuv -acodec mp2 \
# -t 3 $v1a");
#     system("ffmpeg -y -ss 30 -i $video -vcodec huffyuv -acodec mp2 \
# -t 3 $v2a");
#     system("ffmpeg -y -i concat:\"$v1a|$v2a\" -codec copy $out");    
# }
# if( $type eq "joinmtime" ) {
#     system("ffmpeg -y -i $video -ss 20 -to 25 -vcodec mpeg2video -b:v 5000k -acodec mp2 -f mpegts $v1m");
#     system("ffmpeg -y -i $video -ss 30 -to 35 -vcodec mpeg2video -b:v 5000k -acodec mp2 -f mpegts $v2m");
#     system("ffmpeg -y -i concat:\"$v1m|$v2m\" -codec copy $out");
# }
