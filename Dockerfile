FROM debian:stable-slim

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


ARG PROJECT=govrs
WORKDIR /workspaces/${PROJECT}
COPY --chown=jac:jac . .
RUN chown -R jac.jac .
ENV USER=jac
USER jac
RUN /tmp/rustup.sh -y
ENV PATH=${PATH}:~/.cargo/bin
RUN ~jac/.cargo/bin/cargo install --git https://github.com/foundry-rs/foundry --locked foundry-cli

CMD /bin/bash