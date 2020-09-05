FROM semoss/docker-r-packages:R3.6.1-debian10.5 as base

FROM semoss/docker-r-packages:R3.6.1-debian10.5 as pybuilder

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.7/dist-packages/jep

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
	&& pip3 install pyjarowinkler \
	&& pip3 install swifter \
	&& pip3 install pyarrow

FROM base
LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.7/dist-packages/jep

RUN apt-get update \
	&& apt-get install -y python3-pip gcc-8- \
	&& apt-get -y autoremove
	
COPY --from=pybuilder /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages

WORKDIR /opt

CMD ["bash"]
