# syntax = docker/dockerfile:1.2

FROM python:3.9 as base

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        vim \
        gcc \
        build-essential \
        zlib1g-dev \
        wget \
        unzip \
        cmake \
        gfortran \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        libasound-dev \
        libportaudio2 \
        libportaudiocpp0 \
        portaudio19-dev \
        ffmpeg \
        libsm6 \
        libxext6 \
        openjdk-11-jre-headless \
    && apt-get clean


FROM base as build

SHELL ["/bin/bash", "-c"]

WORKDIR /eliza
COPY . ./

RUN make clean
RUN make build
RUN make build

#RUN make clean & make build & make build


# To build a specfic stage only use the --target option, e.g.:
# docker build --target build --tag build:0.0.1 .
FROM base as eliza

COPY --from=build /eliza/cltl-eliza-app /eliza/cltl-eliza-app/

WORKDIR /eliza/cltl-eliza-app

WORKDIR /eliza/cltl-eliza-app/py-app
CMD source /eliza/cltl-eliza-app/venv/bin/activate && python app.py
