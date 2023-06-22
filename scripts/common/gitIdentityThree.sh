#!/bin/bash
TZ=UTC /usr/bin/git config user.name {{ name3 }}
TZ=UTC /usr/bin/git config user.email {{ email3 }}
TZ=UTC /usr/bin/git config user.signingkey {{ gpg_key3 }}