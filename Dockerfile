FROM tbanach/docker-r-packages

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python2.7/dist-packages/jep
ENV LD_PRELOAD=/usr/lib/python2.7/config-x86_64-linux-gnu/libpython2.7.so

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN apt-get update \
	&& apt-get remove -y python3 \
	&& apt-get remove -y python3-minimal \
	&& apt-get install -y python \
	&& apt-get install -y python-pip \
	&& pip install jep==3.7.1 \
	&& pip install pandas

WORKDIR /opt

CMD ["bash"]
