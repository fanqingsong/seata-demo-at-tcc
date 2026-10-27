FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/maven:3.8.6-openjdk-8 AS build

COPY docker/maven/settings.xml /root/.m2/settings.xml

RUN curl -fL --retry 5 --retry-delay 2 -o /tmp/foundation.tar.gz \
        "https://codeload.github.com/dk-lockdown/dk-foundation/tar.gz/refs/heads/dev-seata" \
    && mkdir -p /build/dk-foundation \
    && tar -xzf /tmp/foundation.tar.gz -C /build/dk-foundation --strip-components=1 \
    && rm /tmp/foundation.tar.gz \
    && find /build/dk-foundation -name pom.xml -exec sed -i 's/2.1-SNAPSHOT/2.1.1-SNAPSHOT/g' {} + \
    && mvn -f /build/dk-foundation/pom.xml -DskipTests install

WORKDIR /build/seata-demo
COPY pom.xml .
COPY product-service product-service
COPY order-service order-service
COPY order-aggregation-service order-aggregation-service
RUN mvn -DskipTests package

FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/eclipse-temurin:8-jre-jammy

ARG SERVICE
WORKDIR /app
COPY --from=build /build/seata-demo/${SERVICE}/target/${SERVICE}-1.0-SNAPSHOT.jar /app/app.jar

ENV TZ=Asia/Shanghai
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
