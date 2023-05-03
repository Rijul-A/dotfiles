## Pre-requisites
```bash
cargo install toml-bombadil
```
Or
```bash
sudo pacman -S toml-bombadil
``` 

## Usage
For systems with the secret (private) GPG key installed, simply run:
```bash
bombadil install private.toml
bombadil link
```
Or, for the `local` profile
```bash
bombadil install private.toml
bombadil link -p local
```

For (public) systems that just need a quick start, run:
```bash
bombadil install public.tml
bombadil link
```
There is only one public profile.