from registry.gitlab.steamos.cloud/steamrt/steamrt4/sdk:4.0.20251117.183306

ENV OUTPUT_DIR=/output
ENV DATA_DIR=/data
ENV SRC_DIR=/src
ENV RUST_VERSION=1.89.0

COPY --chmod=755 ./builder.sh /builder.sh

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_VERSION -y
RUN apt update
RUN apt install -y libudev-dev lld librust-bzip2-dev
RUN mkdir $OUTPUT_DIR
RUN mkdir $DATA_DIR

WORKDIR $SRC_DIR
VOLUME $OUTPUT_DIR

ENTRYPOINT ["/builder.sh"]
CMD ["release"]
