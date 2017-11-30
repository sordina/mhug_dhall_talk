#!/bin/bash -e

STUFF='
{
    ip = "yoho",
    name = "HII im brendoid",
    pageLimit = 45
} : http://192.168.1.29:3000/userconfig
'

OUT1="$(echo $STUFF | dhall)"
OUT2=$(curl -X POST -d "$OUT1" 192.168.1.29:3000 | dhall)

echo "$OUT2 : http://192.168.1.29:3000/hpconfig" | dhall
