# Stage 1: Build the Java application with Gradle
# We use a Gradle base image that includes the JDK and Gradle itself.
FROM gradle:7.6-jdk17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy Gradle wrapper files first to leverage Docker layer caching.
# This ensures that if only source code changes, Gradle dependencies aren't re-downloaded.
COPY gradlew .
COPY gradle ./gradle

# Copy Gradle build files
COPY build.gradle settings.gradle .

# Make the Gradle wrapper executable
RUN chmod +x gradlew

# Download project dependencies. This step is cached if build.gradle or settings.gradle don't change.
# Using 'dependencies' task to force dependency resolution without a full build.
RUN ./gradlew dependencies

# Copy the rest of the application source code
COPY src ./src

# Build the application into a JAR file.
# -x test is used to skip tests in CI/CD pipelines to speed up the build,
# assuming tests are run in a separate CI stage.
RUN ./gradlew build -x test

# Stage 2: Create the final, lightweight runtime image
# We use a 'distroless' JRE image. Distroless images contain only your application
# and its runtime dependencies, making them very small and secure.
FROM gcr.io/distroless/java17-debian11

# Set the working directory for the application
WORKDIR /app

# Copy the built JAR file from the 'builder' stage into the final image
# The JAR file name typically follows the pattern: <artifact-id>-<version>.jar
# You might need to adjust 'your-microservice-0.0.1-SNAPSHOT.jar'
# to match your actual JAR file name. Gradle typically places JARs in build/libs/.
COPY --from=builder /app/build/libs/demo-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port your microservice listens on.
# Common ports for Spring Boot are 8080.
EXPOSE 8080

# Define the entry point for the application.
# This command will be executed when the container starts.
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Optional: Add a non-root user for enhanced security (recommended for production)
# Create a group and user, then switch to that user.
# RUN groupadd --system appgroup && useradd --system --gid appgroup appuser

