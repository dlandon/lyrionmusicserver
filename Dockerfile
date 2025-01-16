FROM phusion/baseimage:jammy-1.0.4

LABEL maintainer="dlandon"

ENV	DEBCONF_NONINTERACTIVE_SEEN="true" \
	DEBIAN_FRONTEND="noninteractive" \
	DISABLE_SSH="true" \
	HOME="/root" \
	LC_ALL="C.UTF-8" \
	LANG="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	TZ="Etc/UTC" \
	TERM="xterm" \
	SLIMUSER="nobody" \
	LMS_VERSION="9.0.1"

COPY init /etc/my_init.d/
COPY run /etc/service/lyrionmusicserver/

RUN rm -rf /etc/service/cron

RUN	apt-get update && \
	apt-get install -y lame faad flac sox perl wget tzdata pv && \
	apt-get install -y libio-socket-ssl-perl libcrypt-ssleay-perl && \
	apt-get install -y openssl libcrypt-openssl-bignum-perl libcrypt-openssl-random-perl libcrypt-openssl-rsa-perl && \
	apt-get install -y libssl-dev ffmpeg icedax && \
	apt-get -y upgrade -o Dpkg::Options::="--force-confold"

RUN	url="https://downloads.lms-community.org/LyrionMusicServer_v${LMS_VERSION}/lyrionmusicserver_${LMS_VERSION}_amd64.deb" && \
	cd /tmp && \
	wget -q "${url}" && \
	dpkg -i "lyrionmusicserver_${LMS_VERSION}_amd64.deb"

RUN	apt-get -y remove wget && \
	apt-get -y autoremove && \
	rm -rf /tmp/* /var/tmp/* && \
	chmod -R +x /etc/service/lyrionmusicserver /etc/my_init.d/ && \
	groupmod -g 19 cdrom && \
	adduser nobody cdrom && \
	/etc/my_init.d/20_apt_update.sh

VOLUME \
	["/config"] \
	["/music"]

EXPOSE 3483 3483/udp 9000 9090

CMD ["/sbin/my_init"]
