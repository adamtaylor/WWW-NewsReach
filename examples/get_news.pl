#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use WWW::NewsReach;

my $nr = WWW::NewsReach->new({
    api_key => $ENV{NEWSREACH_API_KEY}
});

my $news = $nr->get_news;

# Loop through all the new datas and print the news, along with any photos,
# comments and categories associated.
foreach ( @{$news} ) {
    print "\n\n---- News Item ----\n\n";
    print 'Headline == ', $_->headline, "\n";
    print 'Text == ', $_->text, "\n";
    print 'State == ', $_->state, "\n";
    print 'Extract == ', $_->extract, "\n";

    my $photos = $_->photos;
    foreach ( @{$photos} ) {
        print "\n\n-- Photos --\n\n";
        print 'Caption == ', $_->caption, "\n";
        print 'Alt == ', $_->alt, "\n";
        print 'Orientation == ', $_->orientation, "\n";
    }
    my $comments = $_->comments;
    foreach ( @{$comments} ) {
        print "\n\n-- Comments --\n\n";
        print 'Text == ', $_->text, "\n";
        print 'Name == ', $_->name, "\n";
        print 'Location == ', $_->location, "\n";
    }
    my $categories = $_->categories;
    foreach ( @{$categories} ) {
        print "\n\n-- Categories --\n\n";
        print 'Name == ', $_->name, "\n";
    }

}


