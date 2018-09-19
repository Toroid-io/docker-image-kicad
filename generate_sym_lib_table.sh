#!/bin/sh

FILE=/root/.config/kicad/sym-lib-table

echo "(sym_lib_table" > $FILE
ls /usr/share/kicad/library/*.lib -l | awk '{print $9}' | xargs -I [] echo '  (lib (name [])(type Legacy)(uri ${KICAD_SYMBOL_DIR}/[])(options "")(descr "Script generated, no description"))' >> $FILE
echo ")" >> $FILE
