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
    apt install -y \
        openjdk-8-jre-headless \
        build-essential \
        make && \
    apt clean

ENV GENDEV /opt/gendev
COPY --from=build /opt/gendev $GENDEV

RUN ln -s ${GENDEV}/bin/m68k-elf-gcc ${GENDEV}/bin/gcc
RUN ln -s ${GENDEV}/bin/m68k-elf-ld ${GENDEV}/bin/ld
RUN ln -s ${GENDEV}/bin/m68k-elf-nm ${GENDEV}/bin/nm
RUN ln -s ${GENDEV}/bin/m68k-elf-objcopy ${GENDEV}/bin/objcopy
RUN ln -s /bin/mkdir ${GENDEV}/bin/mkdir
RUN ln -s /bin/rm ${GENDEV}/bin/rm
RUN ln -s /bin/sh ${GENDEV}/bin/sh

RUN ln -s ${GENDEV}/bin ${GENDEV}/sgdk/bin

ENV PATH $GENDEV/bin:$PATH
ENV GDK ${GENDEV}/sgdk

WORKDIR /src

ENTRYPOINT ["make", "-f"]
CMD [ "${GENDEV}/sgdk/mkfiles/makefile.gen" ]
