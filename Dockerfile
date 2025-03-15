FROM debian
# Install dep dependencies

RUN apt-get -y update && \
    apt-get install -y git \
        build-essential libbsd-dev byacc \
        flex libboost-dev texinfo zlib1g-dev && \
    update-alternatives --set yacc /usr/bin/byacc && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/opt/fcc/bin"
WORKDIR /build
RUN --mount=type=bind,source=.,target=/tmp/src \
    cp /tmp/src/* . && \
    git clone https://github.com/EtchedPixels/Fuzix-Bintools && \
    make -C Fuzix-Bintools install && \
    git clone https://github.com/EtchedPixels/Fuzix-Compiler-Kit && \
    patch -d Fuzix-Compiler-Kit -p1 -i "../fuzix-compiler-kit.patch" && \
    make -C Fuzix-Compiler-Kit install && \
    git clone https://github.com/EtchedPixels/sdcc280 && \
        (cd sdcc280/sdcc && \
        ./configure --prefix "/usr" \
            --disable-pic14-port --disable-pic16-port --disable-hc08-port --disable-s08-port --disable-stm8-port --disable-pdk13-port --disable-pdk14-port --disable-pdk15-port --disable-ucsim && \
        make all -j$(nproc) && \
        make install) && \
    rm -rf *

RUN git clone https://github.com/EtchedPixels/FUZIX

CMD ["bash"]


