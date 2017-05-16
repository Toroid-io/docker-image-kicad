FROM archlinuxjp/archlinux-yaourt

MAINTAINER am@toroid.io

RUN pacman -Sy
RUN pacman -S --noconfirm git base-devel sudo \
	xorg-server-xvfb ghostscript xdotool recordmydesktop python2-lxml

WORKDIR /kicad
RUN groupadd -r kicad -g 433
RUN useradd -u 431 -r -g kicad -d /kicad -s /sbin/nologin -c "Docker image user" kicad
RUN chown -R kicad:kicad /kicad
RUN gpasswd -a kicad wheel
RUN echo 'kicad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
USER kicad

RUN yaourt -S --noconfirm aur/kicad-git aur/kicad-library-git aur/kicad-pretty-git

RUN sudo rm -rf /usr/share/kicad/modules/packages3d
RUN sudo pacman -Rns --noconfirm cmake boost
RUN sudo paccache -ruk0

RUN sudo mkdir -p /root/.config/kicad && \
	sudo cp /usr/share/kicad/template/sym-lib-table /root/.config/kicad && \
	sudo cp /usr/share/kicad/template/fp-lib-table /root/.config/kicad

USER root
