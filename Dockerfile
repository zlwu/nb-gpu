FROM nvidia/cuda:8.0-cudnn5-devel

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Depends
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

# Install miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda create -q -n py2 python=2.7 numpy scipy matplotlib jupyter notebook ipython scikit-learn pandas nose sympy opencv pillow pyyaml h5py theano 
RUN conda create -q -n py3 python=3.5 numpy scipy matplotlib jupyter notebook ipython scikit-learn pandas nose sympy opencv pillow pyyaml h5py theano 

RUN /bin/bash -c "source activate py2 && conda update --all -yq && ipython kernel install --user && pip -q --no-cache-dir install tensorflow-gpu keras && source deactivate"
RUN /bin/bash -c "source activate py3 && conda update --all -yq && ipython kernel install --user && pip -q --no-cache-dir install tensorflow-gpu keras && source deactivate"

COPY run_jupyter.sh /

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py

VOLUME /notebooks
WORKDIR /notebooks

# TensorBoard
EXPOSE 6006

# IPython
EXPOSE 8888

ENTRYPOINT [ "/tini", "--" ]
CMD ["/run_jupyter.sh"]

