ARG WRAPPER_BASE_IMAGE
FROM ${WRAPPER_BASE_IMAGE}

USER root

RUN apt-get update && \
    apt-get install -y \
      python3.6 \
      python3-pip

USER indy

RUN pip3 install -U \
	pip==20.3.3 \
	setuptools==51.3.3 \
	twine==3.3.0
