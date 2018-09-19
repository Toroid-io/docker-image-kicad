FROM base/archlinux

MAINTAINER am@toroid.io

WORKDIR /kicad
COPY ./generate_fp_lib_table.sh ./generate_sym_lib_table.sh /kicad/
RUN groupadd -r kicad -g 433
RUN useradd -u 431 -r -g kicad -d /kicad -s /sbin/nologin -c "Docker image user" kicad
RUN chown -R kicad:kicad /kicad
RUN gpasswd -a kicad wheel
RUN echo 'kicad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN pacman -Sy && \
    pacman -S --noconfirm git sudo && \
    pacman -S --noconfirm xorg-server-xvfb ghostscript xdotool recordmydesktop python2-lxml xorg-fonts-type1 && \
    pacman -S --noconfirm kicad && \
    pacman -Scc

RUN git clone https://github.com/KiCad/kicad-symbols.git /usr/share/kicad/library
RUN git clone https://github.com/KiCad/kicad-footprints.git /usr/share/kicad/footprints

USER kicad

RUN mkdir -p /kicad/.config/kicad
RUN ./generate_fp_lib_table.sh && ./generate_sym_lib_table.sh
