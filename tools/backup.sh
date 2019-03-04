#!/usr/bin/env bash

restic -p "$HOME/.vault/restic-password-file" -r sftp:fetcher@10.0.0.101:/mnt/data/backup-targets/ --exclude-file "$HOME/.vault/restic-exclude" --verbose backup "$HOME/"
