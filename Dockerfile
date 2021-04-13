FROM ubi7/ubi:7.7

MAINTAINER Chris Gunn <chris.gunn@mantech.com>

LABEL LAB=true

ARG NEXUS_VERSION=2.14.3-02
ENV NEXUS_HOME=/opt/nexus

ADD nexus-${NEXUS_VERSION}-bundle.tar.gz ${NEXUS_HOME}/
ADD nexus-start.sh ${NEXUS_HOME}/

RUN yum install -y --setopt=tsflags=nodocs java-1.8.0-openjdk-devel && \
    yum clean all -y && \
    groupadd -r nexus -f -g 1001 && \
    useradd -u 1001 -r -g nexus -G root -m -d ${NEXUS_HOME} \
        -s /sbin/nologin \
        -c "Nexus User" nexus && \
    ln -s ${NEXUS_HOME}/nexus-${NEXUS_VERSION} ${NEXUS_HOME}/nexus2 && \
    chown -R nexus:root ${NEXUS_HOME} && \
    chmod -R 2775 ${NEXUS_HOME}

USER nexus

WORKDIR ${NEXUS_HOME}

VOLUME ["${NEXUS_HOME}/sonatype-work"]

CMD ["sh", "./nexus-start.sh"]
