#docker build . -t quay.io/semoss/docker-r-python:R4.2.1-debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=debian11

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip curl \
	&& apt-get -y autoremove \
	&& curl -s https://raw.githubusercontent.com/SEMOSS/docker-r-python/R4.2.1-debian11/semoss_requirements.txt | grep -v 'jep==3.9.1' | /usr/bin/python3 -m pip install --upgrade -r /dev/stdin

WORKDIR /opt

CMD ["bash"]
