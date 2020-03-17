FROM ubuntu:18.04

RUN apt update && \
    apt install -y --no-install-recommends \
    git ssh-client python-pip python-setuptools curl

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt-get install -y --no-install-recommends --fix-missing \
    libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386

RUN pip install --upgrade pip
RUN pip install glob2

# Download and install MPLAB X IDE
# Use url: http://www.microchip.com/mplabx-ide-linux-installer to get the latest version
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar "http://www.microchip.com/mplabx-ide-linux-installer" \
    && tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
    && USER=root ./*-installer.sh --nox11 \
    -- --unattendedmodeui none --mode unattended \
    && rm ./*-installer.sh

RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc32.run "http://www.microchip.com/mplabxc32linux" \
    && chmod a+x /tmp/xc32.run \
    && /tmp/xc32.run --mode unattended --unattendedmodeui none \
    --netservername localhost --LicenseType FreeMode \
    && rm /tmp/xc32.run

ENV PATH /opt/microchip/xc32/`ls /opt/microchip/xc32/ | awk '{print $1}'`/bin:$PATH