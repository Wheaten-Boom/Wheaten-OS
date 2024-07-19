#!/bin/bash

# Create build directory if not exists
if [ ! -d "build" ]
then
    mkdir build
fi

cd src
(nasm boot.asm -o ../build/boot.bin)
result=$?

if [ $result -eq "0" ]
then
    echo "Compilied finished successfully"
else
    echo "Build failed with error code $result."
fi

cd ..
qemu-system-x86_64 -drive format=raw,file=build/boot.bin
