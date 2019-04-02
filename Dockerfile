FROM ubuntu:18.04

# avoid questions from debconf
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y wget curl sudo vim libxt-dev libglu1-mesa-dev

# create the group mne_group and user mne_user
RUN groupadd mne_group && useradd -m -b /home/ -g mne_group mne_user

# add mne_user to the sudo group
RUN adduser mne_user sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER mne_user
WORKDIR /home/mne_user

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda.sh && \
    bash ~/miniconda.sh -b -p $HOME/miniconda

RUN $HOME/miniconda/bin/conda update -n base -c defaults conda
RUN $HOME/miniconda/bin/conda init bash
RUN echo 'conda activate mne' >> $HOME/.bashrc

RUN curl -O https://raw.githubusercontent.com/blakecaldwell/mne-python/mayavi_linux/environment.yml
RUN $HOME/miniconda/bin/conda env create -f environment.yml
RUN $HOME/miniconda/envs/mne/bin/pip install https://api.github.com/repos/enthought/mayavi/zipball/226189a6ad3dc3c01d031ef21d0d0cde554ac851 PySurfer[save_movie]

# create the hnn shared folder (don't rely on docker daemon
# to create it)
RUN mkdir $HOME/shared

# run sudo to get rid of message on first login about using sudo
RUN sudo -l

CMD sleep infinity
