use Getopt::Long;
use Digest;
use Pod::Usage;
our %ht=qw(
crc16 CRC-16
crc32 CRC-32
ripemd RIPEMD-160
ripemd160 RIPEMD-160
md5 MD5
sha SHA-1
sha1 SHA-1
sha224 SHA-224
sha256 SHA-256
sha384 SHA-384
sha512 SHA-512
);
our %o;
$o{'collapse'}=1;
$o{'dedup'}=1;
$o{'prune-size'}=1;
$o{'hash'}='md5';
$o{'quiet'}=2;
$o{'hash-fixed'}='64k';
$o{'hash-dyna'}=-1;
$o{'hash-blocks'}=1;
GetOptions(\%o,
    'help' => sub {pod2usage(1)},
    'man|manual' => sub {pod2usage(-exitstatus => 0, -verbose => 2)},
    
    'dedup' => sub {$o{'uniq'}=0;$o{'dedup'}=1},
    'uniq|unique' => sub {$o{'dedup'}=0;$o{'uniq'}=1},

    'ignore=s@',
    'ignore-re=s@',

    'apply|a!' => sub {
        $o{'apply'}=$_[1];
        if (!$_[1]) {$o{'quiet'}=0 if $o{'quiet'}==2;}
    },
    'quiet|q' => sub {$o{'quiet'}=1;$o{'fatal'}=0},
    'fatal|f' => sub {$o{'quiet'}=0;$o{'fatal'}=1},
    'interactive|i' => sub {$o{'quiet'}=0;$o{'fatal'}=0;},
    
    'collapse!',
    'fuzzy-coll=i',
    'fuzzy-coll-a=i',
    'fuzzy-coll-b=i',
    
    'prune-size!',
    
    'hash=s',
    
    'hash-fixed:s',
    'hash-fixed-offset=s',
    
    'hash-dyna:f',
    'hash-dyna-minsize=s',
    'hash-dyna-maxsize=s',
    
    'hash-blocks=i',
    'hash-block-skip=f',
    
    'prefer-7bit'
) or pod2usage();
$o{$_}=h2n($o{$_}) foreach qw(hash-fixed hash-fixed-offset hash-dyna-minsize hash-dyna-maxsize);
if ($o{'hash-dyna'}==0) {$o{'hash-dyna'}=5}
if (!$ht{$o{'hash'}}) {pod2usage()}

our 

if (-f $ARGV[0] && -r $ARGV[0]) { #Report
    
}

sub h2n {
    my ($str)=@_;
    $str=~/^([0-9.,]+)([kmgtp]?)/i;
    my @suffix=('',qw(k m g t p));
    my $n=$1;
    my $pf=$2;
    while ($pf ne $suffix[0]) {
        shift @postfix;
        $n*=1024;
        }
    return $n;
}

__END__
=pod

=head1 NAME

dedup - Find/Remove duplicate files/folders

=head1 SYNOPSIS

B<dedup> [B<options>] [B<folderA>] [B<folderB>]

B<dedup> [B<options>] E<lt>B<report>E<gt> [B<folderA>] [B<folderB>]

 Options:
   --help Show a list of options
   --man[ual] Show the documentation
   
   --dedup (Default) Show/remove duplicates
   --uniq[ue] Show/copy unique files (from A to B, requires two folders)

   --noapply (Default) Report only, do not perform the actions.
   --a[pply] Perform the actions, if a report is given, will use any answers provided in the report. The user will be queried on any ambiguity
   --q[uiet] (Default if --noapply) If an ambiguity arises, the item is skipped instead of querying the user.
   --i[nteractive] (Default if --apply) Opposite of --quiet and --fatal
   --f[atal] If an ambiguity arises, stop
   
   --ignore=s Wildcard ignore, applies to filenames, can be used multiple times
   --ignore-re=s Regexp ignore, applies to filenames, can be used multiple times
   
   --nocollapse
   --collapse (Default) Show duplicate folders as folders instead of listing all files

   --fuzzy-coll=i (Default 0) Ignore up to N differences between folders when collapsing
   --fuzzy-coll-a=i (Default 0) Ignore up to N files only in A when collapsing
   --fuzzy-coll-b=i (Default 0) Ignore up to N files only in B when collapsing
   
   --noprune-size
   --prune-size (Default) Assume files with different sizes are different - can cause problems with broken filesystems
   
   --hash=s (Default MD5) Cryptographic hash, one of crc{16,32}, ripemd, sha{,1,224,256,512}
   
   --hash-fixed[=s] (Default 64K) Size, in bytes, of the segment to hash (1K = 1024)
   --hash-fixed-offset=s (Default 0) Offset of the fixed segment (1K = 1024), if the segment goes beyond the end of the file, it will be shifted back to fit
   
   --hash-dyna[=f] (Default 5 but disabled) Percentage of the filesize to hash
   --hash-dyna-minsize=s (Default 8K) Minimum size of dynamic hash segment, if file is smaller than this, whole file is hashed
   --hash-dyna-maxsize=s (Default 1M) Maximum size of dynamic hash segment
   
   --hash-blocks=i (Disabled by default) Hash N segments of the file, each segment is size/N bytes
   --hash-block-skip=f (Default 1) Multiplier for skip size
   
   --prefer-7bit In a conflict between two items, one of which has high-bit characters, prefer the other one
=cut