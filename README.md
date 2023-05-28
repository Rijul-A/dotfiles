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
Or, for the `laptop` profile
```bash
bombadil install private.toml
bombadil link -p laptop
```

For (public) systems that just need a quick start, run, optionally with `-p remote`:
```bash
bombadil install bombadil.tml
bombadil link
```
Or, one liner:
```bash
bombadil clone --remote https://github.com/Rijul-A/dotfiles --target ~/Desktop/dotfiles
```
There is only one public profile.