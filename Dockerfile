FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY . .

RUN mvn clean package

FROM tomcat:10.1-jdk17-temurin

COPY --from=build /app/target/devops-tomcat-war-demo.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
