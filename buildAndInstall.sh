#!/bin/zsh
echo "start build and install package-to-pods"
echo "<build>"
swift build -c release

output=$(swift build -c release --show-bin-path)"/package-to-pods"

if [ -e $output ]
then
    echo "<install>"
    cp -f $output /usr/local/bin/package-to-pods
    echo "install successfully!!!"
else
    echo "cannot install"
fi