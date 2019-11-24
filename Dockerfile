# Construimos el nsq consumer procesor.
FROM maven:3-jdk-8 as nsq-builder
RUN mkdir -p /develop/github \ 
    && cd /develop/github \
    && git clone https://github.com/mataram/Nifi-NSQ-Consumer.git \
    && cd Nifi-NSQ-Consumer \
    && mvn clean install -DskipTests -Dmaven.test.skip=true

# Construimos el protobuffer processor
FROM maven:3-jdk-8 as proto-builder
RUN mkdir -p /develop/github \ 
    && cd /develop/github \
    && git clone https://github.com/whiver/nifi-protobuf-processor.git \
    && cd nifi-protobuf-processor \
    && mvn compile \
    && mvn nifi-nar:nar

# Imagen de nifi
FROM apache/nifi:1.10.0
COPY --from=nsq-builder   /develop/github/Nifi-NSQ-Consumer/nifi-nsq-nar/target/nifi-nsq-nar-*.nar /opt/nifi/nifi-current/lib/
COPY --from=proto-builder /develop/github/nifi-protobuf-processor/target/nifi-protobuf-processor-*.nar /opt/nifi/nifi-current/lib/
RUN mkdir -p /home/nifi/.ssh && touch /home/nifi/.ssh/known_hosts && chmod 700 /home/nifi/.ssh && chmod 600 /home/nifi/.ssh/*
