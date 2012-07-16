use Getopt::Long;
use Digest;
use Pod::Usage;
our @hashes=keys %Digest::MMAP;
our %o;
GetOptions(\%o,
    'help' => sub {pod2usage(1)},
    'man|manual' => sub {pod2usage(-exitstatus => 0, -verbose => 2)},
    
    'dedup',
    'uniq|unique',

    'apply!'
) or pod2usage();
__END__
=pod

=head1 NAME

dedup - Find/Remove duplicate files/folders

=head1 SYNOPSIS

B<dedup> [B<options>] E<lt>B<folderA>E<gt> [B<folderB>]

 Options:
   --help Show a list of options
   --man[ual] Show the documentation
   
   --dedup (Default) Show/remove duplicates
   --uniq[ue] Show/copy unique files (from A to B, requires two folders)

   --noapply (Default) Report only, do not perform the actions
   --apply Perform the actions
   
   
=cut