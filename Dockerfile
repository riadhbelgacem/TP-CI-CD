FROM openjdk:21-jdk-slim
VOLUME /tmp
COPY target/*.war /app.war
ENTRYPOINT ["java","-jar","/app.war"]
