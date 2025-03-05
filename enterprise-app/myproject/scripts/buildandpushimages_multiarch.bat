:: Copyright IBM Corporation 2021
::
::  Licensed under the Apache License, Version 2.0 (the "License");
::   you may not use this file except in compliance with the License.
::   You may obtain a copy of the License at
::
::        http://www.apache.org/licenses/LICENSE-2.0
::
::  Unless required by applicable law or agreed to in writing, software
::  distributed under the License is distributed on an "AS IS" BASIS,
::  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::  See the License for the specific language governing permissions and
::  limitations under the License.

:: Invoke as buildandpush_multiarchimages.bat <registry_url> <registry_namespace> <comma_separated_platforms>
:: Examples:
:: 1) buildandpush_multiarchimages.bat
:: 2) buildandpush_multiarchimages.bat index.docker.io your_registry_namespace
:: 3) buildandpush_multiarchimages.bat quay.io your_quay_username linux/amd64,linux/arm64,linux/s390x
:: 4) ./buildandpush_multiarchimages.bat docker
:: 5) ./buildandpush_multiarchimages.bat podman quay.io your_quay_username linux/amd64,linux/arm64,linux/s390x

@echo off
for /F "delims=" %%i in ("%cd%") do set basename="%%~ni"

if not %basename% == "scripts" (
    echo "please run this script from the 'scripts' directory"
    exit 1
)

REM go to the parent directory so that all the relative paths will be correct
cd ..

SET CONTAINER_RUNTIME=docker
IF "%1"!="" (
    SET CONTAINER_RUNTIME=%1%
    shift
)

IF "%3"=="" GOTO DEFAULT_PLATFORMS
SET PLATFORMS=%3%
GOTO REGISTRY

:DEFAULT_PLATFORMS
    SET PLATFORMS=linux/amd64,linux/arm64,linux/s390x,linux/ppc64le
	GOTO REGISTRY

:REGISTRY
    IF "%2"=="" GOTO DEFAULT_REGISTRY
    IF "%1"=="" GOTO DEFAULT_REGISTRY
    SET REGISTRY_URL=%1
    SET REGISTRY_NAMESPACE=%2
    GOTO DOCKER_CONTAINER_RUNTIME

:DEFAULT_REGISTRY
    SET REGISTRY_URL=default-route-openshift-image-registry.apps-crc.testing
    SET REGISTRY_NAMESPACE=enterprise-app
	GOTO DOCKER_CONTAINER_RUNTIME

:DOCKER_CONTAINER_RUNTIME
	IF NOT "%CONTAINER_RUNTIME%" == "docker" GOTO PODMAN_CONTAINER_RUNTIME
	GOTO MAIN

:PODMAN_CONTAINER_RUNTIME
	IF NOT "%CONTAINER_RUNTIME%" == "podman" GOTO UNSUPPORTED_BUILD_SYSTEM
	GOTO MAIN

:UNSUPPORTED_BUILD_SYSTEM
    echo 'Unsupported build system passed as an argument for pushing the images.'
    GOTO SKIP

:MAIN
:: Uncomment the below line if you want to enable login before pushing
:: docker login %REGISTRY_URL%
echo "building and pushing image customers-buildstage"
pushd source\customers
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage
    podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage
)
popd
echo "building and pushing image gateway-buildstage"
pushd source\gateway
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage
    podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage
)
popd
echo "building and pushing image inventory-buildstage"
pushd source\inventory
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage
    podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage
)
popd
echo "building and pushing image orders-buildstage"
pushd source\orders
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage
    podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage
)
popd
echo "building and pushing image frontend"
pushd source\frontend
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend
    podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend
)
popd
echo "building and pushing image gateway"
pushd source\gateway
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway
    podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway
)
popd
echo "building and pushing image inventory"
pushd source\inventory
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory
    podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory
)
popd
echo "building and pushing image orders"
pushd source\orders
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders
    podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders
)
popd
echo "building and pushing image customers"
pushd source\customers
IF  "%CONTAINER_RUNTIME%" == "docker" (
    docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers . 
) ELSE ( 
    podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers
    podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers .
    podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers
)
popd

echo "done"

:SKIP
