FROM tiagosr/cross-compiler-base-auto:latest

WORKDIR /tmp

ENV GENDEV /opt/gendev

RUN bash -c "git clone --depth 1 https://github.com/tiagosr/gendev.git && cd gendev && make && make install && cp -r ./extras /opt/gendev/ && cp -r ./examples /opt/gendev/ && rm -rf /tmp/*"

WORKDIR /source

CMD /bin/bash
