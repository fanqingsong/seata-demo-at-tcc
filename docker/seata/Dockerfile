FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/eclipse-temurin:8-jre-jammy

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /seata-server \
    && curl -fL --retry 5 --retry-delay 2 -o /tmp/seata.tar.gz \
        "https://ghfast.top/https://github.com/apache/incubator-seata/releases/download/v1.0.0/seata-server-1.0.0.tar.gz" \
        || curl -fL --retry 5 --retry-delay 2 -o /tmp/seata.tar.gz \
        "https://github.com/apache/incubator-seata/releases/download/v1.0.0/seata-server-1.0.0.tar.gz" \
    && tar -xzf /tmp/seata.tar.gz -C /seata-server --strip-components=1 \
    && rm /tmp/seata.tar.gz

COPY docker/seata/file.conf /seata-server/conf/file.conf
COPY docker/seata/start.sh /seata-server/start.sh
RUN chmod +x /seata-server/start.sh

WORKDIR /seata-server
EXPOSE 8091
ENTRYPOINT ["/seata-server/start.sh"]
