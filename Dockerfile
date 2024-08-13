FROM ghcr.io/gem5/ubuntu-18.04_all-dependencies:v23-0
# Setting the variables that will be used
ARG GEM5_REPO_URL=https://github.com/gem5/gem5.git
ARG GEM5_WORKING_COMMIT=8c8a2f12f2f8b419723e7af8e3851033c41b7b51
ARG VIRTUALENV_DIR=/venv
ARG GEM5_DIR=/gem5
ARG GEM5_ARCH=X86
# Installing the dependencies
RUN python -m pip install virtualenv
RUN virtualenv --python=python2.7 $VIRTUALENV_DIR
ENV PATH=$VIRTUALENV_DIR/bin:$PATH
RUN pip install scons
# Cloning the gem5 repository
RUN mkdir $GEM5_DIR
WORKDIR $GEM5_DIR
# This clones the gem5 repository and checks out the commit specified in the ARG
RUN \
git init . && \
git remote add origin $GEM5_REPO_URL && \
git fetch --depth 1 origin $GEM5_WORKING_COMMIT && \ 
git checkout FETCH_HEAD
# Building gem5
RUN scons build/$GEM5_ARCH/gem5.opt -j$(nproc)
RUN ln -s $GEM5_DIR/build/$GEM5_ARCH/gem5.opt ./gem5
RUN ln -s $GEM5_DIR/build/$GEM5_ARCH/gem5.opt ./gem5.$GEM5_ARCH
# We exclude some directories from the git repository to avoid unnecessary git status checks
RUN echo "orgb_*/" >> $GEM5_DIR/.git/info/exclude
RUN echo "emb_*/" >> $GEM5_DIR/.git/info/exclude
RUN echo "data/" >> $GEM5_DIR/.git/info/exclude
RUN echo ".vscode/" >> $GEM5_DIR/.git/info/exclude
RUN echo "gem5" >> $GEM5_DIR/.git/info/exclude
RUN echo "gem5.*" >> $GEM5_DIR/.git/info/exclude
CMD ["/bin/bash", "-l"]