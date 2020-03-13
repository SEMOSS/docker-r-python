FROM semoss/docker-r-packages:user

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/semoss/.local/lib/python3.5/site-packages/jep

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN sudo apt-get update \
	&& sudo apt-get install -y python3-pip \
	&& sudo apt-get -y autoremove \
	#&& sudo pip3 install virtualenv \
	#&& cd /home/semoss \
	#&& virtualenv semoss_venv \
	#&& /bin/bash -c "source /home/semoss/semoss_venv/bin/activate" \
	&& pip3 install jep==3.9.0 \
	&& pip3 install numpy \
	&& pip3 install pandas==0.24.2 \
	&& pip3 install matplotlib \
	&& pip3 install sklearn \
	&& pip3 install seaborn \
	&& pip3 install deepdiff \
	&& pip3 install annoy==1.15.2 \
	&& pip3 install fuzzywuzzy \
	&& pip3 install python-Levenshtein \ 
	&& pip3 install pyjarowinkler

WORKDIR /home/semoss

CMD ["bash"]
