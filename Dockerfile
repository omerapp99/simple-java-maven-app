# Use an image with both Maven and Java 17
FROM maven:3.9.2-eclipse-temurin-17

# Set working directory
WORKDIR /app

# Copy only the pom.xml first to leverage Docker cache
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the entire project
COPY . .

# Build the application
RUN mvn clean package -DskipTests \
    -Dmaven.compiler.source=17 \
    -Dmaven.compiler.target=17 \
    -Dmaven.enforcer.skip=true

# Use a lightweight runtime image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built jar from the previous stage
COPY --from=0 /app/target/*.jar app.jar

# Expose port if needed
# EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]