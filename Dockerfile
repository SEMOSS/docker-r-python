#docker build . -t quay.io/semoss/docker-r-python:cuda12.5

ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nvidia/cuda
ARG BASE_TAG=12.5.0-runtime-ubuntu22.04

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"


RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip curl git \
	&& apt-get install -y tesseract-ocr \
	&& apt-get -y autoremove \
	&& curl -sSL https://install.python-poetry.org | python3 - \
	&& mkdir /opt/py

# COPY pyproject.toml poetry.lock poetry.toml /opt/py

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=0 \
    POETRY_VIRTUALENVS_CREATE=0 \
    POETRY_CACHE_DIR=/tmp/poetry_cache
    
ENV PATH="/root/.local/bin:$PATH" 
RUN cd /opt/py \
	&& git clone https://github.com/SEMOSS/docker-r-python.git --branch package-ai --single-branch \
 	&& cd docker-r-python \
	&& poetry install \
	&& poetry install --extras "gpu"  \
 	&& rm -rf $POETRY_CACHE_DIR

 	# &&  /usr/bin/python3 -m  pip install --upgrade -r  https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/semoss_requirements.txt \
	# && /usr/bin/python3 -m  pip install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/cfgai_requirements.txt \
	# && /usr/bin/python3 -m  pip install --upgrade -r https://raw.githubusercontent.com/SEMOSS/docker-r-python/cuda12/gpu_requirements.txt \
	# && apt-get purge -y --auto-remove \
	# && rm -rf /var/lib/apt/lists/* \
	# && rm -rf /root/.cache


#FROM scratch AS final
#COPY --from=builder / /
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base
RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip curl git \
	&& apt-get install -y tesseract-ocr \
	&& apt-get -y autoremove \
	&& curl -sSL https://install.python-poetry.org | python3 - 

COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=builder /opt/py /opt/py
ENV PATH="/root/.local/bin:$PATH" 

WORKDIR /opt
CMD ["bash"]
