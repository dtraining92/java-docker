# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables for Tomcat version
ENV TOMCAT_VERSION=10.1.31
ENV TOMCAT_HOME=/opt/tomcat

# Install required packages and OpenJDK
RUN apt-get update && apt-get install -y wget openjdk-17-jdk && \
    wget https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xvfz apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN apt install -y maven

# Copy the Maven project files into the Docker image
COPY . /app

# Navigate to the project directory and run Maven to generate the WAR file
WORKDIR /app
RUN mvn clean package

# Copy the generated WAR file into Tomcat's webapps directory
RUN cp target/my-webapp-1.0-SNAPSHOT.war ${TOMCAT_HOME}/webapps/

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Set permissions and expose the necessary port
RUN chown -R root:root ${TOMCAT_HOME} && \
    chmod -R 755 ${TOMCAT_HOME}

# Expose the Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["sh", "-c", "${TOMCAT_HOME}/bin/catalina.sh run"]
