FROM base/archlinux

MAINTAINER am@toroid.io

WORKDIR /root
COPY  ./generate_fp_lib_table.sh \
      ./generate_sym_lib_table.sh \
      ./generate_pcbnew_conf.sh \
      ./generate_eeschema_conf.sh \
      /root/

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN pacman -Sy && \
    pacman -S --noconfirm git sudo && \
    pacman -S --noconfirm xorg-server-xvfb ghostscript xdotool recordmydesktop python2-lxml xorg-fonts-type1 && \
    pacman -S --noconfirm kicad python2-numpy && \
    pacman -Scc

RUN git clone https://github.com/KiCad/kicad-symbols.git /usr/share/kicad/library
RUN git clone https://github.com/KiCad/kicad-footprints.git /usr/share/kicad/footprints
RUN curl -o /usr/lib/kicad/plugins/bom2csv.xsl \
  https://raw.githubusercontent.com/KiCad/kicad-source-mirror/master/eeschema/plugins/xsl_scripts/bom2csv.xsl

RUN mkdir -p /root/.config/kicad
RUN ./generate_fp_lib_table.sh && \
    ./generate_sym_lib_table.sh && \
    ./generate_pcbnew_conf.sh && \
    ./generate_eeschema_conf.sh
