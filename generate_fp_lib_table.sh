#!/bin/sh

FILE=/root/.config/kicad/fp-lib-table

echo "(fp_lib_table" > $FILE
find /usr/share/kicad/footprints -maxdepth 1 -mindepth 1 -not -path '*/\.*' | awk 'BEGIN { FS="[/.]" } ; {print " (lib (name "$5")(type KiCad)(uri "$0")(options \"\")(descr \"Script generated, no description\"))"}' >> $FILE
echo ")" >> $FILE
