FROM tbanach/docker-r-packages

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN apt-get update \
	&& apt-get install -y python \
	&& apt-get install -y python-pip \
	&& pip install jep==3.7.1 \
	&& pip install pandas

WORKDIR /opt

CMD ["bash"]