# Use Maven to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml files
COPY pom.xml mvnw mvnw.cmd ./
COPY .mvn .mvn

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy the source code
COPY src ./src

# Package the application
RUN ./mvnw clean package -DskipTests

# Use a lightweight JDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port (update if different)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
