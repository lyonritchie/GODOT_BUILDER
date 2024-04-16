FROM ubuntu:22.04 AS base
LABEL author="gary@lyonritchie.com"

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  mingw-w64 \
  cmake \
  git \
  git-lfs \
  unzip \
  scons \
  pkg-config \
  libx11-dev \
  libxcursor-dev \
  libxinerama-dev \
  libgl1-mesa-dev \
  libglu-dev \
  libasound2-dev \
  libpulse-dev \
  libudev-dev \
  libxi-dev \
  libxrandr-dev \
  && rm -rf /var/lib/apt/lists/*

FROM base AS final

ARG GODOT_VERSION="4.2.1"
ARG RELEASE_NAME="stable"
ARG SUBDIR=""
ARG GODOT_TEST_ARGS=""
ARG GODOT_PLATFORM="linux.x86_64"

# RUN git clone https://github.com/godotengine/godot/tree/${GODOT_VERSION}-${RELEASE_NAME}
RUN git clone --single-branch --branch ${GODOT_VERSION}-${RELEASE_NAME} https://github.com/godotengine/godot.git

## For HTML builds
# Get the emsdk repo
RUN git clone https://github.com/emscripten-core/emsdk.git
SHELL ["/bin/bash", "-c"]
RUN cd emsdk && ./emsdk install latest && ./emsdk activate latest
# Enter that directory
RUN source "/emsdk/emsdk_env.sh"
