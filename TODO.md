* blesh gives a weird error about readlink, see if I can solve it
* Too much repetition in my systemd modules (auto-rsync, do-on-request, neuron-module)
* use camelCase for property names instead of kebab-case

## st
* solarized requires another patch before applying it, look into it before implementing it.
* implement something to increase the scroll speed (there are some patches)
* config option for font

## do-on-request
* Use libressl for nc instead of busybox

## autocutsel
* Synchronize only clipboard to primary selection because the other way around feels like hell. Or will it be useless then?
