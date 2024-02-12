#docker build . -t quay.io/semoss/docker-r-python:ubi8-rhel

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=ubi8-r

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.9/dist-packages/jep


# Install Python
# Install PIP
# Install JEP
# Install Pandas

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN yum install -y python39 python39-devel \
	&& pip3 install numpy \
	&& pip3 install jsonpickle \
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
	#&& pip3 install pyarrow \
	&& pip3 install xlrd \
	&& pip3 install pandasql

#&& pip3 install openai
#&& pip install transformers[torch]
#&& pip3 install transformers==4.11.3 \
#&& pip3 install --find-links https://download.pytorch.org/whl/torch_stable.html torch torchvision


WORKDIR /opt

CMD ["bash"]
