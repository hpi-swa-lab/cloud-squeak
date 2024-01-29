# A Minification Script for Squeak

> Note: only tested on Linux and WSL.

> Note: /!\ WIP: still contains some hardcoded paths you will have to adapt.

## Installation

Dependencies:

```smalltalk
"Install FileTree"
Metacello new
	baseline: 'FileTree';
	repository: 'github://dalehenrich/filetree:squeak4.3/repository';
	load.

"Install OSProcess"
Installer ss project: 'OSProcess'; install: 'OSProcess'.
```

Cleaner:

Clone and load via the Git Browser.  
-OR-  
Clone from the command line and load using FileTree:
```smalltalk
repo := MCFileTreeRepository directory: (FileDirectory on: '/path/to/cloud-squeak/src').
repo allVersionNames do: [:name | (repo versionNamed: name) load].
```

## Usage

### Preparation (optional)

- Update the hardcoded file paths in `REPLCleaner` (Cmd + Shift + E on `/`...)

- Consider installing updates to the image.

- Install any additional packages you want to keep.

  After installation, edit `REPLCleaner class>>#keepList` to include the packages you want to keep.

- Change the start-up behavior at the bottom of `REPLCleaner class>>#cleanupImage`.

### Run the cleaner

```
REPLCleaner
	wsl: false; "set to true if running on bare Windows when you want to use WSL. set to false if running on Linux or WSL."
	writeSpaceTally: false;
	save
```

This will produce an image called `aws-final.image` and open a telnet connection on port 8080, to which you can connect to via `telnet localhost 8080`.

### Preen the image (optional, removes ~50MB of unused VM objects)

Open a VMMaker image and run the following:

```
SpurImagePreener new preenImage: '/path/to/aws-final.image'.
```

## Know Issues

* If you do not connect to telnet within 60s, the image will start spamming "ConnectionTimedOut" errors. Probably due to some process we accidentally killed.

## Credits

The telnet client for squeak is adapted from http://github.com/hpi-swa-teaching/squeak-repl and adjusted slightly to depend on fewer packages.

The message send recorder for creating detailed space tallies is adapted from https://github.com/hpi-swa/MessageSendRecorder.
