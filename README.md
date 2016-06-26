# RubyChess

![RubyChess screenshot](http://res.cloudinary.com/buttertron22/image/upload/v1466981139/RubyChess_tqplda.png "RubyChess")

## Summary

RubyChess is chess written in Ruby and playable in the terminal. I built this
project as an exercise in object-oriented design.

* Sensitive destination display highlights potential moves for cursored piece.
* Deep duplication of board pieces explores entire movespace to determine
    Check and Checkmate status.
* Sliding pieces (Queen, Bishop, Rook) and Stepping pieces (King, Knight)
    inherit from common SlidablePiece and SteppablePiece classes.

## How to use

#### Ruby installation

To run RubyChess on your local machine, you need Ruby. For OS X systems, you
can prepare to install Ruby by doing the following:

* Install XCode
    * Search and install XCode from the App Store.
* Install Apple Command Line Tools
    * Open XCode (this just needs to run once to initialize it) and close it.
    * Install XCode command line tools by running `xcode-select --install` in
    the terminal.
* Install [Homebrew][homebrew]
    * Run `brew update` to make sure all your formulas are current
* Install git:
    * In the terminal, run `brew install git`.
* Install the readline library:
    * In the terminal, run `brew install readline`.
* Install OpenSSL:
    * In the terminal, run `brew install openssl`

Now we can start install rbenv, a Ruby version manager. Follow the instructions
[here][rbenv-install-osx]. After that, add
`if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi` to your
`~/.bash_profile` to make sure rbenv hooks into your shell.

To finally install Ruby, close your terminal window and open a new one. Install
Ruby using `CONFIGURE_OPTS="--disable-install-rdoc" rbenv install 2.1.2 -v`. You
could use any version, but I used 2.1.2 for this.

Next, specify which Ruby is used by default with `rbenv global 2.1.2`.

Confirm that Ruby was installed properly by using `which ruby`. You should see
`/Users/username/.rbenv/shims/ruby`. You don't want to see `/usr/bin/ruby`.

Install bundler with `gem install bundler` to let you install bundled gems.

#### Fetch and play the game

In the terminal, clone into this repo using `git clone git@github.com:fndelacruz/RubyChess`.

`cd` into the RubyChess folder. Run `bundle install` to install the associated
gems.

Run `ruby game.rb` to start the game. Use the arrow keys to move the cursor and
spacebar to toggle piece selection and move destination. Enjoy RubyChess!

[homebrew]: http://brew.sh/
[rbenv-install-osx]: https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x
