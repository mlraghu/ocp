#!/usr/bin/env bash
#   Copyright IBM Corporation 2020
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

# Invoke as ./pushimages.sh <registry_url> <registry_namespace> <container_runtime>
# Examples:
# 1) ./pushimages.sh
# 2) ./pushimages.sh quay.io your_quay_username
# 3) ./pushimages.sh index.docker.io your_registry_namespace podman

# REGISTRY_URL=167641168138.dkr.ecr.us-east-1.amazonaws.com
REGISTRY_URL=default-route-openshift-image-registry.apps-crc.testing
REGISTRY_NAMESPACE=default
CONTAINER_RUNTIME=docker
if [ "$#" -gt 1 ]; then
  REGISTRY_URL=$1
  REGISTRY_NAMESPACE=$2
fi
if [ "$#" -eq 3 ]; then
    CONTAINER_RUNTIME=$3
fi
if [ "${CONTAINER_RUNTIME}" != "docker" ] && [ "${CONTAINER_RUNTIME}" != "podman" ]; then
   echo 'Unsupported container runtime passed as an argument for pushing the images: '"${CONTAINER_RUNTIME}"
   exit 1
fi
# Uncomment the below line if you want to enable login before pushing
#${CONTAINER_RUNTIME} login ${REGISTRY_URL}
${CONTAINER_RUNTIME} login -u kubeadmin -p $(oc whoami -t) ${REGISTRY_URL}
echo 'pushing image cfnodejsapp'
${CONTAINER_RUNTIME} tag cfnodejsapp ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/cfnodejsapp

echo 'done'
