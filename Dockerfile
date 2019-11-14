FROM maven:3-jdk-8 as builder

RUN mkdir -p /develop/github \ 
    && cd /develop/github \
    && git clone https://github.com/mataram/Nifi-NSQ-Consumer.git \
    && cd Nifi-NSQ-Consumer \
    && mvn clean install -DskipTests -Dmaven.test.skip=true

FROM apache/nifi:1.10.0

COPY --from=builder /develop/github/Nifi-NSQ-Consumer/nifi-nsq-nar/target/nifi-nsq-nar-0.1.nar /opt/nifi/nifi-current/lib/
