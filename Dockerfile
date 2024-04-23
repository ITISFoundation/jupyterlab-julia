





# Follow the instructions below to install the desired julia version in the base Jupyterlab image
FROM "quay.io/jupyter/minimal-notebook:python-3.11" as base


LABEL maintainer=elisabettai

ENV JUPYTER_ENABLE_LAB="yes"
# autentication is disabled for now
ENV NOTEBOOK_TOKEN=""
ENV NOTEBOOK_BASE_DIR="$HOME/work"

USER root

ENV HOME="/home/$NB_USER"

# --------------- Add additional system libraries -------------------
# TODO: do you need additional system libraries (e.g. zip, bc, etc...)?
# If yes, uncomment the following and adapt
# If not, remove the following (or leave commented)

# RUN apt-get update && \
#   apt-get install -y --no-install-recommends \
#   bc \
#   zip \
#   && \
#   apt-get clean && rm -rf /var/lib/apt/lists/* 






 

USER root
ENV COOKIE_JULIA_VERSION=1.6.0

ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia

# Setup Julia
COPY setup-scripts/ /opt/setup-scripts
RUN /opt/setup-scripts/setup_julia.py ${COOKIE_JULIA_VERSION}

USER ${NB_UID}

# Setup IJulia kernel
RUN /opt/setup-scripts/setup-julia-packages.bash

# ------------------------- Other kernel -------------------------------------------
# This will install the additional packages that from you Project.toml and Manifestl.toml in the pre-existing Julia kernel.
COPY --chown=$NB_UID:$NB_GID env-config/julia/* ${JULIA_PKGDIR}
RUN julia --project=${JULIA_PKGDIR} -e 'using Pkg; Pkg.instantiate()'
## ------------------------------------------------------------------------


# ---------------- Final setup  --------------------------------------------------------

USER root

RUN apt-get update && \
   apt-get install -y --no-install-recommends \
   gosu \
   && \
   apt-get clean && rm -rf /var/lib/apt/lists/* 

# Run a script from the base image to fix files permission
#RUN fix-permissions /home/$NB_USER

# copy README and CHANGELOG
COPY --chown=$NB_UID:$NB_GID README.ipynb ${NOTEBOOK_BASE_DIR}/README.ipynb
COPY --chown=$NB_UID:$NB_GID CHANGELOG.md ${NOTEBOOK_BASE_DIR}/CHANGELOG.md

# remove write permissions from files which are not supposed to be edited
RUN chmod gu-w ${NOTEBOOK_BASE_DIR}/CHANGELOG.md && \
  chmod gu-w ${NOTEBOOK_BASE_DIR}/${REQ_FILE}

RUN mkdir --parents "/home/${NB_USER}/.virtual_documents" && \
  chown --recursive "$NB_USER" "/home/${NB_USER}/.virtual_documents"
ENV JP_LSP_VIRTUAL_DIR="/home/${NB_USER}/.virtual_documents"

# Copying boot scripts
COPY --chown=$NB_UID:$NB_GID boot_scripts/ /docker

ENTRYPOINT [ "/bin/bash", "/docker/entrypoint.bash" ]