#!/bin/bash
TZ=UTC /usr/bin/git config user.name {{ name1 }}
TZ=UTC /usr/bin/git config user.email {{ email1 }}
TZ=UTC /usr/bin/git config user.signingkey {{ gpg_key1 }}