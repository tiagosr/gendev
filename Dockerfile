FROM ubuntu:16.04

WORKDIR /tmp

RUN apt-get update && apt-get install -y build-essential wget unzip unrar-free texinfo git default-jdk && apt-get clean

ENV GENDEV /opt/gendev

RUN bash -c "git clone https://github.com/tiagosr/gendev.git && cd gendev && make && make install && cp -r ./extras /opt/gendev/ && cp -r ./examples /opt/gendev/ && rm -rf /tmp/*"

WORKDIR /source

CMD /bin/bash
