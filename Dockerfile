#docker build . -t quay.io/semoss/docker-r-python:R4.1.2-debian11-builder

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=R4.1.2-debian11


ARG BUILDER_BASE_REGISTRY=quay.io
ARG BUILDER_BASE_IMAGE=semoss/docker-r-packages
ARG BUILDER_BASE_TAG=R4.1.2-debian11

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

FROM ${BUILDER_BASE_REGISTRY}/${BUILDER_BASE_IMAGE}:${BUILDER_BASE_TAG} as pybuilder


# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.9/dist-packages/jep

# Install Python
# Install PIP
# Install JEP
# Install Pandas
RUN apt-get update \
	&& apt-get install -y python3-pip \
	&& apt-get -y autoremove \
	&& pip3 install jep==3.9.1 \
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
	#&& pip3 install pyarrow \
	&& pip3 install xlrd \
	&& pip3 install pandasql


FROM base
LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.9/dist-packages/jep

RUN apt-get update \
	&& apt-get install -y python3-pip gcc-10- linux-libc-dev- \
	&& apt-get -y autoremove
	
COPY --from=pybuilder /usr/local/lib/python3.9/dist-packages /usr/local/lib/python3.9/dist-packages
COPY --from=pybuilder /usr/lib/python3.9 /usr/lib/python3.9
COPY --from=pybuilder /usr/lib/x86_64-linux-gnu/libpython3.9.a  /usr/lib/x86_64-linux-gnu/libpython3.9.a  
COPY --from=pybuilder /usr/lib/x86_64-linux-gnu/libpython3.9.so /usr/lib/x86_64-linux-gnu/libpython3.9.so
COPY --from=pybuilder /usr/lib/x86_64-linux-gnu/libpython3.9.so.1 /usr/lib/x86_64-linux-gnu/libpython3.9.so.1 
COPY --from=pybuilder /usr/lib/x86_64-linux-gnu/libpython3.9.so.1.0  /usr/lib/x86_64-linux-gnu/libpython3.9.so.1.0

WORKDIR /opt

CMD ["bash"]
