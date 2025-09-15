FROM debian:bookworm-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git build-essential libtool autotools-dev automake pkg-config \
    bsdmainutils curl netcat-openbsd \
    libevent-dev libboost-system-dev libboost-filesystem-dev \
    libboost-chrono-dev libboost-test-dev libboost-thread-dev \
    libminiupnpc-dev libzmq3-dev libdb++-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash bitcoin

# Ensure volume path exists and is owned by 'bitcoin' before switching user
RUN mkdir -p /bitcoin/.bitcoin && chown -R bitcoin:bitcoin /bitcoin

# Clone Bitcoin Knots
WORKDIR /opt
# Clone Bitcoin Knots at specific release tag
RUN git clone https://github.com/bitcoinknots/bitcoin.git --branch v29.1.knots20250903 knots

# Build
WORKDIR /opt/knots
RUN ./autogen.sh && ./configure --without-gui --disable-tests && make -j$(nproc) && make install


# Copy config and entrypoint

COPY wait-for-tor.sh /wait-for-tor.sh
RUN chmod +x /wait-for-tor.sh
COPY bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf
RUN chown -R bitcoin:bitcoin /home/bitcoin

USER bitcoin
WORKDIR /home/bitcoin
VOLUME ["/bitcoin/.bitcoin"]


ENTRYPOINT ["/wait-for-tor.sh"]