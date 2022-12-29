#!/bin/bash
max_retry=5
counter=0
until [ -n "${version}" ]
do
    sleep 1
    [[ counter -eq $max_retry ]] && echo "Failed!" && exit 1
    version=$(curl --silent "https://api.github.com/repos/iTXTech/mirai-console-loader/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
done
currentversion=$(cat currentversion)
echo $version > currentversion
if [[ "$currentversion" == "$version" ]]; then
    exit
fi
sed -i 's/^ENV MCL_VERSION.*$/ENV MCL_VERSION '$version'/i' Dockerfile
git config user.name github-actions
git config user.email github-actions@github.com
git add currentversion
git commit -a -m "Auto Update to mcl "$version
git tag -f $version
git tag -f latest
git push
git push origin --tags -f
