#!/bin/bash
TZ=UTC /usr/bin/git config user.name {{ name2 }}
TZ=UTC /usr/bin/git config user.email {{ email2 }}
TZ=UTC /usr/bin/git config user.signingkey {{ gpg_key2 }}