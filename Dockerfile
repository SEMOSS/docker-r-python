ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nvidia/cuda
ARG BASE_TAG=12.5.1-runtime-ubuntu22.04

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} AS builder

LABEL maintainer="semoss@semoss.org"


RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    git \
    # python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for uv
ENV UV_LINK_MODE=copy \
UV_COMPILE_BYTECODE=1 \
UV_NO_CACHE=1

# we will install python inside /usr/lib/python/semossvenv
# it is done here to carry forward and limit the duplicated chowns in opt
ENV VIRTUAL_ENV="/usr/lib/python/semossvenv"
ENV UV_PYTHON_INSTALL_DIR="/usr/lib/python"
ENV UV_INSTALL_DIR="/usr/lib/uv/"
ENV PATH=$UV_INSTALL_DIR:$PATH
ENV PATH=$VIRTUAL_ENV/bin:$PATH

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN uv python install 3.12 --default --preview
RUN uv venv --seed $VIRTUAL_ENV


RUN cd /tmp && \
    curl -o pyproject.toml https://raw.githubusercontent.com/SEMOSS/Semoss/refs/heads/dev/py/install_config/pyproject.toml && \
    uv pip install -r pyproject.toml  --extra gpu
	
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} AS final

COPY --from=builder /usr/lib/python /usr/lib/python

ENV VIRTUAL_ENV="/usr/lib/python/semossvenv"
ENV PATH=$VIRTUAL_ENV/bin:$PATH

# Install additional dependencies
RUN apt-get update \
    && apt-get install -y tesseract-ocr \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# FROM scratch AS final
# COPY --from=builder / /
WORKDIR /opt
CMD ["bash"]
