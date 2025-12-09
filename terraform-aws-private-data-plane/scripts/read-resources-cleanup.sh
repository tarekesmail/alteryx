#!/bin/bash


echo "writing some error" >&2

# read from STDIN to get the previous state
IN=$(cat)
# can we just get by with echoing the existing state?
echo "${IN}"