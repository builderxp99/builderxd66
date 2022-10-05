FROM alpine:20220715 as maker
RUN apk --no-cache add alpine-sdk coreutils cmake linux-headers rclone \ 
  perl musl m4 sudo libtool autoconf  autoconf-archive  automake bzip2-dev \
  expat-dev gdbm-dev libffi-dev mpdecimal-dev mpdecimal-dev c-ares-dev gnutls-dev cppunit-dev\
#  ncurses-dev openssl-dev readline-dev sqlite-dev tcl-dev xz-dev zlib-dev \
#  qt6-qtbase-dev boost-dev libtorrent-rasterbar-dev qt6-qtsvg-dev  qt6-qttools-dev samurai \
  alsa-lib-dev aom-dev bzip2-dev coreutils dav1d-dev fontconfig-dev freetype-dev \
  fribidi-dev gnutls-dev imlib2-dev lame-dev libass-dev libdrm-dev librist-dev \
  libsrt-dev libssh-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libvpx-dev \
  libwebp-dev libxfixes-dev opus-dev perl-dev pulseaudio-dev sdl2-dev soxr-dev v4l-utils-dev \
  vidstab-dev vulkan-loader-dev x264-dev x265-dev xvidcore-dev yasm zeromq-dev zlib-dev \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/master/aports-master.tar.gz && tar -xf aports-master.tar.gz



#RUN su -c "mkdir pypy && cp -r /home/builder/aports-master/main/python3 ./pypy/ \
#   && cd pypy/python3 && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir qbit && cp -r /home/builder/aports-master/community/qbittorrent ./qbit/ \
#   && cd qbit/qbittorrent && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir mpeg && cp -r /home/builder/aports-master/community/ffmpeg ./mpeg/ \
   && cd mpeg/ffmpeg && abuild-keygen -i -n -a && abuild -r" builder



RUN mkdir /.config && mkdir /.config/rclone && mkdir /root/.config \
    && mkdir /root/.config/rclone
RUN curl -L https://gist.githubusercontent.com/tonmoyislam250/51987f3eac6963992a8d09debaf9d4d8/raw/ea7a0a0895e1060f8224e4e8950cca064acf25f1/gistfile1.txt >/.config/rclone/rclone.conf
RUN cp /.config/rclone/rclone.conf /root/.config/rclone/
RUN ls -a /home/builder/ && ls -a /home/builder/qbit/
RUN apk add --allow-untrusted /home/builder/packages/qbit/x86_64/qbittorrent-nox-4.4.5-r0.apk && qbittorrent-nox --help
RUN rclone copy /home/builder/packages/ teamdrive:qbit/Sharedlib/
