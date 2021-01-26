FROM maven:3.6-jdk-11-slim as BUILD
COPY springapp/. /src
WORKDIR /src
RUN mvn package -DskipTests

FROM openjdk:11.0-jre
EXPOSE 8080
COPY --from=BUILD /src/target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=mysql","-jar","/app.jar"]