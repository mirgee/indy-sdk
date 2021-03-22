ARG WRAPPER_BASE_IMAGE
FROM ${WRAPPER_BASE_IMAGE}

RUN apt-get update && \
    apt-get install -y \
      python3.5 \

RUN curl -fsSL -o- https://bootstrap.pypa.io/pip/3.5/get-pip.py | python3.5

RUN pip3 install -U \
	pip==20.3.3 \
	setuptools==51.3.3 \
	twine==3.3.0
