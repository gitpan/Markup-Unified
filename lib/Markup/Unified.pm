package Markup::Unified;

use Moose;
use overload	(	'fallback' => 1,
			'""'  => 'formatted',
		);

use Text::Textile;
use Text::Markdown;
use HTML::BBCode;

=head1 NAME

Markup::Unified - A simple, unified interface for Textile, Markdown and BBCode.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

has 'value' => (is => 'rw', isa => 'Str');	# original, unformatted value
has 'fvalue' => (is => 'rw', isa => 'Str');	# formatted value

our $m = Text::Markdown->new();
our $t = Text::Textile->new();
our $b = HTML::BBCode->new({ stripscripts => 1, linebreaks => 1 });

# set Textile to unicode
$t->charset('utf-8');

=head1 SYNOPSIS

    use Markup::Unified;

    my $o = Markup::Unified->new();
    my $text = 'h1. A heading';
    $o->format($text, 'textile');

    print $o->formatted; # produces "<h1>A heading</h1>"
    print $o->unformatted; # produces "h1. A heading"

    # you can also just say:
    print $o; # same as "print $o->formatted;"

=head1 DESCRIPTION

This module provides a simple, unified interface for the L<Text::Textile>,
L<Text::Markdown> and L<HTML::BBCode> markup languages modules. This module is
primarily meant to provide a simple way for application developers to deal
with texts that use different markup languages, for example, a message
board where users have the ability to post with their preferred markup language.

Please note that this module expects your texts to be UTF-8.

=head1 METHODS

=head2 format( $text, $markup_lang )

Formats the provided text with the provided markup language.
C<$markup_lang> must be one of 'bbcode', 'textile' or 'markdown' (case
insensitive); otherwise the text will remain unprocessed.

=cut

sub format {
	my ($self, $text, $markup_lang) = @_;

	$self->value($text); # keep unformatted text

	# format according to the formatter
	if ($markup_lang =~ m/^bbcode/i) {
		$self->fvalue($self->_bbcode($text));
	} elsif ($markup_lang =~ m/^textile/i) {
		$self->fvalue($self->_textile($text));
	} elsif ($markup_lang =~ m/^markdown/i) {
		$self->fvalue($self->_markdown($text));
	} else {
		# either no markup language given or unrecognized language
		# so formatted = unformatted
		$self->fvalue($text);
	}

	return $self;
}

=head2 formatted()

Returns the formatted text of the object, with whatever markup language
it was set.

This module also provides the ability to print the formatted version of
an object without calling C<formatted()> explicitly, so you can just use
C<print $obj>.

=cut

sub formatted { $_[0]->fvalue; }

=head2 unformatted()

Returns the unformatted text of the object.

=cut

sub unformatted { $_[0]->value; }

=head1 INTERNAL METHODS

=head2 _bbcode( $text )

Formats C<$text> with L<HTML::BBCode>.

=cut

sub _bbcode {
	my ($self, $text) = @_;

	return $b->parse($text);
}

=head2 _textile( $text )

Formats C<$text> with L<Text::Textile>.

=cut

sub _textile {
	my ($self, $text) = @_;

	return $t->textile($text);
}

=head2 _markdown( $text )

Formats C<$text> with L<Text::Markdown>.

=cut

sub _markdown {
	my ($self, $text) = @_;

	return $m->markdown($text);
}

=head1 AUTHOR

Ido Perlmuter, C<< <ido at fc-bnei-yehuda.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-markup-unified at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Markup-Unified>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Markup::Unified

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Markup-Unified>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Markup-Unified>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Markup-Unified>

=item * Search CPAN

L<http://search.cpan.org/dist/Markup-Unified/>

=back

=head1 SEE ALSO

L<Text::Textile>, L<Text::Markdown>, L<HTML::BBCode>, L<DBIx::Class::InflateColumn::Markup::Unified>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Ido Perlmuter.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1; # End of Markup::Unified
