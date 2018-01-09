#!/bin/bash

set -e

vaults_directory=~/vaults/
resolved_directory=$vaults_directory/resolved
target_vault="$vaults_directory/vault.vera"
target_mount="/tmp/target_vault"
conflicted_mount=/tmp/conflicted_vault

mkdir -p $resolved_directory

umount-vault

conflicted=`find "$vaults_directory" -maxdepth 1 -iname "*vault*sync-conflict*"`
read -s -p "password: " vault_password
echo

for current_vault in $conflicted; do
    echo
    VAULT_PASSWORD="$vault_password" mount-vault $current_vault "$conflicted_mount"
    VAULT_PASSWORD="$vault_password" mount-vault $target_vault $target_mount
   
    cd $target_mount
    hg pull $conflicted_mount

    cd $vaults_directory
    umount-vault
    rm -fr "$conflicted_mount"
    mv $current_vault $resolved_directory
done

mkdir -p $vaults_directory/deescalated 
