#docker build . -t quay.io/semoss/docker-r-python:debian12-ai

ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=debian
ARG BASE_TAG=12

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi

ENV PATH="/root/.local/bin:$PATH" 

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=0 \
    POETRY_VIRTUALENVS_CREATE=0 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

RUN apt-get update \
	&& apt-get install -y python3-pip curl \
	&& apt-get install -y tesseract-ocr \
	&& apt-get -y autoremove \
	&& curl -sSL https://install.python-poetry.org | python3 - \
	&& mkdir /opt/py \
	&& cd /opt/py \
	&& curl -O https://raw.githubusercontent.com/SEMOSS/docker-r-python/refs/heads/packages-ai/poetry.lock \
	&& curl -O https://raw.githubusercontent.com/SEMOSS/docker-r-python/refs/heads/packages-ai/poetry.toml \
	&& curl -O https://raw.githubusercontent.com/SEMOSS/docker-r-python/refs/heads/packages-ai/pyproject.toml \
	&& poetry install \
 	&& rm -rf $POETRY_CACHE_DIR

WORKDIR /opt
CMD ["bash"]
