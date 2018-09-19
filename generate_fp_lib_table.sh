#!/bin/sh

FILE=/root/.config/kicad/fp-lib-table

echo "(fp_lib_table" > $FILE
ls /usr/share/kicad/footprints -l | awk '{print $9}' | xargs -I [] echo "  (lib (name [])(type KiCad)(uri ${KISYSMOD}/[])(options \"\")(descr \"Script generated, no description\"))" >> $FILE
echo ")" >> $FILE
