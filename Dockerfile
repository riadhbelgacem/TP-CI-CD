FROM eclipse-temurin:21-jre-alpine
VOLUME /tmp
COPY target/*.war /app.war
ENTRYPOINT ["java","-jar","/app.war"]
