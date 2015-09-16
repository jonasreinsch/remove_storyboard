#!/usr/bin/env perl
use perl5i::2;

# this removes the storyboard reference from the pbxproj file



my $contents = do {
    local $/;
    <>
};

$contents =~ s<^       # beginning of line (therefore we use the m-modifier)
               (       # start group
               [^\n]*? # match some characters in the same line (don't use dot here because
                       # it will also match newlines because of the /s modifier)
               Main\.storyboard
               [^\n]*  # non-newline characters (see above)
               {\s*\n  # opening brace that is the last non-whitespace character in a line
               .*?     # some characters, possibly spread over multiple lines (/s modifier)
               };\s*\n # and a closing brace
               )       # end group
               ><>smx;

$contents =~ s<^.*?(Main\.storyboard.*?[\n])><>gm;

print $contents;
