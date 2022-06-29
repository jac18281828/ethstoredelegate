FROM debian:stable-slim as builder

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt update && \
  apt install -y -q --no-install-recommends \
  git sudo ripgrep curl \
  build-essential \
  ca-certificates apt-transport-https gpg && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%jac ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD https://sh.rustup.rs /tmp/rustup.sh
RUN chmod 755 /tmp/rustup.sh

ENV USER=jac
USER jac
RUN /tmp/rustup.sh -y
RUN ~jac/.cargo/bin/cargo install --git https://github.com/foundry-rs/foundry --locked foundry-cli

FROM debian:stable-slim

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%jac ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=jac:jac --from=builder /home/jac/.cargo /home/jac/.cargo

ARG PROJECT=store
WORKDIR /workspaces/${PROJECT}
RUN chown -R jac.jac .
COPY --chown=jac:jac . .
ENV USER=jac
USER jac
ENV PATH=${PATH}:~/.cargo/bin
RUN ~jac/.cargo/bin/forge build --sizes
RUN ~jac/.cargo/bin/forge test -vvv

CMD ~/jac/.cargo/bin/forge test -vvv