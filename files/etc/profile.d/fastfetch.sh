#!/usr/bin/env bash
if [[ $- == *i* ]] && [[ -t 1 ]]; then
    fastfetch
fi