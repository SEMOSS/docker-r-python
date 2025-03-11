ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=cuda12.2

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} AS builder

LABEL maintainer="semoss@semoss.org"

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables for uv
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_SYSTEM_PYTHON=1

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
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Python 3.12.9
RUN curl -O https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz \
    && tar -xzf Python-3.12.9.tgz \
    && cd Python-3.12.9 \
    && ./configure --enable-optimizations \
    && make -j$(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.12.9 Python-3.12.9.tgz \
    && ln -sf /usr/local/bin/python3.12 /usr/local/bin/python3 \
    && ln -sf /usr/local/bin/python3.12 /usr/local/bin/python \
    && ln -sf /usr/local/bin/pip3.12 /usr/local/bin/pip3 \
    && ln -sf /usr/local/bin/pip3.12 /usr/local/bin/pip

# Install additional dependencies
RUN apt-get update \
    && apt-get install -y tesseract-ocr \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
COPY pyproject.toml .
RUN uv pip install -r pyproject.toml --extra gpu

FROM scratch AS final
COPY --from=builder / /
WORKDIR /opt
CMD ["bash"]
