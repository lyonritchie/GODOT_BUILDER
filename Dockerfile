FROM ubuntu:22.04 AS base
LABEL author="gary@lyonritchie.com"

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  cmake \
  curl \
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
  make \
  mingw-w64 \
  openssh-client \
  pkg-config \
  scons \
  unzip \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
  nodejs && \
  rm -rf /var/lib/apt/lists/*

FROM base AS godot

ARG GODOT_VERSION="4.5.1"
ARG RELEASE_NAME="stable"
ARG SUBDIR=""
ARG GODOT_TEST_ARGS=""
ARG GODOT_PLATFORM="linux.x86_64"

# RUN git clone https://github.com/godotengine/godot/tree/${GODOT_VERSION}-${RELEASE_NAME}
RUN git clone --single-branch --branch ${GODOT_VERSION}-${RELEASE_NAME} https://github.com/godotengine/godot.git && \
  rm -rd /godot/.git

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip && \
  unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip && \
  mkdir -p ~/bin && ln -s /Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64 ~/bin/ && \
  rm Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz && \
  mkdir -p /root/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} && \
  unzip -j Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz -d /root/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} && \
  rm Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz

FROM godot AS final

## For HTML builds
# Get the emsdk repo
RUN git clone https://github.com/emscripten-core/emsdk.git
SHELL ["/bin/bash", "-c"]
RUN cd emsdk && ./emsdk install latest && ./emsdk activate latest && \
  source "/emsdk/emsdk_env.sh"
