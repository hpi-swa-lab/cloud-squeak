# A Minification Script for Squeak

> Note: only tested on Linux and WSL.

> Note: /!\ WIP: still contains some hardcoded paths you will have to adapt.

Clone and load via the Git Browser. Run `REPLCleaner save` and it will produce an image called aws-final.image and open a telnet connection on port 8080, to which you can connect to via `telnet localhost 8080`.

### Know Issues

* If you do not connect to telnet within 60s, the image will start spamming "ConnectionTimedOut" errors. Probably due to some process we accidentally killed.

### Credits

The telnet client for squeak is adapted from http://github.com/hpi-swa-teaching/squeak-repl and adjusted slightly to depend on fewer packages.
