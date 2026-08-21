# Shared multi-stage build for all six Spring Boot services in this Maven
# reactor — which one gets built is selected by the SERVICE_NAME build arg
# (see docker-compose.yml, one `build.args.SERVICE_NAME` per service).
# Building common-lib alongside the target module (-am) is required since
# every service depends on it and it isn't published anywhere else.

FROM maven:3.9-eclipse-temurin-17 AS build
ARG SERVICE_NAME
WORKDIR /app

# Copy the whole reactor. A multi-module Maven build needs the root pom and
# every module's pom to resolve the dependency graph, even though only
# SERVICE_NAME and common-lib actually get compiled below.
COPY pom.xml .
COPY common-lib ./common-lib
COPY event-service ./event-service
COPY booking-service ./booking-service
COPY payment-service ./payment-service
COPY user-service ./user-service
COPY notification-service ./notification-service
COPY api-gateway ./api-gateway

RUN mvn -pl ${SERVICE_NAME},common-lib -am package -DskipTests -q

FROM eclipse-temurin:17-jre-alpine
ARG SERVICE_NAME
WORKDIR /app

# wget is used by each service's compose healthcheck (actuator/health) —
# not present in the base JRE alpine image.
RUN apk add --no-cache wget

COPY --from=build /app/${SERVICE_NAME}/target/${SERVICE_NAME}-*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
