
ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=R4.1.0-debian10.5


ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/ddocker-r-packages
ARG BUILDER_BASE_TAG=R4.1.0-debian10.5

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

FROM ${BUILDER_BASE_REGISTRY}/${BUILDER_BASE_IMAGE}:${BUILDER_BASE_TAG} as pybuilder

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.7/dist-packages/jep

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN apt-get update \
	&&  apt-get install -y cmake \
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
	&& pip3 install swifter
#	&& pip3 install pyarrow

FROM base
LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.7/dist-packages/jep

RUN apt-get update \
	&& apt-get install -y python3-pip gcc-8- linux-libc-dev- \
	&& apt-get -y autoremove
	
COPY --from=pybuilder /usr/local/lib/python3.7/dist-packages /usr/local/lib/python3.7/dist-packages
COPY --from=pybuilder /usr/lib/python3.7 /usr/lib/python3.7
COPY --from=pybuilder /usr/lib/x86_64-linux-gnu/libpython3.7m.so.1 /usr/lib/x86_64-linux-gnu/libpython3.7m.so.1

WORKDIR /opt

CMD ["bash"]
