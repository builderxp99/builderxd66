FROM alpine:20220715 as maker
RUN apk --no-cache add alpine-sdk coreutils cmake linux-headers rclone \ 
  perl musl m4 sudo libtool autoconf  autoconf-archive  automake bzip2-dev \
  expat-dev gdbm-dev libffi-dev mpdecimal-dev mpdecimal-dev c-ares-dev gnutls-dev cppunit-dev\
  ncurses-dev openssl-dev readline-dev sqlite-dev tcl-dev xz-dev zlib-dev \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/master/aports-master.tar.gz && tar -xf aports-master.tar.gz



RUN su -c "mkdir pypy && cp -r /home/builder/aports-master/main/python3 ./pypy/ \
   && cd pypy/python3 && abuild-keygen -i -n -a && abuild -r" builder




RUN mkdir /.config && mkdir /.config/rclone && mkdir /root/.config \
    && mkdir /root/.config/rclone
RUN curl -L https://gist.githubusercontent.com/tonmoyislam250/51987f3eac6963992a8d09debaf9d4d8/raw/ea7a0a0895e1060f8224e4e8950cca064acf25f1/gistfile1.txt >/.config/rclone/rclone.conf
RUN cp /.config/rclone/rclone.conf /root/.config/rclone/
RUN rclone copy /home/builder/pypy/*.apk teamdrive:qbit/Sharedlib/
