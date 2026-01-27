FROM phusion/baseimage:jammy-1.0.4

LABEL maintainer="dlandon"

ENV	DEBCONF_NONINTERACTIVE_SEEN="true" \
	DEBIAN_FRONTEND="noninteractive" \
	DISABLE_SSH="true" \
	HOME="/root" \
	LANG="en_US.UTF-8" \
	TZ="Etc/UTC" \
	TERM="xterm" \
	SLIMUSER="nobody" \
	LMS_PROTECT_SETTINGS="1" \
	LMS_VERSION="9.0.3"

COPY init /etc/my_init.d/
COPY run /etc/service/lyrionmusicserver/

RUN rm -rf /etc/service/cron

RUN	apt-get update --allow-releaseinfo-change && \
	apt-get install -y --no-install-recommends lame faad flac sox perl tzdata pv \
		libio-socket-ssl-perl libcrypt-ssleay-perl openssl libcrypt-openssl-bignum-perl \
		libcrypt-openssl-random-perl libcrypt-openssl-rsa-perl libssl-dev ffmpeg icedax

RUN	url="https://downloads.lms-community.org/LyrionMusicServer_v${LMS_VERSION}/lyrionmusicserver_${LMS_VERSION}_amd64.deb" && \
	cd /tmp && \
	curl -fsSL -o lms.deb "${url}" && \
	dpkg -i lms.deb && \
	rm -f lms.deb

RUN	chmod -R +x /etc/service/lyrionmusicserver /etc/my_init.d/ && \
	groupmod -g 19 cdrom && \
	adduser nobody cdrom

RUN	apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
	apt-get -y autoremove && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/config", "/music"]

EXPOSE 3483 3483/udp 9000 9090

CMD ["/sbin/my_init"]
