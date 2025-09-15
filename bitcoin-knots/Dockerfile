FROM debian:bookworm-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake git ninja-build pkg-config \
    libboost-filesystem-dev libboost-system-dev libboost-test-dev \
    libdb++-dev libevent-dev libsqlite3-dev libssl-dev \
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
RUN cmake -S . -B build -DBUILD_GUI=OFF -DBUILD_TESTS=OFF \
 && cmake --build build -j$(nproc) \
 && cmake --install build

# Copy config and entrypoint
COPY wait-for-tor.sh /wait-for-tor.sh
RUN chmod +x /wait-for-tor.sh
COPY bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf
RUN chown -R bitcoin:bitcoin /home/bitcoin

USER bitcoin
WORKDIR /home/bitcoin
VOLUME ["/bitcoin/.bitcoin"]


ENTRYPOINT ["/wait-for-tor.sh"]