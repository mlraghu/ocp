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

REGISTRY_URL=167641168138.dkr.ecr.us-east-1.amazonaws.com
REGISTRY_NAMESPACE=ocp
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
echo 'building and pushing image cfnodejsapp'
cd source/cfnodejsapp
if [ "${CONTAINER_RUNTIME}" == "docker" ]
then
  docker buildx build --platform ${PLATFORMS} -f Dockerfile  --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp .
else 
  podman manifest create ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp
  podman build --platform ${PLATFORMS} -f Dockerfile --manifest ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp .
  podman manifest push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp
fi

cd -

echo 'done'
