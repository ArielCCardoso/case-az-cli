FROM alpine
ARG IMAGE="alpine"
ARG AZ_CLI=2.0
ARG PY_VERSION=3.8

LABEL BaseImage=${IMAGE}                                   \
      Author="Ariel C. Cardoso <arielccardoso@live.com>"   \
      Microsoft.Azure.CLI.Version=${AZ_CLI}                \
      Python.Version=${PY_VERSION}

USER root

ENV PYTHON_VERSION ${PY_VERSION}
ENV AZ_VERSION ${AZ_CLI}

RUN apk add --no-cache python3~=${PYTHON_VERSION} python3-dev~=${PYTHON_VERSION} \
    && ln -s $(which pip3) /usr/bin/pip \
    && ln -s $(which python3) /usr/bin/python \
    && apk add --no-cache bash openssh ca-certificates tar zip unzip jq curl openssl git \
    && apk add --no-cache --virtual .build-deps gcc make openssl-dev libffi-dev musl-dev \
    && update-ca-certificates

RUN pip --no-cache-dir install azure-cli~=${AZ_VERSION}

COPY entrypoint /entrypoint

RUN chmod 755 /entrypoint

ENTRYPOINT ["/entrypoint"]