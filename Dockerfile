FROM ubuntu:bionic as build

ENV DEBIAN_FRONTEND noninteractive
ENV GENDEV /opt/gendev

RUN apt update && \
    apt install -y \
        build-essential \
        wget \
        unzip \
        unrar-free \
        texinfo \
        git \
        openjdk-8-jdk-headless && \
    apt clean

WORKDIR /work
COPY tools /work/tools/
COPY Makefile /work/
COPY sgdk /work/sgdk/
COPY toolchain /work/toolchain/
RUN make
RUN make install

FROM ubuntu:bionic
RUN apt update && \
    apt instal -y \
        openjdk-8-jre-headless \
        build-essential \
        make && \
    apt clean

ENV GENDEV /opt/gendev
COPY --from=build /opt/gendev $GENDEV
ENV PATH $GENDEV/bin:$PATH

WORKDIR /src

ENTRYPOINT make -f $GENDEV/sgdk/mkfiles/makefile.gen
