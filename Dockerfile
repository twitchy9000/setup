FROM ubuntu as base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base as usr
ARG TAGS
RUN addgroup --gid 1000 twitchy
RUN adduser --gecos twitchy --uid 1000 --gid 1000 twitchy
USER twitchy
WORKDIR /home/twitchy

FROM usr
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

