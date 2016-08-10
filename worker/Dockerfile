FROM java:openjdk-8-jdk
MAINTAINER Federico Aloi
RUN wget https://github.com/mumuki/QSim/releases/download/v0.3.1/QSim.jar

COPY runqsim /bin/runqsim
RUN chmod u+x /bin/runqsim