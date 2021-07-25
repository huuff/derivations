* Due to the nature of flakes, in order to check my changes I have to commit, push, and then pull in my config. This is causing me great pain, so I should look into testing.
* blesh gives a weird error about readlink, see if I can solve it
* Too much repetition in my systemd modules (auto-rsync, do-on-request)

## st
* config option for font

## autocutsel
* Synchronize only clipboard to primary selection because the other way around feels like hell. Or will it be useless then? UPDATE: Using autocutsel in this way is pure hell. Check out these links
  * [This offers some insight into why synchronizing clipboard and primary is a bad idea](https://specifications.freedesktop.org/clipboards-spec/clipboards-latest.txt)
  * [This is a long explanation into getting it to work in a nice way for my very specific use-case](https://www.seanh.cc/2020/12/27/copy-and-paste-in-tmux/)

