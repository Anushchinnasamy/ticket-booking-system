# Built from the PROJECT ROOT (dockerContext: .), not this directory — this
# is a multi-module Maven build and needs the whole reactor to resolve
# common-lib, which every service depends on and which isn't published
# anywhere else. See the sibling Dockerfiles in the other five services for
# the identical pattern, one per service so no platform needs to support
# passing a build-arg into `docker build` (Render's Blueprint spec doesn't).

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

RUN mvn -pl event-service,common-lib -am package -DskipTests -q

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# wget backs the compose/Render healthcheck against /actuator/health —
# not present in the base JRE alpine image.
RUN apk add --no-cache wget

COPY --from=build /app/event-service/target/event-service-*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
