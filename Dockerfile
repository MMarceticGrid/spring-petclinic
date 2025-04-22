FROM gradle:8.5-jdk17 AS build

WORKDIR /app

COPY . /app

RUN gradle clean build

FROM eclipse-temurin:17-jre

RUN mkdir app

COPY --from=build /app/build/libs/*.jar app/app.jar
COPY --from=build /app/jmx_prometheus_javaagent-1.2.0.jar app/jmx_prometheus_javaagent-1.2.0.jar
COPY ./jmx_exporter_config.yaml app/jmx_exporter_config.yaml

EXPOSE 8080
EXPOSE 9080
WORKDIR /app

CMD [ "java", "-javaagent:jmx_prometheus_javaagent-1.2.0.jar=8000:jmx_exporter_config.yaml", "-jar", "app.jar"]
