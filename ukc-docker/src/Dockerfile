FROM centos:7

# Maintener
LABEL maintainer "Unbound Security"

# Download & install Java, Tomcat, OpenSSL...
RUN yum -y update;\
    yum -y install wget ;\
    yum -y install openssl initscripts unzip;\
    yum -y install initscripts;\
    yum clean all;

#OpenJDK Java 11
RUN curl -sO https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/
RUN ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java
RUN rm /openjdk-11.0.2_linux-x64_bin.tar.gz

ENV JAVA_HOME=/usr/local/jdk-11.0.2
ENV PATH=$PATH:$JAVA_HOME/bin

#install UKC
COPY data/ekm-RHES.x86_64.rpm /ekm-RHES.x86_64.rpm
RUN rpm -i /ekm-RHES.x86_64.rpm
RUN rm /ekm-RHES.x86_64.rpm

COPY data/casp_backup.pem /etc/ekm

COPY data/start.sh /
RUN chmod +x /start.sh
EXPOSE 8443
EXPOSE 433
ENTRYPOINT ["/start.sh"]