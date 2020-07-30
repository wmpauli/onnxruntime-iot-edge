##############################################
## Get the latest base image for the Jetpack
#############################################
FROM nvcr.io/nvidia/l4t-base:r32.4.2

# Make it so that docker doesn't request user interaction and break
ENV DEBIAN_FRONTEND=noninteractive

# Update repositories and install numpy, opencv, pip, and some other libaries
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential g++-arm-linux-gnueabihf cmake curl libssl-dev python3 python3-pip\
    python3-opencv libcurl4-openssl-dev libboost-python1.65-dev libpython3-dev libatlas-base-dev && \
    rm -rf /var/lib/apt/lists/* 

RUN pip3 install --upgrade pip
RUN pip3 install setuptools
RUN pip3 install --upgrade numpy

# Download python wheel published by NVIDIA
# ONNX Runtime (for JetPack 4.4 DP)
#
#  ONNX Runtime v.1.4.0 https://nvidia.box.com/shared/static/8sc6j25orjcpl6vhq3a4ir8v219fglng.whl (onnxruntime_gpu-1.4.0-cp36-cp36m-linux_aarch64.whl)

RUN wget https://nvidia.box.com/shared/static/8sc6j25orjcpl6vhq3a4ir8v219fglng.whl -O onnxruntime_gpu-1.4.0-cp36-cp36m-linux_aarch64.whl && \
    pip3 install onnxruntime_gpu-1.4.0-cp36-cp36m-linux_aarch64.whl

# Set paths for gpu libraries
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu-override/tegra/:/usr/lib/aarch64-linux-gnu-override/:/usr/lib/aarch64-linux-gnu/:/usr/local/cuda-10.2/targets/aarch64-linux/lib/:/usr/local/cuda-10.2/:/usr/local/cuda/:/usr/lib/aarch64-linux-gnu:/usr/lib/aarch64-linux-gnu/tegra:${LD_LIBRARY_PATH}
ENV PATH=/usr/local/cuda/bin:/usr/bin:/bin:${PATH}

# Remove old Azure and ONNX wheels and get licenses
RUN rm -rf *.whl

# install IOT Edge packages
RUN pip3 install azure-iot-hub azure-iot-device azure-iothub-provisioningserviceclient

LABEL maintainer="onnxcoredev@microsoft.com"
LABEL description="This is a preview release for the ONNX Runtime on nVidia Jetpack 4.4."
LABEL version="v1.4"