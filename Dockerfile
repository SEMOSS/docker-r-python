FROM semoss/docker-r-packages:T9.0.26

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.5/dist-packages/jep

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN apt-get update \
	&& apt-get install -y python3-pip \
	&& apt-get -y autoremove \
	&& pip3 install jep==3.9.0 \
	&& pip3 install numpy \
	&& pip3 install pandas \
	&& pip3 install matplotlib \
	&& pip3 install sklearn \
	&& pip3 install seaborn \
	&& pip3 install deepdiff \
	&& pip3 install annoy==1.15.2 \
	&& pip3 install fuzzywuzzy \
	&& pip3 install python-Levenshtein \ 
	&& pip3 install pyjarowinkler

WORKDIR /opt

CMD ["bash"]
