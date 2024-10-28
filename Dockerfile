# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables for Tomcat version
ENV TOMCAT_VERSION=9.0.96
ENV TOMCAT_HOME=/opt/tomcat

# Install required packages and OpenJDK
RUN apt-get update && apt-get install -y wget openjdk-17-jdk && \
    wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xvfz apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Set JAVA_HOME environment variable
#ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
#ENV PATH="$JAVA_HOME/bin:$PATH"

# Set permissions and expose the necessary port
RUN chown -R root:root ${TOMCAT_HOME} && \
    chmod -R 755 ${TOMCAT_HOME}

# Expose the Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["sh", "-c", "${TOMCAT_HOME}/bin/catalina.sh run"]
