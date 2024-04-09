#docker build . -t quay.io/semoss/docker-r-python:ubi8-rhel

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=ubi8-rhel

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN yum install -y python39 python39-devel \
	&& curl -s https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/semoss_requirements.txt | grep -v 'jep==3.9.1' | /usr/bin/python3 -m pip install --upgrade -r /dev/stdin

FROM scratch AS final
COPY --from=builder / /
WORKDIR /opt
CMD ["bash"]
