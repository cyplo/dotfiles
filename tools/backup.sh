#!/usr/bin/env bash

restic -p "$HOME/.vault/restic-password-file" -r sftp:fetcher@brix:/mnt/data/backup-targets/ --exclude-file "$HOME/.vault/restic-exclude" --verbose backup "$HOME/"
