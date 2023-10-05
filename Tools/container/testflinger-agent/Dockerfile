FROM ubuntu:22.04 AS build

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG CHECKBOX_PPA=ppa:checkbox-dev/testing

RUN groupadd -g "${gid}" "${group}" \
  && useradd -l -c "Jenkins user" -d /home/"${user}" -u "${uid}" -g "${gid}" -m "${user}"

ARG AGENT_WORKDIR=/home/"${user}"/agent
ENV TZ=Asia/Taipei

RUN apt-get update \
  && apt-get --yes install software-properties-common gpg \
  && add-apt-repository -y ${CHECKBOX_PPA} \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
    apt-get --yes --no-install-recommends install \
    ca-certificates \
    curl \
    fontconfig \
    git \
    git-lfs \
    less \
    netbase \
    openssh-client \
    patch \
    tzdata \
    python3-pip \
    python3-dev \
    checkbox-ng \
    python3-checkbox-support \
    ssh-import-id \
    openjdk-17-jre-headless \
    shellcheck \
    jq \
  && apt-get clean \
  && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*

ARG VERSION=3148.v532a_7e715ee3
ADD --chown="${user}":"${group}" "https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar" /usr/share/jenkins/agent.jar
RUN chmod 0644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

ENV LANG C.UTF-8

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:/home/${user}/.local/bin:${PATH}"

COPY jenkins-agent /usr/local/bin/jenkins-agent

RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER "${user}"
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p "${AGENT_WORKDIR}"

VOLUME /home/"${user}"/.jenkins
VOLUME "${AGENT_WORKDIR}"
WORKDIR /home/"${user}"
ENV user=${user}

ENV INFLUX_HOST=localhost \
    INFLUX_PORT=8086 \
    INFLUX_USER=testflinger-agent \
    INFLUX_PW=testflinger-agent
    
RUN python3 -m pip install pip -U \
    && git clone https://github.com/canonical/testflinger-agent.git && python3 -m pip install -I testflinger-agent/ \
    && git clone https://github.com/canonical/snappy-device-agents.git && python3 -m pip install -I snappy-device-agents/ \
    && git clone https://github.com/canonical/testflinger-cli.git && python3 -m pip install -I testflinger-cli/ 

RUN chown ${user}:${group} -R /home/${user}/*

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
