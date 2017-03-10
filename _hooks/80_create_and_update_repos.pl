#!/usr/bin/env perl
#
#  written by maximilian-huber.de

use strict;
use warnings;
use File::Basename qw( dirname );
use Cwd qw( abs_path );
use File::Path qw( make_path );
use Term::ANSIColor qw( colored );

my %toLink = (
    'https://github.com/syl20bnr/spacemacs'                => '~/.emacs.d',
    # 'https://github.com/AndreaCrotti/yasnippet-snippets'   => '~/.emacs.d/snippets',
    # 'https://github.com/jwiegley/use-package'              => '~/.emacs.d/use-package',
    'https://github.com/jrosdahl/maildirproc'              => '~/Mail/maildirproc'
    );
    # 'https://github.com/monky-hs/monky'                    => '~/.xmonad/monky',
    # 'https://github.com/zsh-users/zsh-syntax-highlighting' => '~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting',

while ( my ($url, $target) = each(%toLink) ) {
    print "update: @{[colored(['bold green'], $target,'')]}\n";
    $target = (glob($target))[0];
    if ( -d dirname($target) ){
        if ( !-d $target ){
            system("git","clone",$url,$target);
        }else{
            chdir($target);
            system("git","pull");
        }
    }else{
        print "the parent directory of $target does not exist";
    }
}
