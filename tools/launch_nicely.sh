#!/bin/sh
time nice -n 19 ionice -c 3 "$@"

