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
	&& apt-get -y autoremove \
	&& pip3 install numpy \
	&& pip3 install pandas \
	&& pip3 install matplotlib \
	&& pip3 install scikit-learn \
	&& pip3 install seaborn \
	&& pip3 install deepdiff \
	&& pip3 install annoy==1.15.2 \
	&& pip3 install fuzzywuzzy \
	&& pip3 install python-Levenshtein \ 
	&& pip3 install pyjarowinkler \
	&& pip3 install swifter \
	&& pip3 install xlrd \
	&& pip3 install pandasql
#&& pip3 install openai
#&& pip install transformers[torch]
#&& pip3 install transformers==4.11.3 \
#&& pip3 install --find-links https://download.pytorch.org/whl/torch_stable.html torch torchvision


WORKDIR /opt

CMD ["bash"]
