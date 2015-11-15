FROM b.gcr.io/tensorflow/tensorflow

MAINTAINER ZL WU <zilong.wu@gmail.com>

ADD ./tensorflow-0.5.0-cp27-none-linux_x86_64.whl /tmp/

RUN pip uninstall -y tensorflow && pip install /tmp/tensorflow-0.5.0-cp27-none-linux_x86_64.whl && rm -rf /tmp/tensorflow-*.whl

# Add to path
ENV PATH=/usr/local/cuda/bin:$PATH \
  LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

VOLUME /workspace
WORKDIR /workspace
