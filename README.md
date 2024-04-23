# JupyterLab with Julia (and Python) kernels

Source code of the JupyterLab Julia o²S²PARC Service, providing a JupyterLab coding environment for creating interactive Jupyter Notebooks with Julia (or Python).

## How to develop this o²S²PARC Service

This Service was build using the [o²S²PARC cookiecutter for JupyterLab services](https://github.com/ITISFoundation/cookiecutter-osparc-jupyterlab-service)
### Usage

Build the module:
```console
$ make build
```
To run locally at and visit http://127.0.0.1:8888
```console
make run-local
```
To publish in local throw-away registry:
```console
make publish-local
```


### Versioning
Service version is updated with ``make version-*``

### CI/CD Integration 
A template ci config file is created in ```.github/workflows/check-image.yml```, it checks that the image builds. When the workflow runs successfully for a new version (on the main branch), this is automatically detected and published on the internal registry (see also "Deployment on o²S²PARC" in this README)

### Deployment on o²S²PARC

The required CI is already packaged.
To build and push to the internal registry you must add it to the [oSparc/docker-publisher-osparc-services](https://git.speag.com/oSparc/docker-publisher-osparc-services) repository.

## How to test the Application
Run locally and visit http://127.0.0.1:8888:
```console
make run-local
```
Or publish it in a local o²S²PARC deploy:
```console
make publish-local
```
Execute the [notebook demo](https://github.com/binder-examples/demo-julia/blob/581378d6c09d097b2d3c1c2ce0287d6f3a0e5769/demo.ipynb) from the mybinder project.