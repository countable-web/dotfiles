FROM ubuntu:18.04

RUN apt-get update && \
      apt-get -y install sudo

RUN useradd -m astrogirl && echo "astrogirl:password" | chpasswd && adduser astrogirl sudo

RUN echo "astrogirl ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/astrogirl

USER astrogirl
WORKDIR /home/astrogirl


ADD install.sh /home/astrogirl/install.sh

CMD ./install.sh
