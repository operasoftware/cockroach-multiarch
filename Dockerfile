FROM golang:1.16.15-bullseye as prebuild
ARG TARGETARCH
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN wget -O /usr/local/bin/bazel \
    https://github.com/bazelbuild/bazel/releases/download/5.1.0/bazel-5.1.0-linux-$([[ $TARGETARCH = "arm64" ]] && echo "arm64" || echo "x86_64") && \
    chmod +x /usr/local/bin/bazel
RUN apt-get -y update
RUN apt-get -y install build-essential gcc g++ cmake autoconf wget bison libncurses-dev ccache curl git libgeos-dev tzdata apt-transport-https lsb-release ca-certificates nodejs
RUN corepack enable

FROM prebuild as build
RUN /bin/bash -c "mkdir -p /go/src/github.com/cockroachdb && cd /go/src/github.com/cockroachdb"
WORKDIR /go/src/github.com/cockroachdb
RUN /bin/bash -c "git clone --branch v21.2.7 https://github.com/cockroachdb/cockroach"
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN /bin/bash -c "git submodule update --init --recursive"
RUN /bin/bash -c "make build"
RUN /bin/bash -c "make install"

FROM ubuntu:jammy-20220315
WORKDIR /cockroach/
ENV PATH=/cockroach:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p /cockroach/ /usr/local/lib/cockroach /licenses
COPY --from=build /usr/local/bin/cockroach /cockroach/cockroach
COPY --from=build /go/native/*-linux-gnu/geos/lib/libgeos.so /go/native/*-linux-gnu/geos/lib/libgeos_c.so /usr/local/lib/cockroach/
EXPOSE 26257 8080
ENTRYPOINT ["/cockroach/cockroach"]
