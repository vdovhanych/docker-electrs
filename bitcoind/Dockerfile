FROM debian:bookworm-slim as builder

WORKDIR /root

ENV BITCOIN_REPO=https://github.com/bitcoin/bitcoin.git
ENV BITCOIN_TAG=v28.1

RUN apt-get update && \
    apt-get install -y git build-essential libtool autotools-dev automake pkg-config \
    bsdmainutils python3 libevent-dev libsqlite3-dev

RUN git clone --depth 1 --branch $BITCOIN_TAG $BITCOIN_REPO

WORKDIR /root/bitcoin

RUN ./autogen.sh && \
    ./configure --disable-tests \
    --disable-bench --disable-static \
    --without-gui --disable-zmq \
    CFLAGS='-w' CXXFLAGS='-w' && \
    make -j 4 && \
    strip src/bitcoind && \
    strip src/bitcoin-cli && \
    strip src/bitcoin-tx

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libevent-dev libsqlite3-dev

COPY --from=builder /root/bitcoin/src/bitcoind /usr/bin/
COPY --from=builder /root/bitcoin/src/bitcoin-cli /usr/bin/
COPY --from=builder /root/bitcoin/src/bitcoin-tx /usr/bin/

EXPOSE 18021

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]
