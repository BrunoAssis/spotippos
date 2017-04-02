FROM crystallang/crystal:0.21.1
MAINTAINER brunoassis@gmail.com

RUN mkdir -p /opt/spotippos
COPY shard.yml /opt/spotippos
COPY shard.lock /opt/spotippos

WORKDIR /opt/spotippos
RUN crystal deps

COPY . /opt/spotippos

RUN crystal build --release ./src/spotippos.cr

CMD ["./spotippos"]