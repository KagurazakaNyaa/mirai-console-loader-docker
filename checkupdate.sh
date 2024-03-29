#!/bin/bash
version=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/iTXTech/mirai-console-loader/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
currentversion=$(cat currentversion)
echo $version > currentversion
if [[ "$currentversion" == "$version" ]]; then
    exit
fi
sed -i 's/^ENV MCL_VERSION.*$/ENV MCL_VERSION '$version'/i' Dockerfile

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git add currentversion
git commit -a -m "Auto Update to mcl "$version
git tag -f $version
git tag -f latest
git push
git push origin --tags -f
