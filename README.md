# My Mac Cleaner

This is a work-in-progress script (or set of scripts) that aims to clean up 
various first and third-party software on my Mac.

It is targeted toward the latest release of macOS, which is currently Sequoia.

It is intended for myself and other advanced users with good judgement.

## Instructions

- You probably want Homebrew installed.
- Clone this repo.
- Audit the `clean.sh` script, because you shouldn't run scripts you download off the 
Internet blindly.
- Comment out the functions you don't care about.
- `chmod +x clean.sh`
- `./clean.sh`

## TODO

## NOT TODO
- Stuff that isn't really documented by Apple and could have unintended results 
at any given time. Eg. BootCache.playlist
- kextcache rebuilds unless someone can convince me of pretty solid reasons with
backing documentation.
- update_dyld_shared_cache, because it was deprecated with macOS 11.
