FROM mitchty/alpine-ghc:latest
ENV dockerfile="latest.dockerfile"
MAINTAINER Pedro Yamada <tacla.yamada@gmail.com>
VOLUME /src
WORKDIR /src
RUN apk add --update-cache docker
COPY ["build.sh", "/usr/local/sbin/"]
ENTRYPOINT /usr/local/sbin/build.sh
CMD --help
