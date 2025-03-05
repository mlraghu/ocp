#!/usr/bin/env bash
#   Copyright IBM Corporation 2021
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# Invoke as ./buildandpush_multiarchimages.sh <registry_url> <registry_namespace> <comma_separated_platforms>
# Examples:
# 1) ./buildandpush_multiarchimages.sh
# 2) ./buildandpush_multiarchimages.sh index.docker.io your_registry_namespace
# 3) ./buildandpush_multiarchimages.sh quay.io your_quay_username linux/amd64,linux/arm64,linux/s390x
# 4) ./buildandpush_multiarchimages.sh docker
# 5) ./buildandpush_multiarchimages.sh podman quay.io your_quay_username linux/amd64,linux/arm64,linux/s390x

if [[ "$(basename "$PWD")" != 'scripts' ]] ; then
  echo 'please run this script from the "scripts" directory'
  exit 1
fi

cd .. # go to the parent directory so that all the relative paths will be correct

REGISTRY_URL=default-route-openshift-image-registry.apps-crc.testing
REGISTRY_NAMESPACE=enterprise-app
PLATFORMS="linux/amd64,linux/arm64,linux/s390x,linux/ppc64le"
CONTAINER_RUNTIME=docker

if [ "$#" -gt 0 ] && [[ "$1" == "docker" || "$1" == "podman" ]]; then
  CONTAINER_RUNTIME=$1
  shift;
fi

if [ "$#" -gt 1 ]; then
  REGISTRY_URL=$1
  REGISTRY_NAMESPACE=$2
fi
if [ "$#" -eq 3 ]; then
  PLATFORMS=$3
fi

if [ "${CONTAINER_RUNTIME}" != "docker" ] && [ "${CONTAINER_RUNTIME}" != "podman" ]; then
   echo 'Unsupported container runtime passed as an argument for building the images: '"${CONTAINER_RUNTIME}"
   exit 1
fi


# Uncomment the below line if you want to enable login before pushing
# docker login ${REGISTRY_URL}
echo 'building and pushing image customers-buildstage'
cd source/customers
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage
  podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers-buildstage
fi

cd -
echo 'building and pushing image gateway-buildstage'
cd source/gateway
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage
  podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway-buildstage
fi

cd -
echo 'building and pushing image inventory-buildstage'
cd source/inventory
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage
  podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory-buildstage
fi

cd -
echo 'building and pushing image orders-buildstage'
cd source/orders
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile.buildstage  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage
  podman build --platform ${PLATFORMS} -f Dockerfile.buildstage --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders-buildstage
fi

cd -
echo 'building and pushing image frontend'
cd source/frontend
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend
fi

cd -
echo 'building and pushing image gateway'
cd source/gateway
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway
fi

cd -
echo 'building and pushing image inventory'
cd source/inventory
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory
fi

cd -
echo 'building and pushing image orders'
cd source/orders
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders
fi

cd -
echo 'building and pushing image customers'
cd source/customers
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers
fi

cd -

echo 'done'
