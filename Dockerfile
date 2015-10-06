
# camel-centos7
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Your Name <your@email.com>
MAINTAINER Benjamin Holmes <bholmes@redhat.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0
ENV MAVEN_VERSION 3.3.3
ENV BUILDER_VERSION 0.0.1
# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."
LABEL io.k8s.description="Image for building and executing Camel routes" \
      io.k8s.display-name="Camel Builder 0.0.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,camel,maven"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
yum install -y --enablerepo=centosplus \
    tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    yum clean all -y && \
    (curl -0 http://www.eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && \
    ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn && \
    
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV PATH=/opt/maven/bin/:$PATH

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/local/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
# COPY ./.s2i/bin/ /usr/local/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["usage"]
