FROM caldweba/opengl-docker

# create the group mne_group and user mne_user
RUN groupadd mne_group && useradd -m -b /home/ -g mne_group mne_user

# add mne_user to the sudo group
RUN usermod -G sudo mne_user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER mne_user
WORKDIR /home/mne_user

RUN wget --no-check-certificate -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda.sh && \
    bash ~/miniconda.sh -b -p $HOME/miniconda

RUN $HOME/miniconda/bin/conda update -n base -c defaults conda
RUN $HOME/miniconda/bin/conda init bash
RUN echo 'export PATH=$PATH:$HOME/miniconda/bin/' >> $HOME/.bashrc
RUN echo 'conda activate mne' >> $HOME/.bashrc

RUN wget --no-check-certificate -q https://raw.githubusercontent.com/blakecaldwell/mne-python/mayavi_linux/environment.yml && \
    $HOME/miniconda/bin/conda env create -f environment.yml && \
    $HOME/miniconda/bin/conda clean -yaf

RUN sudo apt-get install -y --no-install-recommends \
      llvm-5.0 \
      libsm6 \
      libx11-6 \
      libxext6 \
      libx11-xcb1 \
      qt5dxcb-plugin

#still need to install mayavi and PySurfer[save_movie]
RUN $HOME/miniconda/envs/mne/bin/pip install https://api.github.com/repos/enthought/mayavi/zipball/226189a6ad3dc3c01d031ef21d0d0cde554ac851 PySurfer[save_movie] && 
    rm -rf $HOME/.cache

# create the hnn shared folder (don't rely on docker daemon
# to create it)
RUN mkdir $HOME/shared

# run sudo to get rid of message on first login about using sudo
RUN sudo -l

RUN mkdir $HOME/.jupyter && \
    echo 'c.NotebookApp.ip = "0.0.0.0"' > $HOME/.jupyter/jupyter_notebook_config.py && \
    echo 'c.NotebookApp.open_browser = False' >> $HOME/.jupyter/jupyter_notebook_config.py

CMD sleep infinity
