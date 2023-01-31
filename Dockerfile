FROM docker.io/ubuntu:20.04
LABEL description="sam-artifact"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y ppa:zeehio/libxp && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        wget \
	curl \
        git make gcc-9 g++-9 \
        python3 python3-dev python3-pip python3-venv \
        graphviz \
        xxd \
        time \
        vim \
        && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 100 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 100 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 \
                        --slave   /usr/bin/g++ g++ /usr/bin/g++-9 && \
    pip install cmake && \
    wget -nv -O ~/clang7.tar.xz http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz && \
    tar -xvf ~/clang7.tar.xz --strip-components=1 -C /usr/ && \
    rm -rf ~/clang7.tar.xz

# Switch shell to bash
SHELL ["/bin/bash", "--login", "-c"]


COPY . /sam-artifact
WORKDIR /sam-artifact
RUN python -m venv .

WORKDIR /sam-artifact/sam
RUN source /sam-artifact/bin/activate && pip install scipy numpy pytest tqdm pytest-benchmark matplotlib pandas pydot pyyaml && pip install -e .
RUN apt-get install -y python-tk
RUN make sam

COPY ./taco-website /sam-artifact/taco-website
WORKDIR /sam-artifact

RUN echo "source /sam-artifact/bin/activate" >> /root/.bashrc
RUN mkdir SS
RUN mkdir SS_F
RUN echo "export SUITESPARSE_PATH=/sam-artifact/SS" >> /root/.bashrc
RUN echo "export SUITESPARSE_FORMATTED_PATH=/sam-artifact/SS_F" >> /root/.bashrc
RUN echo "export SAM_HOME=/sam-artifact/sam/" >> /root/.bashrc
