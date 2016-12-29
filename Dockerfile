FROM finalduty/archlinux

MAINTAINER am@toroid.io

RUN pacman -Sy
RUN pacman -S --noconfirm git
RUN pacman -S --noconfirm kicad kicad-library
RUN pacman -S --noconfirm xorg-server-xvfb
RUN pacman -S --noconfirm inkscape
RUN pacman -S --noconfirm ghostscript
RUN pacman -S --noconfirm xdotool
RUN pacman -S --noconfirm recordmydesktop

# Set DISPLAY variable
ENV DISPLAY=:0
# Set FRONTEND
ENV DEBIAN_FRONTEND=noninteractive
