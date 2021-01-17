FROM centos:7
ENV GOSU_VERSION=1.11

RUN yum install -y make git gcc libcurl-devel sqlite-devel pkg-config && \
	git clone https://github.com/abraunegg/onedrive.git /usr/src/onedrive && \
	curl -fsS https://dlang.org/install.sh | bash -s ldc && \
	rm -rf /var/cache/yum/ && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64" && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64.asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    rm -r /root/.gnupg/ && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

RUN mkdir -p /onedrive/conf /onedrive/data

WORKDIR /usr/src/onedrive
RUN source ~/dlang/ldc-1.24.0/activate && \
	./configure && \
    make clean && \
    make && \
    make install

VOLUME ["/onedrive/conf"]
ENTRYPOINT ["/usr/src/onedrive/contrib/docker/entrypoint.sh"]
