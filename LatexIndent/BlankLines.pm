package LatexIndent::BlankLines;
use strict;
use warnings;
use Exporter qw/import/;
our @EXPORT_OK = qw/protect_blank_lines unprotect_blank_lines condense_blank_lines/;

sub protect_blank_lines{
    my $self = shift;
    return unless ${%{$self}{switches}}{modifyLineBreaks};
    unless(${${${$self}{settings}}{modifyLineBreaks}}{preserveBlankLines}){
        $self->logger("Blank lines will not be protected (preserveBlankLines=0)",'heading.trace');
        return
    }

    $self->logger("Protecting blank lines (see preserveBlankLines)",'heading.trace');
    ${$self}{body} =~ s/^(\h*)?\R/latex-indent-blank-line\n/mg;
    return;
}

sub condense_blank_lines{
    my $self = shift;
    return unless ${%{$self}{switches}}{modifyLineBreaks};
    return unless ${${${$self}{settings}}{modifyLineBreaks}}{condenseMultipleBlankLinesInto}>0;
    my $condenseMultipleBlankLinesInto = ${${${$self}{settings}}{modifyLineBreaks}}{condenseMultipleBlankLinesInto};
    $self->logger("Condensing multiple blank lines into $condenseMultipleBlankLinesInto (see condenseMultipleBlankLinesInto)",'heading.trace');
    my $replacementToken = "latex-indent-blank-line";
    for (my $i=1; $i<$condenseMultipleBlankLinesInto; $i++ ){
        $replacementToken .= "\nlatex-indent-blank-line";
    }

    $self->logger("blank line replacement token: $replacementToken",'ttrace');
    # need to return to this
    # need to return to this
    # need to return to this
    #while(${$self}{body} =~ m/latex-indent-blank-line\h*\R*\h*latex-indent-blank-line/){
    #    ${$self}{body} =~ s/latex-indent-blank-line\h*\R*\h*latex-indent-blank-line/$replacementToken/mgs;
    #}
    ${$self}{body} =~ s/(latex-indent-blank-line\h*\R*\h*){1,}latex-indent-blank-line$/$replacementToken/mgs;
    $self->logger("body now looks like ${$self}{body}",'ttrace');
    return;
}

sub unprotect_blank_lines{
    my $self = shift;
    return unless ${%{$self}{switches}}{modifyLineBreaks};
    return unless ${${${$self}{settings}}{modifyLineBreaks}}{preserveBlankLines};

    $self->logger("Unprotecting blank lines (see preserveBlankLines)",'heading.trace');

    # need to return to this
    # need to return to this
    # need to return to this
    # loop through the body, looking for the blank line token
    while(${$self}{body} =~ m/latex-indent-blank-line/m){
        # when the blank line token occupies the whole line
        #while(${$self}{body} =~ m/^\h*?latex-indent-blank-line$/m){
        #    ${$self}{body} =~ s/^\h*?latex-indent-blank-line$//m;
        #}
        ${$self}{body} =~ s/^\h*latex-indent-blank-line$//mg;
        # otherwise the blank line has been deleted, so we compensate with an extra
        ${$self}{body} =~ s/(^\h*)?latex-indent-blank-line/$1?$1:"\n"/me;
    }
    $self->logger("body now looks like ${$self}{body}",'ttrace');
}

1;
