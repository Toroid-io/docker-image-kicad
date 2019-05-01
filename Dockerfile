# Portions Copyright 2019 Productize SPRL
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
#
# This docker configuration was originally based on https://github.com/productize/docker-kicad as of 301bf181b72c811e9644b83a895ec4a16f2fa1a0


# This docker configuration was originally based on https://github.com/obra/docker-kicad

FROM ubuntu:disco
MAINTAINER Andrés MANELLI <am@toroid.io>
LABEL Description="Minimal KiCad image based on Ubuntu"


ADD kicad-ppa.pgp .
COPY eeschema/requirements.txt .

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
        apt-get -y update && \
        apt-get -y install gnupg2 && \
        echo 'deb http://ppa.launchpad.net/js-reynaud/kicad-5.1/ubuntu disco main' >> /etc/apt/sources.list && \
        apt-key add kicad-ppa.pgp && \
        apt-get -y update && apt-get -y install --no-install-recommends kicad kicad-footprints kicad-symbols && \
        apt-get install -y python3 python3-pip xvfb recordmydesktop xdotool xclip python3-xvfbwrapper python3-psutil && \
        pip3 install -r requirements.txt && \
        rm requirements.txt && \
        apt-get -y remove python3-pip && \
        apt-get -y purge gnupg2 && \
        apt-get -y autoremove && \
        rm -rf /var/lib/apt/lists/* && \
        rm kicad-ppa.pgp

# Use a UTF-8 compatible LANG because KiCad 5 uses UTF-8 in the PCBNew title
# This causes a "failure in conversion from UTF8_STRING to ANSI_X3.4-1968" when
# attempting to look for the window name with xdotool.
ENV LANG C.UTF-8

COPY . /usr/lib/python3/dist-packages/kicad-automation

# Copy default configuration and fp_lib_table to prevent first run dialog
COPY ./config/* /root/.config/kicad/

# Copy the installed global symbol and footprint so projcts built with stock
# symbols and footprints don't break
RUN cp /usr/share/kicad/template/sym-lib-table /root/.config/kicad/
RUN cp /usr/share/kicad/template/fp-lib-table /root/.config/kicad/
