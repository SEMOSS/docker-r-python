#docker build . -t quay.io/semoss/docker-r-python:cuda12.5

ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nvidia/cuda
ARG BASE_TAG=12.5.0-runtime-ubuntu22.04

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"


RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip curl \
	&& apt-get install -y tesseract-ocr \
	&& apt-get -y autoremove \
 	&&  /usr/bin/python3 -m  pip install --upgrade -r  https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/semoss_requirements.txt \
	&& /usr/bin/python3 -m  pip install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/cfgai_requirements.txt \
	&& /usr/bin/python3 -m  pip install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/gpu_requirements.txt \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.cache

FROM scratch AS final
COPY --from=builder / /
WORKDIR /opt
CMD ["bash"]
