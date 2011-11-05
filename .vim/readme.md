These files add Vim syntax highlighting and indenting support for the fantastic
[CoffeeScript language](http://coffeescript.org).

![Screenshot](http://gr.ayre.st/s/vim/coffee_script_syntax.png)

[Example (nodes.coffee from the coffeescript compiler)](http://gr.ayre.st/s/vim/coffeescript_example.html)

This is a heavyweight/opinionated syntax highlighting file. It's heavyweight in
that the only thing NOT colored is function calling and (most) property access.
It's opinionated because I slowly add syntax highlighting that helps me avoid
the errors I commonly make. I consider both of these pluses but some people
don't like it since it results in a visually busy screen.

Most importantly, this syntax file highlights assignment and full function
declarations.  Sounds minor, but the flip side to Coffeescript's elegant syntax
is that there's a significant difference between `toString "$@name:$@id`,
`toString: "$@name:$@id"` and `toString: -> "$@name:$@id"` even though there's
only a 4 character difference from first to last. Other examples are parens for
grouping (`foo ('bar')`) vs parens for function calls (`foo('bar')`) and
property access (`foo['bar']`) vs array literals (`foo ['bar']`).

In addition to the full coffeescript language, javascript globals/keywords/host
objects are highlighted. These are completely separted from the coffeescript
equivalents in the event you want to highlight them differently they can't be
used in identifiers while coffeescript ones can.

In addition, the cursor is automatically indented or outdented based on the
surrounding context. For example, hitting the return key after an `if` statement
will indent the cursor one `shiftwidth`; doing the same after certain `return`
statements -- ones without an attached `if` or `unless` statement, that is --
will instead outdent the cursor.

### Installation

If you want to be boring, grab the [tarball] and extract it in your `~/.vim` or
`~/vimfiles` directory like any other vim extension.

If you're feeling adventurous and on an OS that supports symlinks, you can
install it the way I install my plugins. Grab my [plugin installer] rakefile,
and put it in your `~/.vim` file, and then add `alias vim-install="rake -f
$HOME/.vim/rakefile-vim-install"` to your .rc file. From there, all you have to
do is clone a plugin repo, change to the directoy, and `vim-install` to symlink
everything into the proper location. I do this for all the plugins I have
installed, which allows me to keep everything up to date easily with `git
pull`s and to maintain my own (generally unrelased) patches through updates. It
also allows easy uninstalls: `vim-install uninstall`.

[tarball]: http://github.com/grayrest/vim-coffee-script/tarball/master
[plugin installer]: http://gr.ayre.st/s/vim/rakefile-vim-install
