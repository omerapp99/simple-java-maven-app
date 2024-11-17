FROM maven:3.9.2-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=builder /app/target/my-app-*.jar /app/app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
