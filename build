#!/bin/sh

set -xe

swiftc src/main.swift \
    -I ./libs/raylib-5.5_linux_amd64/include \
    -L ./libs/raylib-5.5_linux_amd64/include \
    -Xlinker ./libs/raylib-5.5_linux_amd64/lib/libraylib.a -Xlinker -lm
