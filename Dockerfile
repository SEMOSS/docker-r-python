#docker build . -t quay.io/semoss/docker-r-python:cuda12-R4.2.1

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-r-packages
ARG BASE_TAG=R4.2.1-debian11
ARG BASE_TAG=cuda12-R4.2.1

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

# Needed for JEP
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.10/dist-packages/jep


# Install Python
# Install PIP
# Install JEP
# Install Pandas

RUN arch=$(uname -m)\
	&& if  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then apt-get -y install libhdf5-dev ; fi
RUN apt-get update \
	&& apt-get install -y python3-pip \
	&& apt-get -y autoremove \
	&& pip3 install jep==3.9.1 \
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
	#&& pip3 install pyarrow \
	&& pip3 install xlrd \
	&& pip3 install pandasql \
	&& pip3 install openai \
	&& pip3 install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 \
	&& pip3 install transformers \
	&& pip3 install openpyxl farm-haystack farm-haystack[faiss] nltk flask gunicorn pytest bs4 \
 	&& pip3 install datasets text-generation sentence_transformers \
  	&& pip3 install protobuf accelerate \
     	&& pip3 install boto3 google-cloud-aiplatform \
      	&& pip3 install jsonpickle \
        && pip3 install peft loralib bitsandbytes \
	&& apt-get purge -y --auto-remove \
	    && rm -rf /var/lib/apt/lists/* \
	    && rm -rf /root/.cache
		

WORKDIR /opt

CMD ["bash"]
