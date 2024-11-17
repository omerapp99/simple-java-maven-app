# First stage: Build the Maven project
FROM maven:3.9.2-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Second stage: Run the built app
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/target/simple-java-maven-app-*.jar /app/app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
