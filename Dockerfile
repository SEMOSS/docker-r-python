#docker build . -t quay.io/semoss/docker-r-python:cuda12.2

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=cuda12.2

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

# Install Python
# Install PIP
# Install JEP
# Install Pandas

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip \
	&& apt-get install -y tesseract-ocr \
	&& apt-get -y autoremove \
	&& /usr/bin/python3 -m  pip3 install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12-R4.2.1/cfgai_requirements.txt \
	&& /usr/bin/python3 -m  pip3 install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12-R4.2.1/gpu_requirements.txt \
	&& /usr/bin/python3 -m  pip3 install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/R4.2.1-debian11/semoss_requirements.txt \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.cache

WORKDIR /opt

CMD ["bash"]
