ARG IMAGE

FROM ${IMAGE} as builder

LABEL maintainer.0="David Michael"

# Not sure why this needs to be declared after the IMAGE
ARG NAVCOIN_ARCH
ENV NAVCOIN_VERSION=4.5.2

RUN apt-get update -y \
  && apt-get install -y curl git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

RUN curl -SLO https://github.com/NAVCoin/navcoin-core/releases/download/${NAVCOIN_VERSION}/navcoin-${NAVCOIN_VERSION}-${NAVCOIN_ARCH}-linux-gnu.tar.gz \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

# ------------------------------
# Stage 2: NavCoin need libcurl ... so not really smaller
# ------------------------------

FROM ${IMAGE}

# Copy over the artifacts
COPY --from=builder /usr/local/bin/su-exec /usr/local/bin/
COPY --from=builder /usr/local/bin/navcoind /usr/local/bin/navcoind
COPY --from=builder /usr/local/bin/navcoin-cli /usr/local/bin/navcoin-cli
COPY --from=builder /usr/local/bin/navcoin-tx /usr/local/bin/navcoin-tx

COPY entrypoint.sh /entrypoint.sh

RUN useradd -r navcoin \
  && apt-get update -y \
  && apt-get install -y curl ntpdate ntp \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/home/navcoin/.navcoin"]

EXPOSE 44440 44444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["navcoind"]
