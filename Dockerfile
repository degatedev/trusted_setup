From ubuntu:20.04
RUN apt-get update -y
RUN apt-get install -y net-tools wget git python3 gcc vim curl
RUN apt install -y screen
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ADD trusted-setup.sh /opt/
ENTRYPOINT ["/opt/trusted-setup.sh"]
