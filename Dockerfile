FROM ubuntu:22.04 AS base
LABEL author="gary@lyonritchie.com"

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  cmake \
  fontconfig \
  git \
  git-lfs \
  libasound2-dev \
  libfontconfig \
  libgl1-mesa-dev \
  libglu-dev \
  libpulse-dev \
  libudev-dev \
  libx11-dev \
  libxcursor-dev \
  libxi-dev \
  libxinerama-dev \
  libxrandr-dev \
  mingw-w64 \
  pkg-config \
  scons \
  unzip \
  wget \
  && rm -rf /var/lib/apt/lists/*

FROM base AS godot

ARG GODOT_VERSION="4.5"
ARG RELEASE_NAME="stable"
ARG SUBDIR=""
ARG GODOT_TEST_ARGS=""
ARG GODOT_PLATFORM="linux.x86_64"

# RUN git clone https://github.com/godotengine/godot/tree/${GODOT_VERSION}-${RELEASE_NAME}
RUN git clone --single-branch --branch ${GODOT_VERSION}-${RELEASE_NAME} https://github.com/godotengine/godot.git

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip
RUN unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

FROM godot AS final

## For HTML builds
# Get the emsdk repo
RUN git clone https://github.com/emscripten-core/emsdk.git
SHELL ["/bin/bash", "-c"]
RUN cd emsdk && ./emsdk install latest && ./emsdk activate latest
# Enter that directory
RUN source "/emsdk/emsdk_env.sh"
