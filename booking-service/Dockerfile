# Built from the PROJECT ROOT (dockerContext: .) — see event-service/Dockerfile
# for why (multi-module Maven reactor, common-lib dependency).

FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY common-lib ./common-lib
COPY event-service ./event-service
COPY booking-service ./booking-service
COPY payment-service ./payment-service
COPY user-service ./user-service
COPY notification-service ./notification-service
COPY api-gateway ./api-gateway

RUN mvn -pl booking-service,common-lib -am package -DskipTests -q

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN apk add --no-cache wget
COPY --from=build /app/booking-service/target/booking-service-*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
